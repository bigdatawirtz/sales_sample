-- Tarefa 1: importe total e número de vendas con SQL (MySQL 8)

DROP TABLE IF EXISTS vendas;

CREATE TABLE vendas (
    id_venda        INT PRIMARY KEY,
    data            DATE,
    tenda           VARCHAR(50),
    produto         VARCHAR(50),
    unidades        INT,
    prezo_unitario  DECIMAL(10,2),   -- DECIMAL e non FLOAT: suma exacta en euros
    importe         DECIMAL(12,2)
) CHARACTER SET utf8mb4;

-- Carga do CSV.
-- Problema: os decimais veñen con coma (549,90) e MySQL espera punto (549.90).
-- Solución: ler eses campos en variables (@prezo, @importe) e cambiar a coma por punto.
LOAD DATA INFILE '/var/lib/mysql-files/tarefa/vendas_2025.csv'
INTO TABLE vendas
CHARACTER SET utf8mb4
FIELDS TERMINATED BY ';'
LINES TERMINATED BY '\n'
IGNORE 1 LINES                                   -- saltar a cabeceira
(id_venda, data, tenda, produto, unidades, @prezo, @importe)
SET prezo_unitario = REPLACE(@prezo,   ',', '.'),
    importe        = REPLACE(@importe, ',', '.');

-- Comprobación: debería haber 0 avisos
SHOW WARNINGS LIMIT 5;

-- Resultado
SELECT COUNT(*)      AS num_vendas,
       SUM(importe)  AS importe_total
FROM vendas;
