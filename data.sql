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
