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
