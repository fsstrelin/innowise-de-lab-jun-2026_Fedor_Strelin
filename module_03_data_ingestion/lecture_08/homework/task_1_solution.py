# Глобальная переменная - лимит "мелких" закупок магазина
SMALL_BATCH_LIMIT = 500


def calculate_batch(weight, price, discount=0.0):
    """
    Считает общую стоимость партии товара.
    Затем проверяет превышение глобального лимита мелких закупок.

    :param weight: Масса партии в кг (обязательный параметр)
    :param price: Стоимость 1 кг товара (обязательный параметр)
    :param discount: Скидка (опциональный параметр)
    """
    final_sum = weight * price * (1 - discount)
    is_limit_exceeded = final_sum > SMALL_BATCH_LIMIT
    return final_sum, is_limit_exceeded


# Ручной вызов созданной функции по следующим данным и вывод результатов для каждого вызова:
# Морковь 100 кг по 4$ за кг., без скидки.
# Яблоки 50 кг по 20$ за кг., скидка 10%.

final_sum_unpacked, is_limit_exceeded_unpacked = calculate_batch(100, 4)
print(
    f"Партия 1 (Морковь): Сумма {final_sum_unpacked}. Превышение лимита:{is_limit_exceeded_unpacked}"
)

final_sum_unpacked, is_limit_exceeded_unpacked = calculate_batch(50, 20, 0.1)
print(
    f"Партия 2 (Яблоки): Сумма {final_sum_unpacked}. Превышение лимита:{is_limit_exceeded_unpacked}"
)
