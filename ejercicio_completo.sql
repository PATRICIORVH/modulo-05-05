-- ============================================
-- EJERCICIO PRÁCTICO: SQL LLAVES, DDL/DML Y CONSULTAS DE AGREGACIÓN
-- Módulo 5: Fundamentos de Bases de Datos Relacionales
-- Lección 3: Lenguaje de Manipulación de Datos DML
-- ============================================
-- Fecha: 2026-01-29
-- Descripción: Creación de tablas con relaciones, operaciones DML y consultas de agregación
-- ============================================

-- ===== SECCIÓN 1: CREAR TABLAS CON RESTRICCIONES =====

CREATE TABLE Clientes (
    idcliente INT PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    edad INT CHECK (edad BETWEEN 18 AND 85) NOT NULL
);

CREATE TABLE Cuentas (
    idcuenta INT PRIMARY KEY,
    idcliente INT NOT NULL,
    saldo NUMERIC(10, 2) CHECK (saldo BETWEEN -5000.00 AND 100000.00) NOT NULL,
    CONSTRAINT fkcliente FOREIGN KEY (idcliente) 
        REFERENCES Clientes(idcliente) 
        ON DELETE CASCADE
        ON UPDATE CASCADE
);

-- ===== SECCIÓN 2: INSERTAR 5 CLIENTES =====

INSERT INTO Clientes (idcliente, nombre, edad) VALUES (1, 'Ana García', 78);
INSERT INTO Clientes (idcliente, nombre, edad) VALUES (2, 'Luis Pérez', 25);
INSERT INTO Clientes (idcliente, nombre, edad) VALUES (3, 'María Soto', 40);
INSERT INTO Clientes (idcliente, nombre, edad) VALUES (4, 'Carlos Ruiz', 80);
INSERT INTO Clientes (idcliente, nombre, edad) VALUES (5, 'Elena Torres', 32);

-- ===== SECCIÓN 3: INSERTAR 15 CUENTAS =====

INSERT INTO Cuentas (idcuenta, idcliente, saldo) VALUES (101, 1, 50000.00);
INSERT INTO Cuentas (idcuenta, idcliente, saldo) VALUES (102, 1, -1200.50);
INSERT INTO Cuentas (idcuenta, idcliente, saldo) VALUES (103, 1, 100.00);
INSERT INTO Cuentas (idcuenta, idcliente, saldo) VALUES (201, 2, 850.75);
INSERT INTO Cuentas (idcuenta, idcliente, saldo) VALUES (202, 2, -500.00);
INSERT INTO Cuentas (idcuenta, idcliente, saldo) VALUES (301, 3, 15000.00);
INSERT INTO Cuentas (idcuenta, idcliente, saldo) VALUES (302, 3, 200.00);
INSERT INTO Cuentas (idcuenta, idcliente, saldo) VALUES (303, 3, -4999.99);
INSERT INTO Cuentas (idcuenta, idcliente, saldo) VALUES (304, 3, 75000.00);
INSERT INTO Cuentas (idcuenta, idcliente, saldo) VALUES (401, 4, 1000.00);
INSERT INTO Cuentas (idcuenta, idcliente, saldo) VALUES (402, 4, 2000.00);
INSERT INTO Cuentas (idcuenta, idcliente, saldo) VALUES (403, 4, 3000.00);
INSERT INTO Cuentas (idcuenta, idcliente, saldo) VALUES (501, 5, 50.00);
INSERT INTO Cuentas (idcuenta, idcliente, saldo) VALUES (502, 5, 120.00);
INSERT INTO Cuentas (idcuenta, idcliente, saldo) VALUES (503, 5, 900.00);

-- ===== SECCIÓN 4: OPERACIONES DML (UPDATE + DELETE) =====

UPDATE Cuentas SET saldo = saldo + 500.00 WHERE idcuenta = 402;
DELETE FROM Cuentas WHERE idcuenta = 503;

-- ===== SECCIÓN 5: CONSULTA 3 (Cliente más viejo y sus cuentas) =====

SELECT 
    c.idcliente,
    c.nombre,
    c.edad,
    cu.idcuenta,
    cu.saldo
FROM Clientes c
INNER JOIN Cuentas cu ON c.idcliente = cu.idcliente
WHERE c.edad = (SELECT MAX(edad) FROM Clientes)
ORDER BY cu.idcuenta;

-- ===== SECCIÓN 6: CONSULTA 4 (Promedio edad con saldo negativo) =====

SELECT 
    AVG(c.edad) AS promedio_edad,
    ROUND(AVG(c.edad), 2) AS promedio_redondeado,
    COUNT(DISTINCT c.idcliente) AS cantidad_clientes
FROM Clientes c
INNER JOIN Cuentas cu ON c.idcliente = cu.idcliente
WHERE cu.saldo < 0;

-- ===== SECCIÓN 7: CONSULTA 5 (Clientes con múltiples cuentas) =====

SELECT 
    c.idcliente,
    c.nombre,
    c.edad,
    COUNT(cu.idcuenta) AS cantidad_cuentas
FROM Clientes c
INNER JOIN Cuentas cu ON c.idcliente = cu.idcliente
GROUP BY c.idcliente, c.nombre, c.edad
HAVING COUNT(cu.idcuenta) > 1
ORDER BY cantidad_cuentas DESC;

-- ===== SECCIÓN 8: CONSULTA 6 (Saldo combinado por cliente) =====

SELECT 
    c.idcliente,
    c.nombre,
    c.edad,
    COUNT(cu.idcuenta) AS cantidad_cuentas,
    SUM(cu.saldo) AS saldo_combinado,
    MIN(cu.saldo) AS saldo_minimo,
    MAX(cu.saldo) AS saldo_maximo
FROM Clientes c
INNER JOIN Cuentas cu ON c.idcliente = cu.idcliente
GROUP BY c.idcliente, c.nombre, c.edad
HAVING COUNT(cu.idcuenta) > 1
ORDER BY saldo_combinado DESC;

-- ===== SECCIÓN 8: CONSULTA 7 (Clientes con AL MENOS una cuenta negativa) =====

SELECT 
    c.idcliente,
    c.nombre,
    c.edad,
    COUNT(cu.idcuenta) AS cantidad_cuentas,
    SUM(cu.saldo) AS saldo_combinado,
    MIN(cu.saldo) AS saldo_minimo,
    MAX(cu.saldo) AS saldo_maximo
FROM Clientes c
INNER JOIN Cuentas cu ON c.idcliente = cu.idcliente
WHERE c.idcliente IN (
    SELECT DISTINCT cu2.idcliente 
    FROM Cuentas cu2 
    WHERE cu2.saldo < 0
)
GROUP BY c.idcliente, c.nombre, c.edad
ORDER BY saldo_combinado DESC;
