# 🍕​ Campus Pizza
El propósito de este examen es diseñar una base de datos que permita gestionar eficientemente los productos, combos, pedidos y clientes de una pizzería. El sistema debe almacenar información sobre pizzas, panzarottis, otros productos no elaborados (bebidas, postres, etc.), adiciones y el menú disponible. y se debe registrar los pedidos de los clientes, que pueden ser para consumir en el lugar o para recoger.

## 📁 Estructura del Proyecto

```
Examen_PicoKevin_MySql/
├── CampusPizza.sql              - contiene el codigo(modelo fisico)                           
├── modelo logico         - imagen del modelo logico
├── README.md             
```


# 🔎​ CONSULTAS:

### Productos más vendidos
```
-- Productos más vendidos
SELECT p.nombre, SUM(pp.cantidad) AS total_vendidos
FROM Producto p
JOIN PedidoProducto pp ON p.idProducto = pp.idProducto
GROUP BY p.nombre
ORDER BY total_vendidos DESC;

```
### Total de ingresos por combo
```
-- Total de ingresos por combo
SELECT c.nombre, SUM(pe.total) AS ingreso_total
FROM Combo c
JOIN Pedidos pe ON c.idCombo = pe.idCombo
GROUP BY c.nombre;

```
### Pedidos para recoger vs consumir
```
-- Pedidos para recoger vs consumir
SELECT tipo, COUNT(*) AS total_pedidos
FROM Pedidos
GROUP BY tipo;

```
### Adiciones más solicitadas
```
-- Adiciones más solicitadas
SELECT ExtraQueso, Salsa, COUNT(*) AS cantidad
FROM Adicion a
JOIN Pedidos p ON a.idAdicion = p.idAdicion
GROUP BY ExtraQueso, Salsa
ORDER BY cantidad DESC;

```
### Cantidad total de productos vendidos por categoría
```
-- Cantidad total de productos vendidos por categoría
SELECT tipo, SUM(pp.cantidad) AS total_vendidos
FROM Producto p
JOIN PedidoProducto pp ON p.idProducto = pp.idProducto
GROUP BY tipo;

```
### Promedio de pizzas pedidas por cliente
```
-- Promedio de pizzas pedidas por cliente
SELECT c.nombre, AVG(pp.cantidad) AS promedio_pizzas
FROM Cliente c
JOIN Pedidos p ON c.idCliente = p.idCliente
JOIN PedidoProducto pp ON p.idPedidos = pp.idPedidos
JOIN Producto pr ON pp.idProducto = pr.idProducto
WHERE pr.tipo = 'pizza'
GROUP BY c.nombre;
```
### Total de ventas por día de la semana
```
-- Total de ventas por día de la semana
SELECT DAYNAME(fecha) AS dia, SUM(total) AS total_ventas
FROM Pedidos
GROUP BY dia;

```
### Panzarottis con extra queso
```
-- Panzarottis con extra queso
SELECT COUNT(*) AS total_panzarottis_extraqueso
FROM PedidoProducto pp
JOIN Producto p ON pp.idProducto = p.idProducto
JOIN Pedidos pe ON pp.idPedidos = pe.idPedidos
JOIN Adicion a ON pe.idAdicion = a.idAdicion
WHERE p.tipo = 'panzarotti' AND a.ExtraQueso = 'Sí';

```
### Pedidos que incluyen bebidas como parte de un combo
```
-- Pedidos que incluyen bebidas como parte de un combo
SELECT pe.idPedidos, c.nombre AS combo, p2.nombre AS bebida
FROM Pedidos pe
JOIN Combo c ON pe.idCombo = c.idCombo
JOIN ComboProducto cp ON c.idCombo = cp.idCombo
JOIN Producto p2 ON cp.idProducto = p2.idProducto
WHERE p2.tipo = 'bebida';
```
### Clientes con más de 5 pedidos el último mes
```
-- Clientes con más de 5 pedidos el último mes
SELECT c.nombre, COUNT(p.idPedidos) AS total_pedidos
FROM Cliente c
JOIN Pedidos p ON c.idCliente = p.idCliente
WHERE MONTH(p.fecha) = MONTH(CURDATE())
GROUP BY c.nombre
HAVING total_pedidos > 5;

```
### Ingresos totales por productos no elaborados
```
-- Ingresos totales por productos no elaborados
SELECT SUM(p.precio * pp.cantidad) AS total_no_elaborados
FROM Producto p
JOIN PedidoProducto pp ON p.idProducto = pp.idProducto
WHERE p.tipo IN ('bebida','postre','no elaborado');

```
### Promedio de adiciones por pedido
```
-- Promedio de adiciones por pedido
SELECT AVG(cnt) AS promedio_adiciones
FROM (
  SELECT idAdicion, COUNT(*) AS cnt
  FROM Pedidos
  WHERE idAdicion IS NOT NULL
  GROUP BY idAdicion
) AS sub;

```
### Total de combos vendidos en el último mes
```
-- Total de combos vendidos en el último mes
SELECT COUNT(idCombo) AS total_combos
FROM Pedidos
WHERE idCombo IS NOT NULL
AND MONTH(fecha) = MONTH(CURDATE());

```
### Clientes con pedidos tanto para recoger como consumir
```
-- Clientes con pedidos tanto para recoger como consumir
SELECT c.nombre
FROM Cliente c
JOIN Pedidos p ON c.idCliente = p.idCliente
GROUP BY c.nombre
HAVING SUM(p.tipo = 'recoger') > 0 AND SUM(p.tipo = 'consumir') > 0;

```
### total de producos personalizados con adiciones
```
-- total de producos personalizados con adiciones
SELECT COUNT(*) AS productos_personalizados
FROM Pedidos
WHERE idAdicion IS NOT NULL;


```
### Promedio de ingresos por día
```
-- Promedio de ingresos por día
SELECT AVG(total_diario) AS promedio_diario
FROM (
  SELECT fecha, SUM(total) AS total_diario
  FROM Pedidos
  GROUP BY fecha
) AS sub;

```
### Clientes con pizzas con adiciones en más del 50% de sus pedidos
```
-- Clientes con pizzas con adiciones en más del 50% de sus pedidos
SELECT c.nombre
FROM Cliente c
JOIN Pedidos p ON c.idCliente = p.idCliente
JOIN PedidoProducto pp ON p.idPedidos = pp.idPedidos
JOIN Producto pr ON pp.idProducto = pr.idProducto
WHERE pr.tipo = 'pizza' AND p.idAdicion IS NOT NULL
GROUP BY c.nombre
HAVING COUNT(*) / (SELECT COUNT(*) FROM Pedidos WHERE idCliente = c.idCliente) > 0.5;

```
### Porcentaje de ventas de productos no elaborados
```
-- Porcentaje de ventas de productos no elaborados
SELECT 
  (SUM(CASE WHEN p.tipo IN ('bebida','postre','no elaborado') THEN p.precio*pp.cantidad ELSE 0 END) /
   SUM(p.precio*pp.cantidad) * 100) AS porcentaje_no_elaborado
FROM Producto p
JOIN PedidoProducto pp ON p.idProducto = pp.idProducto;
```
### Día con más pedidos para recoger
```
-- Día con más pedidos para recoger
SELECT DAYNAME(fecha) AS dia, COUNT(*) AS total
FROM Pedidos
WHERE tipo = 'recoger'
GROUP BY dia
ORDER BY total DESC
LIMIT 1;

```


## 👨‍💻 Autor

**Kevin**  
Desarrollado como proyecto de práctica

- GitHub: https://github.com/kvinnxz/Examen_PicoKevin_MySql.git

## 🙏 Agradecimientos

⭐ Si te gustó este proyecto, no olvides darle una estrella en GitHub!

**Desarrollado con ❤️ por Kevin**