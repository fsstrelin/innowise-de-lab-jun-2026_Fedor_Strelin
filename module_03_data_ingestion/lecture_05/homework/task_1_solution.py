# Входные данные "сырого" кассового лога
raw_log = "ORDER-2025-01-15|FRT-APPLE-PL|+111 (23) 456-78-90| мИНсК "

# Распаковка "сырого" кассового лога в 4 переменных с "сырыми" данными
order_id, product_code, raw_phone, raw_city = raw_log.split("|")

# Сохранение значений категории и региона из product_code в отдельные переменные
category = product_code[:3]
region = product_code[-2:]

# Поиск позиции первого дефиса в коде товара
print(f"Позиция первого дефиса в коде товара: {product_code.find('-')}")

# Проверка категории товара по его коду
if product_code.startswith("FRT"):
    print("Код товара начинается с 'FRT'")
else:
    print("Код товара не начинается с 'FRT'")

# Очистка "сырого" номера телефона с записью в новую переменную
clean_phone = ""
for char in raw_phone:
    if char.isnumeric():
        clean_phone += char
print(f"Длина номера телефона:{len(clean_phone)}")

# Приведение названия города в нормальный вид с записью в новую переменную
clean_city = raw_city.strip().lower().title()

# Создание переменной report, содержащей все данные из кассового лога в нормальном виде
report = f"Заказ:{order_id}\nКатегория:{category}|Регион:{region}\nТелефон:{clean_phone}\nГород:{clean_city}"
print(report)
