USE northwind;

-- EJERCICIO 1 Pedidos por empresa en UK:conocer cuántos pedidos ha realizado cada empresa cliente de UK. Nos piden el ID del cliente y el nombre de la empresa y el número de pedidos.

SELECT c.customer_id, c.company_name, COUNT(o.order_id)
	FROM customers AS c
    INNER JOIN orders AS o
    ON c.customer_id = o.customer_id
    WHERE c.country = "UK"
    GROUP BY c.customer_id, c.company_name;
    
-- EJERCICIO 2 query que nos sirva para conocer cuántos objetos ha pedido cada empresa cliente de UK durante cada año
-- Nos piden concretamente conocer el nombre de la empresa, el año, y la cantidad de objetos que han pedido. Para ello 
-- hará falta hacer 2 joins.    

   SELECT c.company_name, YEAR(o.shipped_date) AS año, SUM(od.quantity) AS 'total objetos'
	FROM order_details AS od
    INNER JOIN orders AS o
    ON od.order_id = o.order_id
    INNER JOIN customers AS c 
    ON o.customer_id = c.customer_id
    WHERE c.country lIKE 'UK'
    GROUP BY c.company_name, año
    ORDER BY c.company_name;

/* Mejorad la query anterior:
Lo siguiente que nos han pedido es la misma consulta anterior pero con la adición de la cantidad 
de dinero que han pedido por esa cantidad de objetos, teniendo en cuenta los descuentos, etc. Ojo que 
los descuentos en nuestra tabla nos salen en porcentajes, 15% nos sale como 0.15. */
SELECT *
FROM order_details;

SELECT c.company_name, YEAR(o.shipped_date) AS año, SUM(od.quantity), SUM(od.quantity * od.unit_price * (1 - od.discount)) AS total_price
	FROM order_details AS od
    INNER JOIN orders AS o
    ON od.order_id = o.order_id
    INNER JOIN customers AS c 
    ON o.customer_id = c.customer_id
    WHERE c.country lIKE 'UK'
    GROUP BY c.company_name, año
    ORDER BY c.company_name;

/* BONUS: Pedidos que han realizado cada compañía y su fecha:
Después de estas solicitudes desde UK y gracias a la utilidad de los resultados que se han obtenido, 
desde la central nos han pedido una consulta que indique el nombre de cada compañia cliente junto con 
cada pedido que han realizado y su fecha. */

USE northwind;

SELECT *
	FROM customers;

SELECT o.order_id, c.company_name, o.order_date
	FROM customers AS c
    INNER JOIN orders AS o
    ON c.customer_id = o.customer_id
    WHERE c.country LIKE "UK";

/* BONUS: Tipos de producto vendidos:
Ahora nos piden una lista con cada tipo de producto que se han vendido, sus categorías, 
nombre de la categoría y el nombre del producto, y el total de dinero por el que se ha vendido 
cada tipo de producto (teniendo en cuenta los descuentos).
Pista Necesitaréis usar 3 joins. */

USE northwind;

SELECT *
	FROM products;

SELECT c.category_id, p.product_name, category_name, SUM(od.unit_price * od.quantity * (1 - od.discount)) AS total_price
	FROM products AS p
    INNER JOIN categories AS c
    ON p.category_id = c.category_id
    INNER JOIN order_details AS od
    ON p.product_id = od.product_id
    GROUP BY category_id, product_name, category_name;

/* Qué empresas tenemos en la BBDD Northwind:
Lo primero que queremos hacer es obtener una consulta SQL que nos devuelva el nombre de todas las empresas cliente,
los ID de sus pedidos y las fechas. */ 

SELECT company_name, order_id, order_date
	FROM orders as o
    INNER JOIN customers as c
    ON o.customer_id = c.customer_id;

/* Pedidos por cliente de UK:
Desde la oficina de Reino Unido (UK) nos solicitan información acerca del número de pedidos que ha realizado 
cada cliente del propio Reino Unido de cara a conocerlos mejor y poder adaptarse al mercado actual. 
Especificamente nos piden el nombre de cada compañía cliente junto con el número de pedidos. */

SELECT company_name, COUNT(o.order_id) AS numero_pedidos
	FROM orders as o
    INNER JOIN customers as c
    ON o.customer_id = c.customer_id
    WHERE c.country LIKE "UK"
    GROUP BY company_name;

/* También nos han pedido que obtengamos todos los nombres de las empresas cliente de Reino Unido 
(tengan pedidos o no) junto con los ID de todos los pedidos que han realizado y la fecha del pedido. */

SELECT o.order_id, c.company_name, o.order_date
	FROM customers as c
    INNER JOIN orders as o
    ON o.customer_id = c.customer_id
    WHERE c.country LIKE "UK";

/* Ejercicio de SELF JOIN: Desde recursos humanos nos piden realizar una consulta que muestre 
por pantalla los datos de todas las empleadas y sus supervisoras. Concretamente nos piden: 
la ubicación, nombre, y apellido tanto de las empleadas como de las jefas. Investiga el resultado, 
¿sabes decir quién es el director? */

SELECT *
	FROM employees;
    
SELECT employee_id, first_name, last_name
	FROM employees;

SELECT A.city AS city, A.first_name AS first_name, A.last_name AS last_name2, 
		B.first_name AS manager_first_name, B.last_name AS manager_last_name
	FROM employees as A, employees AS B
    WHERE A.employee_id <> B.employee_id
    AND A.reports_to = B.employee_id;

/* Pedidos y empresas con pedidos asociados o no:
Selecciona todos los pedidos, tengan empresa asociada o no, y todas las empresas tengan 
pedidos asociados o no. Muestra el ID del pedido, el nombre de la empresa y la fecha del 
pedido (si existe). */

SELECT *
	FROM customers;

SELECT orders.order_id, orders.order_date, customers.company_name
	FROM orders  
	LEFT JOIN customers  
	ON orders.customer_id = customers.customer_id  
		UNION  
SELECT orders.order_id, orders.order_date, customers.company_name
	FROM orders  
	RIGHT JOIN customers  
	ON orders.customer_id = customers.customer_id;