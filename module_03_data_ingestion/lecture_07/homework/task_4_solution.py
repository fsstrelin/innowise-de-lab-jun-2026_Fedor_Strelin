# Инициализация данных (словарь с названиями товаров и их ценами в исходной валюте)
usd_prices = {"Banana": 1.2, "Mango": 2.5, "Avocado": 2.0}

# Создание словаря с названиями товаров и их ценами в другой валюте (курс 0.9)
eur_prices = {name: price * 0.9 for name, price in usd_prices.items()}

# Вывод созданного словаря
print(eur_prices)
