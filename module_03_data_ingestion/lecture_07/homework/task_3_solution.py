# Инициализация данных
suppliers_log = [
    "FreshFarm Inc",
    "GreenFields Ltd",
    "AgroWorld Co",
    "FreshFarm Inc",
    "GreenFields Ltd",
]

# Преобразование списка suppliers_log в множество
unique_suppliers = set(suppliers_log)

# Добавление значения в множество поставщиков
unique_suppliers.add("GreenFields Ltd")

# Проверка наличия "FreshFarm Inc" среди поставщиков
print("FreshFarm Inc" in suppliers_log)

# Вывод итогового множества уникальных поставщиков и количества элементов в нём
print(unique_suppliers)
print(len(unique_suppliers))
