product_name = "Морковь мытая"
price = 2.5
stock_quantity = 150
is_local_farm = True
supplier = None

has_coupon = True
has_card = False
total = 10

# Проверка соответствия условию приобретения статуса "Хита"
is_hit = (price < 3) and (is_local_farm == True)
print("Является ли товар хитом?", is_hit)

# Проверка наличия значения у переменной supplier
has_supplier = supplier is not None
print("Поставщик указан?", has_supplier)

# Проверка необходимости отображения товара в приложении
can_show_in_app = has_supplier and (stock_quantity > 0)
print("Показывать в приложении?", can_show_in_app)

# Проверка необходимости пополнения остатка
needs_restock = is_hit or (stock_quantity <= 20)
print("Нужно пополнение?", needs_restock)

# Проверка возможности участия акции на основе местного происхождения товара
is_blocked = not (is_local_farm)
print("Товар заблокирован для акции?", is_blocked)

# Проверка приоритетов операторов и/или на примере условия наличия скидки
discount_without_brackets = has_coupon or has_card and total > 50
discount_with_brackets = (has_coupon or has_card) and total > 50
print("Скидка без скобок:", discount_without_brackets)
print("Скидка со скобками:", discount_with_brackets)

# Изменение значений переменных, связанных с товаром
price += 1.0
print("Цена после изменения:", price)
stock_quantity *= 2
print("Остаток после изменения:", stock_quantity)
boxes = stock_quantity
boxes //= 10
print("Полных коробок по 10 кг:", boxes)

# Повторные проверки на соответствие условию приобретения статуса "Хита"
# и необходимость пополнения остатков после внесения изменений
is_hit = (price < 3) and (is_local_farm == True)
print("Является ли товар хитом (после изменений)?", is_hit)
needs_restock = is_hit or (stock_quantity <= 20)
print("Нужно пополнение (после изменений)?", needs_restock)
