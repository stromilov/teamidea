#3b.
#Задача: Написать программу, которая на основании запроса 
#        данных с сайта http://www.cbr.ru/scripts/XML_daily.asp 
#        определит курс гонконского доллара к российскому рублю


#Решение:

from bs4 import BeautifulSoup
import requests
 
 
url = 'http://www.cbr.ru/scripts/XML_daily.asp'
 
page = requests.get(url)
soup = BeautifulSoup(page.text, 'lxml')
text1 = soup.findAll('name')
text2 = soup.findAll('value')
 
for i, word in enumerate(text1):
    if -1 != str(word).find('Гонконг'):
        print('Курс:', 
            list(text2[i])[0], 'рублей к одному',
            list(word)[0])


#Вывод:
#Курс: 99,0597 рублей к одному Гонконгских долларов