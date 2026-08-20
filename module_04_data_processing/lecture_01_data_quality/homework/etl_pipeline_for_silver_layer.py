# Используется .venv расположенное в
# /Users/theo/Big Data Lab/innowise_lab_jun_2026/innowise-de-lab-jun-2026_Fedor_Strelin
import pandas as pd
from sqlalchemy import create_engine

# Запись параметров локального подключения к базе данных postgresql
# в соответствующие переменные
user = "admin"
password = "admin123"
host = "localhost"
port = "5432"
database = "postgre"

# Формирование строки подключения вида:
# postgresql+driver://user:password@host:port/database
db_url = f"postgresql+psycopg2://{user}:{password}@{host}:{port}/{database}"


def migrate_data(db_url: str):
    """
    Проводит миграцию данных не требующих очистки
    из таблиц бронзового уровня в таблицы серебряного уровня.

    :param db_url: Адрес для подключения к базе данных
    """
    # Устанавливаем соединение с базой данных:
    try:
        engine = create_engine(db_url, echo=False)
        print("\nСоединение для миграции данных успешно установлено.")
    except Exception as e:
        print(f"Произошла непредвиденная ошибка: {e}")

    source_tables = [
        "bronze_countries",
        "bronze_cities",
        "bronze_categories",
        "bronze_products",
        "bronze_shops",
        "bronze_customers",
    ]
    target_tables = [
        "silver_countries",
        "silver_cities",
        "silver_categories",
        "silver_products",
        "silver_shops",
        "silver_customers",
    ]
    for source, target in zip(source_tables, target_tables):
        df = pd.read_sql_table(source, con=engine, schema="ecomarket")
        df.to_sql(target, con=engine, schema="silver", if_exists="append", index=False)
        print(f"Данные из {source} успешно перенесены в {target}.")
    print("Миграция данных завершена.\n")


def validate_and_fix_date(db_url: str):
    """
    1. Извлекает данные из таблицы сотрудников бронзового уровня,
    проводит их валидацию - невозможные значения заменяет на значение по умолчанию,
    загружает очищенные данные в таблицу сотрудников серебряного уровня.
    2. Извлекает данные из таблицы продаж бронзового уровня,
    заполняет пропуски в колонке sales_timestamp - при отсутствии времени
    в ячейке, вписывает значение по умолчанию (полночь), в случае
    отсутствия как времемени, так и даты (пустая ячейка) - удаляет всю строку целиком,
    далее загружает очищенные данные в таблицу продаж серебряного уровня.

    :param db_url: Адрес для подключения к базе данных
    """
    # Устанавливаем соединение с базой данных:
    try:
        engine = create_engine(db_url, echo=False)
        print("Соединение для очистки данных успешно установлено.")
    except Exception as e:
        print(f"Произошла непредвиденная ошибка: {e}")

    # Значение даты по умолчанию - используется для замены нереалистичных дат
    default_date = "1900-01-01"

    # Извлекаем данные из таблицы сотрудников бронзового уровня в датафрейм
    df = pd.read_sql_table("bronze_employees", con=engine, schema="ecomarket")
    print("Очистка bronze_employees...")
    # Очищаем даты рождения сотрудников:
    # 1. Удаляем пробелы в ячейках дат
    df["birth_date"] = df["birth_date"].astype(str).str.strip()
    # 2. Заменяем все "/" на "-"
    df["birth_date"] = df["birth_date"].str.replace("/", "-", regex=False)
    # 3. Конвертируем все реалистичные текстовые данные в даты, а нереалистичные заменяем на NaT
    df["birth_date"] = pd.to_datetime(df["birth_date"], errors="coerce", format="mixed")
    # 4. Заменяем все NaT-значения на дату по умолчанию (default_date)
    df["birth_date"] = df["birth_date"].fillna(pd.Timestamp(default_date))

    # Те же действия по отношению к датам найма сотрудников:
    df["hire_date"] = df["hire_date"].astype(str).str.strip()
    df["hire_date"] = df["hire_date"].str.replace("/", "-", regex=False)
    df["hire_date"] = pd.to_datetime(df["hire_date"], errors="coerce", format="mixed")
    df["hire_date"] = df["hire_date"].fillna(pd.Timestamp(default_date))

    # Запись очищенных данных из датафрейма в заранее подготовленную
    # при помощи ddl-скрипта таблицу сотрудников серебряного уровня
    df.to_sql(
        "silver_employees", con=engine, schema="silver", if_exists="append", index=False
    )
    print("Данные из bronze_employees очищены и успешно перенесены в silver_employees.")

    print("Извлечение данных из bronze_sales в датафрейм...")
    # Записываем данные из таблицы продаж бронзового уровня в датафрейм
    df = pd.read_sql_table("bronze_sales", con=engine, schema="ecomarket")
    print("Очистка bronze_sales...")
    initial_rows = len(df)  # сохранение размера датафрейма до очистки
    # Удаляем строки, где в колонке sales_timestamp отсутствует значение
    df = df.dropna(subset=["sales_timestamp"])
    deleted_rows = initial_rows - len(df)  # вычисление количества удаленных строк
    print(f"Удалено пустых строк из bronze_sales: {deleted_rows}шт.")

    # Удаляем пробелы в ячейках временных меток
    df["sales_timestamp"] = df["sales_timestamp"].astype(str).str.strip()

    # Формируем маску для поиска ячеек, где есть только дата (формат ГГГГ-ММ-ДД без времени)
    # (строка должна состоять ровно из даты, без пробелов и времени после нее)
    only_date_mask = df["sales_timestamp"].str.match(r"^\d{4}-\d{2}-\d{2}$")
    # Добавление полуночи только к этим ячейкам
    df.loc[only_date_mask, "sales_timestamp"] = (
        df.loc[only_date_mask, "sales_timestamp"] + " 00:00:00"
    )
    print(f"Количество исправленных ячеек в bronze_sales: {only_date_mask.sum()}шт.")
    print("Перенос очищенных данных bronze_sales из датафрейма в silver_sales...")

    # Запись очищенных данных из датафрейма в заранее подготовленную
    # при помощи ddl-скрипта таблицу продаж серебряного уровня
    try:
        df.to_sql(
            "silver_sales",
            con=engine,
            schema="silver",
            if_exists="append",
            index=False,
            chunksize=10000,
        )
        print("Данные из bronze_sales очищены и успешно перенесены в silver_sales.")
    except Exception as e:
        print(f"Произошла непредвиденная ошибка: {e}")
        print("Процесс очистки и исправления дат был прерван.")


# Запуск миграции данных
migrate_data(db_url)
# Запуск очистки и исправления дат
validate_and_fix_date(db_url)
