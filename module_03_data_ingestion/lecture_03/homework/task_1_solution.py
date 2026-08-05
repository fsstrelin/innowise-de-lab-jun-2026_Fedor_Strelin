raw_sku = "CARROT-001"
raw_regions = ("Minsk", "Warsaw", "Berlin", "Warsaw")
raw_weight_str = "2.5"
raw_stock_str = "150"

# Явное преобразование сырых строк в числовые значения
weight_kg = float(raw_weight_str)
stock_quantity = int(raw_stock_str)

# Явное преобразование коллекций с сырыми данными в списки и множества
sku_as_list = list(raw_sku)
regions_list = list(raw_regions)
unique_regions = set(raw_regions)
# Явное преобразование неупорядоченной коллекции уникальных регионов (множества
# регионов) в неизменяемый список регионов (кортеж регионов)
regions_tuple = tuple(unique_regions)

# Создание пустых коллекций различных типов всеми доступными способами
empty_list_1 = []
empty_list_2 = list()
empty_dict_1 = {}
empty_dict_2 = dict()
empty_tuple_1 = ()
empty_tuple_2 = tuple()
empty_set = set()

# Создание непустых коллекций различных типов
filled_list = [1, 2, 3]
filled_dict = {1: "one", 2: "two", 3: "three"}
filled_tuple = (1, 2, 3)
filled_set = {1, 2, 3}

# Вывод значений переменных, хранящих преобразованные данные
print(weight_kg, type(weight_kg))
print(stock_quantity, type(stock_quantity))
print(sku_as_list, type(sku_as_list))
print(regions_list, type(regions_list))
print(unique_regions, type(unique_regions))
print(regions_tuple, type(regions_tuple))

# Вывод bool() для пустых коллекций
print(bool(empty_list_1))
print(bool(empty_dict_1))
print(bool(empty_tuple_1))
print(bool(empty_set))

# Вывод bool() для непустых коллекций
print(bool(filled_list))
print(bool(filled_dict))
print(bool(filled_tuple))
print(bool(filled_set))
