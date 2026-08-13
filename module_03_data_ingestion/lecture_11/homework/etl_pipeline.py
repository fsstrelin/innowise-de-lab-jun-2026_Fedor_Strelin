# (!) Используется виртуальное окружение .venv в innowise-de-lab-jun-2026_Fedor_Strelin

import os
import time

import pandas as pd
from sqlalchemy import BigInteger, Float, ForeignKey, Integer, String, create_engine
from sqlalchemy.orm import DeclarativeBase, Mapped, mapped_column

# Запись параметров локального подключения к базе данных postgresql
# в соответствующие переменные
user = "admin"
password = "admin123"
host = "localhost"
port = "5432"
database = "postgre"

# Запись URL подключения в переменную
# в формате: postgresql+driver://user:password@host:port/database
db_url = f"postgresql+psycopg2://{user}:{password}@{host}:{port}/{database}"

try:
    engine = create_engine(db_url, echo=False)
    print("Соединение успешно установлено.\n")
except Exception as e:
    print(f"Произошла непредвиденная ошибка: {e}")


# Родительский класс для классов описывающих таблицы:
class Base(DeclarativeBase):
    pass


# Описание будущих таблиц в виде классов.
# Типы данных указаны явно для всех данных. Используются лишь типы, не требующие очистки "сырого" датасета.
# nullable=True используется для безошибочной выгрузки всех данных в таблицы базы данных ETL-процессом.
# (Ключевые атрибуты точно не пусты из-за специфики происхождения датасета.)
class Country(Base):
    __tablename__ = "bronze_countries"
    __table_args__ = {"schema": "ecomarket"}
    country_id: Mapped[int] = mapped_column(Integer, primary_key=True)
    country_name: Mapped[str] = mapped_column(String(50), nullable=True)
    country_code: Mapped[str] = mapped_column(String(2), nullable=True)


class City(Base):
    __tablename__ = "bronze_cities"
    __table_args__ = {"schema": "ecomarket"}
    city_id: Mapped[int] = mapped_column(Integer, primary_key=True)
    city_name: Mapped[str] = mapped_column(String(50), nullable=True)
    zipcode: Mapped[int] = mapped_column(Integer, nullable=True)
    country_id: Mapped[int] = mapped_column(
        Integer, ForeignKey("ecomarket.bronze_countries.country_id")
    )


class Category(Base):
    __tablename__ = "bronze_categories"
    __table_args__ = {"schema": "ecomarket"}
    category_id: Mapped[int] = mapped_column(Integer, primary_key=True)
    category_name: Mapped[str] = mapped_column(String(50), nullable=True)


class Product(Base):
    __tablename__ = "bronze_products"
    __table_args__ = {"schema": "ecomarket"}
    product_id: Mapped[int] = mapped_column(Integer, primary_key=True)
    product_name: Mapped[str] = mapped_column(String(50), nullable=True)
    price: Mapped[float] = mapped_column(Float, nullable=True)
    category_id: Mapped[int] = mapped_column(
        Integer, ForeignKey("ecomarket.bronze_categories.category_id")
    )
    class_: Mapped[str] = mapped_column("class", String(1), nullable=True)
    modify_timestamp: Mapped[str] = mapped_column(String(50), nullable=True)
    resistant: Mapped[str] = mapped_column(String(3), nullable=True)
    is_allergic: Mapped[str] = mapped_column(String(3), nullable=True)
    vitality_days: Mapped[int] = mapped_column(Integer, nullable=True)


class Shop(Base):
    __tablename__ = "bronze_shops"
    __table_args__ = {"schema": "ecomarket"}
    shop_id: Mapped[int] = mapped_column(Integer, primary_key=True)
    city_id: Mapped[int] = mapped_column(
        Integer, ForeignKey("ecomarket.bronze_cities.city_id")
    )
    address: Mapped[str] = mapped_column(String(50), nullable=True)


class Employee(Base):
    __tablename__ = "bronze_employees"
    __table_args__ = {"schema": "ecomarket"}
    employee_id: Mapped[int] = mapped_column(Integer, primary_key=True)
    first_name: Mapped[str] = mapped_column(String(50), nullable=True)
    middle_initial: Mapped[str] = mapped_column(String(1), nullable=True)
    last_name: Mapped[str] = mapped_column(String(50), nullable=True)
    birth_date: Mapped[str] = mapped_column(String(10), nullable=True)
    gender: Mapped[str] = mapped_column(String(1), nullable=True)
    city_id: Mapped[int] = mapped_column(
        Integer, ForeignKey("ecomarket.bronze_cities.city_id")
    )
    shop_id: Mapped[int] = mapped_column(
        Integer, ForeignKey("ecomarket.bronze_shops.shop_id")
    )
    hire_date: Mapped[str] = mapped_column(String(10), nullable=True)


