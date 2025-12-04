import logging

import numpy as np
import pandas as pd
import psycopg2
from psycopg2 import Error

logging.basicConfig(
    level=logging.INFO,
    format="[%(levelname)s] %(message)s",
)


#функция чтения файла
def read_file_csv(path):
    logging.info(f"Чтение файла: {path}")

    try:
        reader = pd.read_csv(path)
    except pd.errors.EmptyDataError:
        logging.error(f"Файл пустой: {path}")
        return None

    logging.info(f"Чтение файла {path} завершено")
    return reader


#функция для замены nan значений по ключу
def replacing_empty_values(df, conceived, key):
    logging.info(f"Замена nan в {df}[{conceived}]")
    dictionary = (df[df[conceived].notna()].drop_duplicates(subset=[key]).set_index(key)[conceived])

    logging.info(f"Замена nan в {df}[{conceived} завершена")
    return df[conceived].fillna(df[key].map(dictionary))


#функция обработки sales
def transform_sales(df) -> pd.DataFrame:
    logging.info(f"Обработка sales")

    df['quantity'] = df['quantity'].fillna(value=0)
    df['unit_price'] = df['unit_price'].fillna(value=0)
    df['order_date'] = pd.to_datetime(df['order_date'], format='mixed')

    df_conceived_key = [
        ("product_id", "product_name"),
        ("product_name", "product_id"),
        ("unit_price", "product_id"),
        ("category", "product_id")
    ]

    for conceived, key in df_conceived_key:
        if df[conceived].isna().sum() > 0:
            df[conceived] = replacing_empty_values(df, conceived, key)

    df = df.drop_duplicates()

    df['total_price'] = df['quantity'] * df['unit_price']
    df['period_date'] = df['order_date'].dt.to_period("M")
    df['month'] = df['order_date'].dt.month_name(locale='ru_RU')

    logging.info(f"Обработка sales завершена")
    return df


#функция заменяет почтовые адреса
def cleanup_email(email):
    if pd.isna(email):
        return pd.NA

    email = str(email).strip()

    if '@' not in email or email.count('@') > 1:
        return pd.NA

    if not (email.endswith('.ru') or email.endswith('.com')):
        return pd.NA

    return email


#функция обработки customer_df
def transform_customer(df) -> pd.DataFrame:
    logging.info(f"Обработка customer")
    df['registration_date'] = pd.to_datetime(df['registration_date'], format='mixed')

    df["email"] = df["email"].apply(cleanup_email)

    df = df.drop_duplicates()

    today = pd.Timestamp.today().normalize().to_datetime64()
    df['customer_days'] = (today - df['registration_date']).dt.days

    logging.info(f"Обработка customer завершена")
    return df


#функция создания sales_summary_df
def build_sales_summary(df):
    logging.info(f"Создание sales_summary")
    summary = (df.groupby(["category", "period_date"], as_index=False).agg(
        total_sales=("total_price", "sum"),
        total_quantity=("quantity", "sum"),
        average_order_value=("total_price", 'mean')
        )
    )

    logging.info(f"Создание sales_summary завершено")
    return summary


#функция расчета среднего чека по регионам
def calculate_avg_price_region(sales_df, customers_df):
    logging.info(f"Расчет среднего чека по регионам")
    sales_df = sales_df.merge(customers_df[['customer_id', 'region']], on='customer_id', how="left")
    mean_price_region = sales_df.groupby('region')['total_price'].mean()

    logging.info(f"Расчет среднего чека по регионам завершен")
    return mean_price_region


#функция создания product_ranking_df
def build_product_ranking(df):
    logging.info(f"Создание product_ranking")
    ranking = df.groupby('product_name').agg(
        product_id=("product_id", "unique"),
        total_sold=('quantity', 'sum'),
        total_revenue=('total_price', 'sum')
    )

    ranking['rank_position'] = ranking['total_sold'].rank(method='first', ascending=False).astype(int)

    logging.info(f"Создание product_ranking завершено")
    return ranking


def get_connect():
    return psycopg2.connect(
        user='myuser',
        password='mypass',
        host='localhost',
        port="5433",
        database='mydb'
    )


def load_df(cursor, df, table_name, columns):
        columns_str = ", ".join(columns)
        fillers = ", ".join(["%s"] * len(columns))

        sql = f'INSERT INTO {table_name} ({columns_str}) VALUES ({fillers})'

        record_df = df[columns]

        for row in record_df.itertuples(index=False, name=None):
            cursor.execute(sql, row)


def main():
    sales_df = read_file_csv('./data/sales.csv')
    sales_df = transform_sales(sales_df)

    customers_df = read_file_csv('./data/customers.csv')
    customers_df = transform_customer(customers_df)

    sales_summary_df = build_sales_summary(sales_df)

    mean_price_region = calculate_avg_price_region(sales_df, customers_df)
    print(mean_price_region)

    product_ranking_df = build_product_ranking(sales_df)

    top_five_product_ranking = product_ranking_df.sort_values('rank_position').head(5)
    print(top_five_product_ranking)

    try:
        connection = get_connect()
        cursor = connection.cursor()
        cursor.execute("SELECT version();")
        record = cursor.fetchone()
        logging.info(f"Подключено к {record}")

        logging.info(f"Загрузка данных в бд")
        load_df(
            cursor, sales_df,
            "sales",
            [
                "order_id",
                "customer_id",
                "product_id",
                "product_name",
                "quantity",
                "unit_price",
                "total_price",
                "order_date",
                "category",
                "month"
            ],
        )

        load_df(
            cursor, customers_df,
            "customers",
            [
                "customer_id",
                "customer_name",
                "email",
                "registration_date",
                "region",
                "customer_days"
            ],
        )

        load_df(
            cursor, sales_summary_df,
            "sales_summary",
            [
                "category",
                "total_sales",
                "total_quantity",
                "average_order_value",
                "period_date"
            ],
        )

        load_df(
            cursor, product_ranking_df,
            "product_ranking",
            [
                "product_id",
                "product_name",
                "total_sold",
                "total_revenue",
                "rank_position"
            ],
        )

        connection.commit()
        logging.info(f"Загрузка данных в бд завершена")
    except (Exception, Error) as error:
        logging.error("Ошибка при работе с PostgreSQL:" + str(error))
    finally:
        if connection:
            connection.close()
            cursor.close()
        logging.info(f"Соединение с PostgreSQL закрыто")



if __name__ == "__main__":
    main()