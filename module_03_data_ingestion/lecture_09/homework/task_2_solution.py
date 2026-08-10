def calculate_total_delivery_cost(
    product_name: str,
    weights: list[float] | tuple[float, ...],
    prices: list[float] | tuple[float, ...],
    currency_rate: float = 1,
    *extra_costs: float,
    discount: float = 0.0,
) -> dict[str, float]:
    """
    Считает полную стоимость партии товаров включая издержки транспортировки.

    :param product_name: Название партии товаров
    :param weights: Список/кортеж с массами различных продуктов в партии товаров
    :param prices: Список/кортеж с ценами различных продуктов в партии товаров
    :param currency_rate: Курс валюты
    :param *extra_costs: Издержки транспортировки
    :param discount: Общая скидка на партию товаров (опциональна)
    """
    total_sum: int
    discount_sum: float
    extra_sum: float
    final_sum: float
    result: dict[str, float]

    if len(weights) == len(prices):
        total_sum = sum([weight * price for weight, price in zip(weights, prices)])
        # Далее формула учитывает возможность передачи None с ключом "discount" в функцию в качестве скидки:
        discount_sum = total_sum * (1 - (discount or 0))
        extra_sum = sum(extra_costs)
        final_sum = (discount_sum + extra_sum) * currency_rate
        result = {"name": product_name, "cost": final_sum}
    return result


# Словарь-буфер для вывода результата работы функции в читаемом виде:
output_buffer = dict[str, float]

output_buffer = calculate_total_delivery_cost(
    "Овощная партия", [100, 50], [4, 6], 1, 20, 15, discount=0.1
)
print(f"Товар: {output_buffer['name']}, итоговая стоимость: {output_buffer['cost']}")

output_buffer = calculate_total_delivery_cost(
    "Фруктовая партия",
    (30, 20, 10),
    (15, 12, 18),
    1.2,
    25,
)
print(f"Товар: {output_buffer['name']}, итоговая стоимость: {output_buffer['cost']}")
