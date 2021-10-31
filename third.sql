--  Схема БД состоит из четырех таблиц:
--  Product(maker, model, type)
--  PC(code, model, speed, ram, hd, cd, price)
--  Laptop(code, model, speed, ram, hd, price, screen)
--  Printer(code, model, color, type, price)
--  Таблица Product представляет производителя (maker), номер модели (model) и тип ('PC' - ПК, 'Laptop' - ПК-блокнот или 'Printer' - принтер). Предполагается, что номера моделей в таблице Product уникальны для всех производителей и типов продуктов. В таблице PC для каждого ПК, однозначно определяемого уникальным кодом – code, указаны модель – model (внешний ключ к таблице Product), скорость - speed (процессора в мегагерцах), объем памяти - ram (в мегабайтах), размер диска - hd (в гигабайтах), скорость считывающего устройства - cd (например, '4x') и цена - price. Таблица Laptop аналогична таблице РС за исключением того, что вместо скорости CD содержит размер экрана -screen (в дюймах). В таблице Printer для каждой модели принтера указывается, является ли он цветным - color ('y', если цветной), тип принтера - type (лазерный – 'Laser', струйный – 'Jet' или матричный – 'Matrix') и цена - price.


--  Для таблицы Product получить результирующий набор в виде таблицы со столбцами maker, pc, laptop и printer, в которой для каждого производителя требуется указать, производит он (yes) или нет (no) соответствующий тип продукции.
--  В первом случае (yes) указать в скобках без пробела количество имеющихся в наличии (т.е. находящихся в таблицах PC, Laptop и Printer) различных по номерам моделей соответствующего типа.

code	model	speed	ram	hd	cd	price
1	1232	500	64	5.0	12x	600.0000
2	1121	750	128	14.0	40x	850.0000
3	1233	500	64	5.0	12x	600.0000
4	1121	600	128	14.0	40x	850.0000
5	1121	600	128	8.0	40x	850.0000
6	1233	750	128	20.0	50x	950.0000
7	1232	500	32	10.0	12x	400.0000
8	1232	450	64	8.0	24x	350.0000
9	1232	450	32	10.0	24x	350.0000
10	1260	500	32	10.0	12x	350.0000
11	1233	900	128	40.0	40x	980.0000
12	1233	800	128	20.0	50x	970.0000

maker	model	type
B	1121	PC
A	1232	PC
A	1233	PC
E	1260	PC
A	1276	Printer
D	1288	Printer
A	1298	Laptop
C	1321	Laptop
A	1401	Printer
A	1408	Printer
D	1433	Printer
E	1434	Printer
B	1750	Laptop
A	1752	Laptop
E	2112	PC
E	2113	PC

-----------RESULT--------------
maker models
A   2
B   1
E   1
-------------------------------

WITH pcCTE AS (
    SELECT Product.maker AS maker, COUNT(DISTINCT PC.model) AS amount
    FROM Product LEFT JOIN PC ON PC.model = Product.model 
    WHERE Product.type = 'PC'  
    GROUP BY maker
), LaptopCTE AS (
    SELECT Product.maker AS maker, COUNT(DISTINCT Laptop.model) AS amount
    FROM Product LEFT JOIN Laptop ON Laptop.model = Product.model 
    WHERE Product.type = 'Laptop'
    GROUP BY maker
), PrinterCTE AS (
    SELECT Product.maker AS maker, COUNT(DISTINCT Printer.model) AS amount
    FROM Product LEFT JOIN Printer ON Printer.model = Product.model 
    WHERE Product.type = 'Printer'
    GROUP BY maker
)
SELECT DISTINCT(Product.maker) AS maker, 
(
    CASE
        WHEN pcCTE.amount IS NULL
        THEN 'no'
        ELSE 'yes(' + CONVERT(VARCHAR, pcCTE.amount) + ')'
    END
) AS pc,
(
    CASE
        WHEN LaptopCTE.amount IS NULL
        THEN 'no'
        ELSE 'yes(' + CONVERT(VARCHAR, LaptopCTE.amount) + ')'
    END
) AS laptop,
(
    CASE
        WHEN PrinterCTE.amount IS NULL
        THEN 'no'
        ELSE 'yes(' + CONVERT(VARCHAR, PrinterCTE.amount) + ')'
    END
) AS printer
FROM Product LEFT JOIN pcCTE ON pcCTE.maker = Product.maker
    LEFT JOIN PrinterCTE ON PrinterCTE.maker = Product.maker
        LEFT JOIN LaptopCTE ON LaptopCTE.maker = Product.maker
ORDER BY Product.maker

