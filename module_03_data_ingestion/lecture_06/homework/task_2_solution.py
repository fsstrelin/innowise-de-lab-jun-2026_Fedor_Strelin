# Инициализация данных
prices = [100, -50, 300, 40, 800]

# Удаление отрицательной цены -50 из списка цен
prices.remove(-50)

# Добавление цены 150 в конец списка цен
prices.append(150)

# Сортировка списка цен по возрастанию
prices.sort()

# Создание нового списка цен, учитывающих НДС, и больших чем 100
tax_prices = [price * 1.2 for price in prices if (price * 1.2) > 100]

# Вывод итоговых значений
print(f"Базовый прайс (очищенный):{prices}")
print(f"Цены с НДС (>100):{tax_prices}")
print(f"Общая выручка:{sum(tax_prices)}")
print(f"Минимум:{min(tax_prices)}")
print(f"Максимум:{max(tax_prices)}")
