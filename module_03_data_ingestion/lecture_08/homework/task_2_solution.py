# Инициализация данных (список филиалов и их выручка)
branches = [
    {"city": "Minsk", "revenue": 15000},
    {"city": "Warsaw", "revenue": 32000},
    {"city": "London", "revenue": 12000},
]


# Функция-декоратор для логирования запуска обернутой функции
def audit_logger(func):
    def wrapper(*args, **kwargs):
        print("[AUDIT] Запуск анализа...")
        result = func(*args, **kwargs)
        print("[AUDIT] Анализ завершен.")
        print("Топ филиалов:")
        return result

    return wrapper


# Основная функция сортировки списка словарей, обернутая декоратором, логирующим её запуск
@audit_logger
def get_sorted_report(branches_arg):
    return sorted(branches_arg, key=lambda item: item["revenue"], reverse=True)


# Вывод результата работы основной функции сортировки
for counter, item in enumerate(get_sorted_report(branches), start=1):
    print(f"{counter}. {item['city']}, {item['revenue']}")
