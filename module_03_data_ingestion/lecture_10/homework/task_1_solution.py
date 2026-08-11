# Создание родительского класса Product (Базовый товар)
class Product:
    def __init__(self, name, price):
        self.name = name
        self.__price = price

    def get_price(self):
        return self.__price

    def set_price(self, new_price):
        if new_price > 0:
            self.__price = new_price
        else:
            print("Ошибка безопасности: Цена должна быть положительной!\n")

    def calculate_cost(self):
        return self.get_price()

    def get_display_info(self):
        print(f"Товар: {self.name} | Цена: {self.get_price()} руб.")


# Создание дочернего класса WeighableProduct (Весовой товар)
class WeighableProduct(Product):
    def __init__(self, name, price, weight):
        super().__init__(name, price)
        self.weight = weight

    def calculate_cost(self):
        return self.get_price() * self.weight

    def get_display_info(self):
        print(
            f"Весовой товар: {self.name} | Вес: {self.weight} кг | Итого: {self.calculate_cost()} руб."
        )


# Создание дочернего класса PackagedProduct (Товар в упаковке)
class PackagedProduct(Product):
    def __init__(self, name, price, quantity: int):
        super().__init__(name, price)
        self.quantity = quantity

    def calculate_cost(self):
        return self.get_price() * self.quantity

    def get_display_info(self):
        print(
            f"Упаковка: {self.name} | Количество: {self.quantity} шт. | Итого: {self.calculate_cost()} руб."
        )


# Создание пустой корзины для товаров и переменной с её стоимостью
cart = []
cart_cost = 0

# Создание экземпляров классов различных товаров и их последовательное добавление в корзину
milk = Product("Молоко", 100)
cart.append(milk)
apples = WeighableProduct("Яблоки", 50, 2.5)
cart.append(apples)
eggs = PackagedProduct("Яйца", 12, 10)
cart.append(eggs)

# Проверка изменения цены товара "Молоко" на отрицательное значение
milk.set_price(-200)

# Вывод содержимого корзины и его полной стоимости в виде чека
print("--- Чек EcoMarket ---")
for cart_item in cart:
    cart_item.get_display_info()
    cart_cost += cart_item.calculate_cost()
print("---------------------")
print(f"*** Итого к оплате: {cart_cost} руб. ***")
