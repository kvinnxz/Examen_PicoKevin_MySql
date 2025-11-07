DROP DATABASE IF EXISTS CampusPizza;
CREATE DATABASE IF NOT EXISTS CampusPizza;
USE CampusPizza;

CREATE TABLE Cliente (
    idCliente BIGINT PRIMARY KEY AUTO_INCREMENT,
    nombre VARCHAR(100),
    cantidad BIGINT
);

CREATE TABLE Menu (
    idMenu BIGINT PRIMARY KEY AUTO_INCREMENT,
    OpcionDisponible VARCHAR(100)
);

CREATE TABLE Adicion (
    idAdicion BIGINT PRIMARY KEY AUTO_INCREMENT,
    ExtraQueso VARCHAR(50),
    Salsa VARCHAR(50)
);

CREATE TABLE Producto (
    idProducto BIGINT PRIMARY KEY AUTO_INCREMENT,
    nombre VARCHAR(100),
    tipo ENUM('pizza','panzarotti','bebida','postre','no elaborado'),
    precio DECIMAL(10,2)
);

CREATE TABLE Combo (
    idCombo BIGINT PRIMARY KEY AUTO_INCREMENT,
    nombre VARCHAR(100),
    precio DECIMAL(10,2)
);

CREATE TABLE ComboProducto (
    idCombo BIGINT,
    idProducto BIGINT,
    PRIMARY KEY (idCombo, idProducto),
    FOREIGN KEY (idCombo) REFERENCES Combo(idCombo),
    FOREIGN KEY (idProducto) REFERENCES Producto(idProducto)
);

CREATE TABLE Pedidos (
    idPedidos BIGINT PRIMARY KEY AUTO_INCREMENT,
    idCliente BIGINT,
    idAdicion BIGINT,
    idCombo BIGINT,
    idMenu BIGINT,
    fecha DATE,
    tipo ENUM('recoger','consumir'),
    total DECIMAL(10,2),
    FOREIGN KEY (idCliente) REFERENCES Cliente(idCliente),
    FOREIGN KEY (idAdicion) REFERENCES Adicion(idAdicion),
    FOREIGN KEY (idCombo) REFERENCES Combo(idCombo),
    FOREIGN KEY (idMenu) REFERENCES Menu(idMenu)
);

CREATE TABLE PedidoProducto (
    idPedidos BIGINT,
    idProducto BIGINT,
    cantidad INT,
    PRIMARY KEY (idPedidos, idProducto),
    FOREIGN KEY (idPedidos) REFERENCES Pedidos(idPedidos),
    FOREIGN KEY (idProducto) REFERENCES Producto(idProducto)
);

-- Se añaden datos a las tablas creadas

INSERT INTO Cliente (nombre, cantidad) VALUES
('Laura Gómez', 2),
('Andrés Pérez', 3),
('Sofía Rojas', 5),
('Carlos Díaz', 1);

INSERT INTO Menu (OpcionDisponible) VALUES
('Pizza grande'),
('Panzarotti combo'),
('Bebidas frías'),
('Postres dulces');

INSERT INTO Adicion (ExtraQueso, Salsa) VALUES
('Sí', 'Tomate'),
('No', 'BBQ'),
('Sí', 'Rosada');

INSERT INTO Producto (nombre, tipo, precio) VALUES
('Pizza Margarita', 'pizza', 25000),
('Pizza Hawaiana', 'pizza', 27000),
('Panzarotti Jamón', 'panzarotti', 18000),
('Gaseosa 400ml', 'bebida', 5000),
('Postre de Chocolate', 'postre', 7000);

INSERT INTO Combo (nombre, precio) VALUES
('Combo Familiar', 45000),
('Combo Pareja', 30000);

INSERT INTO ComboProducto VALUES
(1,1), (1,4), (1,5),
(2,2), (2,3);

INSERT INTO Pedidos (idCliente, idAdicion, idCombo, idMenu, fecha, tipo, total) VALUES
(1, 1, 1, 1, '2025-11-01', 'consumir', 50000),
(2, 2, 2, 2, '2025-11-02', 'recoger', 32000),
(3, 3, NULL, 3, '2025-11-03', 'consumir', 27000),
(4, 1, NULL, 4, '2025-11-04', 'recoger', 29000);

INSERT INTO PedidoProducto VALUES
(1, 1, 2), (1, 4, 2),
(2, 2, 1), (2, 3, 1),
(3, 1, 1), (3, 5, 1),
(4, 2, 2), (4, 4, 1);

-- Productos más vendidos
SELECT p.nombre, SUM(pp.cantidad) AS total_vendidos
FROM Producto p
JOIN PedidoProducto pp ON p.idProducto = pp.idProducto
GROUP BY p.nombre
ORDER BY total_vendidos DESC;

-- Total de ingresos por combo
SELECT c.nombre, SUM(pe.total) AS ingreso_total
FROM Combo c
JOIN Pedidos pe ON c.idCombo = pe.idCombo
GROUP BY c.nombre;

-- Pedidos para recoger vs consumir
SELECT tipo, COUNT(*) AS total_pedidos
FROM Pedidos
GROUP BY tipo;

