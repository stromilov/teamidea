#3a.
#Задача: Написать программу, которая на основании запроса к погодному 
#        сервису https://openweathermap.org/ выведет среднюю и максимальную 
#        прогнозную утреннюю (morn) температуру в Вашем 
#        городе (в запросе можно указывать широту и долготу вместо 
#        идентификатора города) за предстоящие 5 дней (включая сегодняшний) 
#        в градусах Цельсия.
#        Подобный запрос потребует регистрации на данном ресурсе 
#        с использованием бесплатного плана (Free).


#Решение:

import requests, json
from datetime import datetime

key = 'a44679946d1d9be3654029601c31b45f'
city = 'Krasnoyarsk'
lang = 'ru'
units = 'metric'
#url = "https://api.openweathermap.org/data/2.5/onecall?lat={56.018390}&lon={92.867170}&dt={}&exclude={'current'}&appid={'a44679946d1d9be3654029601c31b45f'}&lang={'ru'}&units={'metric'}"
#url = f'https://api.openweathermap.org/data/2.5/weather?q={city}&appid={key}&lang={lang}&units={units}'
url = f'https://api.openweathermap.org/data/2.5/forecast?q={city}&appid={key}&lang={lang}&units={units}'
page = requests.get(url)
weather = json.loads(page.text)
temp = 0

for i in weather['list']:
    if -1 != i['dt_txt'].find('09:'):
        temp += i['main']['temp']

print('Средняя температура за 5 дней утром: ', temp / 5, '˚C', sep='')

#print(weather['list'][i]['main']['temp'], datetime.utcfromtimestamp( weather['list'][i]['dt'] ).strftime("%Y-%m-%d %H:%M:%S"), weather['list'][i]['dt_txt'])

#print(weather['main']['temp'])

#print(weather['timezone'])

#Вывод:
#Средняя температура за 5 дней утром: 4.534000000000001˚C