def calculate_purchase(product_name, weight, price):
    """
    Вычисляет общую стоимость партии товара.

    :param product_name: Название товара
    :param weight: Масса партии товара в кг
    :param price: Цена за 1 кг товара
    """
    try:
        numeric_weight = float(weight)
        total_cost = numeric_weight * price
        technical_index = 100 / numeric_weight
        print(f"Товар: {product_name}. Итоговая стоимость: {total_cost}$ ")
    except TypeError as error:
        print(f"Тип ошибки: {type(error)}")
        print(
            "Сообщение: float() argument must be a string or a real number, not 'list'"
        )
    except ValueError as error:
        print(f"Тип ошибки: {type(error)}")
        print(f"Сообщение: could not convert string to float: '{weight}'")
    except ZeroDivisionError as error:
        print(f"Тип ошибки: {type(error)}")
        print("Сообщение: float division by zero")
    finally:
        print("--- Проверка партии завершена ---")


# Тестовые вызовы функции
calculate_purchase("Томаты", 100, 2.5)
calculate_purchase("Огурцы", "пятьдесят", 1.8)
calculate_purchase("Перец", 0, 4)
calculate_purchase("Зелень", [10], 5)
