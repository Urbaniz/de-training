import pandas as pd
import random
import randomtimestamp as rts

users = []
timestamp = []
url = []
response_time = []
status_code = []

url_list = ['/filter','/image','/product','/settings','/blog']
st_list = [200, 201, 204, 301, 302, 400, 401, 403, 404, 429, 500, 502, 503]


for i in range(1000000):
    users.append(random.randint(0, 1000))
    timestamp.append(rts.randomtimestamp(start_year=2020, end_year=2025, text=True))
    url.append('https://edu.ru' + url_list[random.randint(0, len(url_list)-1)])
    response_time.append(random.randint(10, 1000))
    status_code.append(st_list[random.randint(0, len(st_list)-1)])

df = {
    'timestamp': timestamp,
    'user_id': users,
    'url': url,
    'response_time': response_time,
    'status_code': status_code
}

df = pd.DataFrame(df)

df["timestamp"] = pd.to_datetime(df["timestamp"], format='mixed')
df = df.sort_values('timestamp')

df.to_csv("web_logs.csv", index=False)
