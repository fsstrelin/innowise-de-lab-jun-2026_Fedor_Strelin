# "Сырые" входные данные
product = " фермерский ТВОРОГ "
price = 4.567
qty = 3
csv_row = "milk,bread,cheese"
review = "Это лучший ТВОРОГ в городе!"
file_path = r"C:\EcoMarket\data\2025\january\sales.csv"

# Нормализация и сохранение названия товара в новую переменную  clean_product
clean_product = product.strip().lower().title()

# Формирование и вывод чека
total = price * qty  # Итоговая сумма чека
receipt = f'Чек "EcoMarket"\nТовар:\t{clean_product}\nКол-во:\t{qty}\nИтого:\t{total:.2f} руб.'
print(receipt)

# Замена разделителя в строке из .csv-файла
print("|".join(csv_row.split(",")))  # комбинация .join и .split

# Проверка наличия ключевого слова в отзыве
if "творог" in review.lower():
    print("Отзыв относится к категории: Dairy")

# Вывод пути к файлу при помощи raw-строки позволяет корректно обработать символы "\" в адресе
print(rf"{file_path}")
