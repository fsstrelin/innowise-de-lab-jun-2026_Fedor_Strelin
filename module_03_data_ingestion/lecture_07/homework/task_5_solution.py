import json

api_response_json = """ 
{ 
	"store": "StoreHub", 
	"orders": [ 
		{"id": 1, "total": 50}, 
		{"id": 2, "total": 200}, 
		{"id": 3, "total": 150} 
		]
 } 
"""

# Преобразование JSON-строки в словарь Python (далее в комментариях "полный словарь API-ответа")
api_response = json.loads(api_response_json)

# Получение списка словарей заказов (orders) из полного словаря API-ответа
orders = api_response["orders"]

# Фильтрация списка словарей заказов при помощи list comprehension в новый список наибольших заказов
high_value_orders = [
    total_value for total_value in orders if total_value.get("total") > 100
]

# Добавления списка словарей больших заказов в полный словарь API-ответа под ключ с идентичным названием
api_response["high_value_orders"] = high_value_orders

# Преобразование полученного полного словаря обратно в JSON-строку
api_response_json = json.dumps(api_response, ensure_ascii=False)

# Вывод итоговой JSON-строки
print(api_response_json)
