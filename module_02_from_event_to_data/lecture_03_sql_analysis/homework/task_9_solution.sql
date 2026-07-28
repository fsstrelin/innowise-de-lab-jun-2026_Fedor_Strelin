/*
Задача 9.
Создать новую таблицу с именем Data_Layers необходимую для описания слоев, со столбцами:
LayerID (SERIAL, PRIMARY KEY), LayerName (VARCHAR(50), UNIQUE, NOT NULL), Description (TEXT).

Заполнить колонку LayerName тремя значениями 'Bronze', 'Silver', 'Gold', которые обозначают слои в медальонной архитектуре.

Добавить колонку manager_email в таблицу Data_Layers (VARCHAR(100)).

Добавить ограничение UNIQUE к столбцу manager_email в таблице Data_Layers
(предварительно заполнив столбец любыми значениями, чтобы избежать ошибки).

Переименовать столбец address в таблице Shops в shop_address.
*/

CREATE TABLE ecomarket.data_layers (
	layer_id SERIAL PRIMARY KEY,
	layer_name VARCHAR(50) UNIQUE NOT NULL,
	description TEXT
);

INSERT INTO ecomarket.data_layers (
	layer_name
)
VALUES
	('Bronze'),
	('Silver'),
	('Gold');

ALTER TABLE ecomarket.data_layers 
ADD COLUMN manager_email VARCHAR(100);

UPDATE ecomarket.data_layers
SET
	manager_email = lower(substring(md5(random()::text) from 1 for 8)) || '@example.com'; --генерация случайных почтовых адресов

ALTER TABLE ecomarket.data_layers 
ADD CONSTRAINT unique_manager_email UNIQUE(manager_email);

ALTER TABLE ecomarket.shops
RENAME COLUMN address TO shop_address;

SELECT
	*
FROM
	ecomarket.data_layers;