-- Adiciones más solicitadas
SELECT ExtraQueso, Salsa, COUNT(*) AS cantidad
FROM Adicion a
JOIN Pedidos p ON a.idAdicion = p.idAdicion
GROUP BY ExtraQueso, Salsa
ORDER BY cantidad DESC;

-- Cantidad total de productos vendidos por categoría
SELECT tipo, SUM(pp.cantidad) AS total_vendidos
FROM Producto p
JOIN PedidoProducto pp ON p.idProducto = pp.idProducto
GROUP BY tipo;

-- Promedio de pizzas pedidas por cliente
SELECT c.nombre, AVG(pp.cantidad) AS promedio_pizzas
FROM Cliente c
JOIN Pedidos p ON c.idCliente = p.idCliente
JOIN PedidoProducto pp ON p.idPedidos = pp.idPedidos
JOIN Producto pr ON pp.idProducto = pr.idProducto
WHERE pr.tipo = 'pizza'
GROUP BY c.nombre;

-- Total de ventas por día de la semana
SELECT DAYNAME(fecha) AS dia, SUM(total) AS total_ventas
FROM Pedidos
GROUP BY dia;

-- Panzarottis con extra queso
SELECT COUNT(*) AS total_panzarottis_extraqueso
FROM PedidoProducto pp
JOIN Producto p ON pp.idProducto = p.idProducto
JOIN Pedidos pe ON pp.idPedidos = pe.idPedidos
JOIN Adicion a ON pe.idAdicion = a.idAdicion
WHERE p.tipo = 'panzarotti' AND a.ExtraQueso = 'Sí';

-- Pedidos que incluyen bebidas como parte de un combo
SELECT pe.idPedidos, c.nombre AS combo, p2.nombre AS bebida
FROM Pedidos pe
JOIN Combo c ON pe.idCombo = c.idCombo
JOIN ComboProducto cp ON c.idCombo = cp.idCombo
JOIN Producto p2 ON cp.idProducto = p2.idProducto
WHERE p2.tipo = 'bebida';

-- Clientes con más de 5 pedidos el último mes
SELECT c.nombre, COUNT(p.idPedidos) AS total_pedidos
FROM Cliente c
JOIN Pedidos p ON c.idCliente = p.idCliente
WHERE MONTH(p.fecha) = MONTH(CURDATE())
GROUP BY c.nombre
HAVING total_pedidos > 5;

-- Ingresos totales por productos no elaborados
SELECT SUM(p.precio * pp.cantidad) AS total_no_elaborados
FROM Producto p
JOIN PedidoProducto pp ON p.idProducto = pp.idProducto
WHERE p.tipo IN ('bebida','postre','no elaborado');

-- Promedio de adiciones por pedido
SELECT AVG(cnt) AS promedio_adiciones
FROM (
  SELECT idAdicion, COUNT(*) AS cnt
  FROM Pedidos
  WHERE idAdicion IS NOT NULL
  GROUP BY idAdicion
) AS sub;

-- Total de combos vendidos en el último mes
SELECT COUNT(idCombo) AS total_combos
FROM Pedidos
WHERE idCombo IS NOT NULL
AND MONTH(fecha) = MONTH(CURDATE());

-- Clientes con pedidos tanto para recoger como consumir
SELECT c.nombre
FROM Cliente c
JOIN Pedidos p ON c.idCliente = p.idCliente
GROUP BY c.nombre
HAVING SUM(p.tipo = 'recoger') > 0 AND SUM(p.tipo = 'consumir') > 0;

-- total de producos personalizados con adiciones
SELECT COUNT(*) AS productos_personalizados
FROM Pedidos
WHERE idAdicion IS NOT NULL;

-- Pedidos con más de 3 productos diferentes
SELECT idPedidos
FROM PedidoProducto
GROUP BY idPedidos
HAVING COUNT(idProducto) > 3;

-- Promedio de ingresos por día
SELECT AVG(total_diario) AS promedio_diario
FROM (
  SELECT fecha, SUM(total) AS total_diario
  FROM Pedidos
  GROUP BY fecha
) AS sub;

-- Clientes con pizzas con adiciones en más del 50% de sus pedidos
SELECT c.nombre
FROM Cliente c
JOIN Pedidos p ON c.idCliente = p.idCliente
JOIN PedidoProducto pp ON p.idPedidos = pp.idPedidos
JOIN Producto pr ON pp.idProducto = pr.idProducto
WHERE pr.tipo = 'pizza' AND p.idAdicion IS NOT NULL
GROUP BY c.nombre
HAVING COUNT(*) / (SELECT COUNT(*) FROM Pedidos WHERE idCliente = c.idCliente) > 0.5;

-- Porcentaje de ventas de productos no elaborados
SELECT 
  (SUM(CASE WHEN p.tipo IN ('bebida','postre','no elaborado') THEN p.precio*pp.cantidad ELSE 0 END) /
   SUM(p.precio*pp.cantidad) * 100) AS porcentaje_no_elaborado
FROM Producto p
JOIN PedidoProducto pp ON p.idProducto = pp.idProducto;

-- Día con más pedidos para recoger
SELECT DAYNAME(fecha) AS dia, COUNT(*) AS total
FROM Pedidos
WHERE tipo = 'recoger'
GROUP BY dia
ORDER BY total DESC
LIMIT 1;