-- Tarefa 3: importe total e número de vendas de 2025 a partir de tres ficheiros cuadrimestrais (MySQL 8)
--
-- Táboa de carga SEN clave primaria: se id_venda fose PRIMARY KEY, a carga do
-- segundo ficheiro fallaría con "ERROR 1062 Duplicate entry". Cargamos todo,
-- gardamos de que ficheiro vén cada fila e analizamos os duplicados despois.

DROP TABLE IF EXISTS vendas_t3_carga;

CREATE TABLE vendas_t3_carga (
    id_venda        INT,
    data            DATE,
    tenda           VARCHAR(50),
    produto         VARCHAR(50),
    unidades        INT,
    prezo_unitario  DECIMAL(10,2),
    importe         DECIMAL(12,2),
    orixe           VARCHAR(20),
    INDEX (id_venda)
) CHARACTER SET utf8mb4;

-- 1. Cargar os tres ficheiros (mesmo formato que nas tarefas 1 e 2)
LOAD DATA INFILE '/var/lib/mysql-files/tarefa/vendas_2025_cuadrimestre1.csv'
INTO TABLE vendas_t3_carga CHARACTER SET utf8mb4
FIELDS TERMINATED BY ';' LINES TERMINATED BY '\n' IGNORE 1 LINES
(id_venda, data, tenda, produto, unidades, @prezo, @importe)
SET prezo_unitario = REPLACE(@prezo, ',', '.'),
    importe        = REPLACE(@importe, ',', '.'),
    orixe          = 'cuadrimestre1';
SHOW WARNINGS LIMIT 5;

LOAD DATA INFILE '/var/lib/mysql-files/tarefa/vendas_2025_cuadrimestre2.csv'
INTO TABLE vendas_t3_carga CHARACTER SET utf8mb4
FIELDS TERMINATED BY ';' LINES TERMINATED BY '\n' IGNORE 1 LINES
(id_venda, data, tenda, produto, unidades, @prezo, @importe)
SET prezo_unitario = REPLACE(@prezo, ',', '.'),
    importe        = REPLACE(@importe, ',', '.'),
    orixe          = 'cuadrimestre2';
SHOW WARNINGS LIMIT 5;

LOAD DATA INFILE '/var/lib/mysql-files/tarefa/vendas_2025_cuadrimestre3.csv'
INTO TABLE vendas_t3_carga CHARACTER SET utf8mb4
FIELDS TERMINATED BY ';' LINES TERMINATED BY '\n' IGNORE 1 LINES
(id_venda, data, tenda, produto, unidades, @prezo, @importe)
SET prezo_unitario = REPLACE(@prezo, ',', '.'),
    importe        = REPLACE(@importe, ',', '.'),
    orixe          = 'cuadrimestre3';
SHOW WARNINGS LIMIT 5;

-- 2. Que hai en cada ficheiro? (aquí xa se ve o solapamento de datas)
SELECT orixe, COUNT(*) AS filas, MIN(data) AS desde, MAX(data) AS ata, SUM(importe) AS importe
FROM vendas_t3_carga
GROUP BY orixe
ORDER BY orixe;

-- Suma directa dos tres ficheiros (INCORRECTA se hai duplicados)
SELECT COUNT(*) AS filas, COUNT(DISTINCT id_venda) AS id_distintos, SUM(importe) AS suma_directa
FROM vendas_t3_carga;

-- 3. Identificadores repetidos: en que ficheiros e en que datas
SELECT c.orixe, COUNT(*) AS filas_repetidas, MIN(c.data) AS desde, MAX(c.data) AS ata
FROM vendas_t3_carga c
JOIN (SELECT id_venda FROM vendas_t3_carga GROUP BY id_venda HAVING COUNT(*) > 1) r
  ON r.id_venda = c.id_venda
GROUP BY c.orixe;

-- 4. Son copias exactas? Contamos os id repetidos que teñen datos DIFERENTES.
--    Debe dar 0; se non, haberá que revisalos á man antes de borrar nada.
SELECT COUNT(*) AS id_repetidos_con_datos_distintos
FROM (
    SELECT id_venda
    FROM vendas_t3_carga
    GROUP BY id_venda
    HAVING COUNT(*) > 1
       AND COUNT(DISTINCT data, tenda, produto, unidades, prezo_unitario, importe) > 1
) x;

-- 5. Táboa final: unha fila por venda (DISTINCT sobre todas as columnas menos orixe)
DROP TABLE IF EXISTS vendas_t3;

CREATE TABLE vendas_t3 (
    id_venda        INT PRIMARY KEY,
    data            DATE,
    tenda           VARCHAR(50),
    produto         VARCHAR(50),
    unidades        INT,
    prezo_unitario  DECIMAL(10,2),
    importe         DECIMAL(12,2)
) CHARACTER SET utf8mb4;

INSERT INTO vendas_t3
SELECT DISTINCT id_venda, data, tenda, produto, unidades, prezo_unitario, importe
FROM vendas_t3_carga;

-- 6. Resultado
SELECT COUNT(*) AS num_vendas, SUM(importe) AS importe_total FROM vendas_t3;
