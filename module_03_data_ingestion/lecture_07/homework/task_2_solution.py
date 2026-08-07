# Инициализация данных (карточка товара)
product = {"id": 105, "name": "Organic Buckwheat", "price": 3.50, "stock": 100}

# Обновление данных карточки товара
product["price"] = 4.20
product["category"] = "Grains"
discount_rate = product.get("discount", 0)

# Вывод итоговых значений
print(product)
print(discount_rate)