class Customer(Base):
    __tablename__ = "bronze_customers"
    __table_args__ = {"schema": "ecomarket"}
    customer_id: Mapped[int] = mapped_column(primary_key=True)
    first_name: Mapped[str] = mapped_column(String(50), nullable=True)
    middle_initial: Mapped[str] = mapped_column(String(1), nullable=True)
    last_name: Mapped[str] = mapped_column(String(50), nullable=True)
    city_id: Mapped[int] = mapped_column(ForeignKey("ecomarket.bronze_cities.city_id"))
    address: Mapped[str] = mapped_column(String(50), nullable=True)


class Sale(Base):
    __tablename__ = "bronze_sales"
    __table_args__ = {"schema": "ecomarket"}
    sales_id: Mapped[int] = mapped_column(BigInteger, primary_key=True)
    employee_id: Mapped[int] = mapped_column(
        Integer, ForeignKey("ecomarket.bronze_employees.employee_id")
    )
    customer_id: Mapped[int] = mapped_column(
        Integer, ForeignKey("ecomarket.bronze_customers.customer_id")
    )
    product_id: Mapped[int] = mapped_column(
        Integer, ForeignKey("ecomarket.bronze_products.product_id")
    )
    quantity: Mapped[int] = mapped_column(Integer, nullable=True)
    discount: Mapped[float] = mapped_column(Float, nullable=True)
    total_price: Mapped[float] = mapped_column(Float, nullable=True)
    sales_timestamp: Mapped[str] = mapped_column(
        String(19), nullable=True
    )  # (!) проверено, в датасете есть null-значения
    transaction_number: Mapped[str] = mapped_column(String(11), nullable=True)


# Команда движку физически создать вышеперечисленные таблицы в базе по образу классов:
Base.metadata.create_all(engine)

# Список путей к файлам датасета (в данном случае хранятся в папке скрипта etl_pipeline.py)
raw_data_filepaths = [
    "countries.csv",
    "cities.csv",
    "categories.csv",
    "products.csv",
    "shops.csv",
    "employees.csv",
    "customers.csv",
    "sales.csv",
]


def run_etl_process(csv_filepath: str, db_url: str):
    """
    Извлекает данные из CSV-файла, затем выгружает их в
    таблицу бронзового уровня с аналогичным именем

    :param csv_filepath: Путь к CSV-файлу датасета в файловой системе
    :param db_url: Адрес для подключения к базе данных
    """

    print("\n*** Запуск ETL-процесса... ***")
    # Извлечение данных из CSV-файла:
    try:
        df = pd.read_csv(
            csv_filepath,
            sep=";",
            header="infer",
            names=None,
            encoding=None,
        )
        print(f"Данные из {os.path.basename(csv_filepath)} успешно извлечены.\n")
        print(f"Размер CSV-файла: {len(df)} строк.")
        # Определение имени таблицы бронзового уровня для выгрузки данных
        name = "bronze_" + os.path.splitext(os.path.basename(csv_filepath))[0]
    except Exception as e:
        print(f"Произошла непредвиденная ошибка: {e}")
        print("ETL-процесс был прерван.")

    print("Установление соединения с базой данных...")
    # Установление соединения с базой данных:
    try:
        engine = create_engine(db_url, echo=False)
        print("Соединение успешно установлено.\n")
    except Exception as e:
        print(f"Произошла непредвиденная ошибка: {e}")
        print("ETL-процесс был прерван.")

    print("Выгрузка данных из датафрейма в таблицу базы...")
    # Выгрузка данных в таблицу базы данных
    try:
        df.to_sql(
            name,
            con=engine,
            schema="ecomarket",
            if_exists="append",
            index=False,
            chunksize=10000
            if len(df) > 10000
            else None,  # если в таблицы больше 10 тыс. строк - применяется пакетная выгрузка
        )
        print(f"Данные записаны в таблицу {name}.")
        print("--- ETL-процесс успешно завершен! ---")
    except Exception as e:
        print(f"Произошла непредвиденная ошибка: {e}")
        print("ETL-процесс был прерван.")


# Выполнение ETL-процесса для всех CSV-файлов датасета (включая sales.csv):
for filepath in raw_data_filepaths:
    try:
        start_time = time.perf_counter()
        run_etl_process(filepath, db_url)
        end_time = time.perf_counter()
        elapsed_time = end_time - start_time  # Подсчёт времени работы ETL-процесса
        print(f"Затрачено времени: {elapsed_time:.6f} сек.")
    except FileNotFoundError:
        print(f"Файл датасета не найден. Проверьте путь {filepath}")
    except Exception as e:
        print(f"Произошла непредвиденная ошибка: {e}")
        print("ETL-процесс был прерван.")
