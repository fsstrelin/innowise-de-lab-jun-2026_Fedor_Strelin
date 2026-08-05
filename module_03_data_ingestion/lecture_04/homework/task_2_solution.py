# Список списков
daily_logs = [
    [500, 0, 1200],  # Касса 1 (Нормальная)
    [300, -999, 800],  # Касса 2 (Сломалась посередине, 800 не должно посчитаться)
    [1500, 200],  # Касса 3 (Нормальная)
]
total_revenue = 0  # Общая выручка магазина

for cashbox_number, cashbox_logs in enumerate(daily_logs, start=1):
    print(f"--- Обработка Кассы №{cashbox_number} ---")
    for cash_amount in cashbox_logs:
        if cash_amount == -999:
            print("Аварийная остановка кассы!")
            break
        if cash_amount == 0:
            print("Пропуск сбоя")
            continue
        if cash_amount > 0:
            total_revenue += cash_amount
            print(f"Добавлено:{cash_amount}")
print("=== ИТОГ ДНЯ ===")
print(f"Общая выручка магазина:{total_revenue}")
