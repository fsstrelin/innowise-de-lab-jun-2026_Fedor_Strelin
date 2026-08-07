# Инициализация данных (координаты склада)
center_coords = (40.7128, -74.0060)

# Далее ошибочная операция (TypeError: 'tuple' object does not support item assignment)
# center_coords[1] = 41.0000

# Вывод значения, типа и длины кортежа с координатами склада
print(f"Central warehouse coordinates: {center_coords[0]}, {center_coords[1]}")
print(type(center_coords))
print(len(center_coords))
