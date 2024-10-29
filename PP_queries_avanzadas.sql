USE northwind;
-- Productos más baratos y caros de nuestra BBDD:
-- Desde la división de productos nos piden conocer el 
-- precio de los productos que tienen el precio más alto y más bajo. 
-- Dales el alias lowestPrice y highestPrice.
SELECT * 
	FROM products;
    
SELECT MIN(unit_price) AS lowestPrice, MAX(unit_price) AS highestPrice
	FROM products;
    
-- Adicionalmente nos piden que diseñemos otra consulta para conocer 
-- el número de productos y el precio medio de todos ellos (en general, 
-- no por cada producto).
SELECT COUNT(units_in_stock), AVG(unit_price)
	FROM products;

-- Nuestro siguiente encargo consiste en preparar una consulta que devuelva 
-- la máxima y mínima cantidad de carga para un pedido (freight) enviado a 
-- Reino Unido (United Kingdom).

SELECT MAX(freight), MIN(freight), ship_country
	FROM orders
		WHERE ship_country = "UK";

-- Después de analizar los resultados de alguna de nuestras consultas anteriores, 
-- desde el departamento de Ventas quieren conocer qué productos en concreto se venden por 
-- encima del precio medio para todos los productos de la empresa, ya que sospechan que dicho 
-- número es demasiado elevado. También quieren que ordenemos los resultados por su precio de mayor a menor.
-- 📌NOTA: para este ejercicio puedes necesitar dos consultas separadas y usar el resultado de la primera para 
-- filtrar la segunda.

-- Según nota: primero sacamos la media de unit_price y luego utilizamos el dato para la condición en la siguiente query.
SELECT AVG(unit_price)
	FROM products;

SELECT product_name, unit_price
	FROM products
		WHERE unit_price > 28.866363636363637;

-- De cara a estudiar el histórico de la empresa nos piden una consulta para conocer el número de productos que se 
-- han descontinuado. El atributo Discontinued es un booleano: si es igual a 1 el producto ha sido descontinuado.

SELECT COUNT(discontinued)
	FROM products
		WHERE discontinued = 1;

-- Adicionalmente nos piden detalles de aquellos productos no descontinuados, sobre todo el ProductID y ProductName. 
-- Como puede que salgan demasiados resultados, nos piden que los limitemos a los 10 con ID más elevado, que serán los 
-- más recientes. No nos pueden decir del departamento si habrá pocos o muchos resultados, pero lo limitamos por si acaso.

SELECT product_id, product_name 
	FROM products
		WHERE discontinued = 0
        ORDER BY product_id DESC
		LIMIT 10;

-- Desde logística nos piden el número de pedidos y la máxima cantidad de carga de entre los mismos (freight) que han sido 
-- enviados por cada empleado (mostrando el ID de empleado en cada caso).

SELECT customer_id, COUNT(order_id), MAX(freight)
	FROM orders
    GROUP BY customer_id;

-- PREGUNTAR A CÉSAR --

/* Una vez han revisado los datos de la consulta anterior, nos han pedido afinar un poco más el "disparo". 
En el resultado anterior se han incluido muchos pedidos cuya fecha de envío estaba vacía, por lo que tenemos 
que mejorar la consulta en este aspecto. También nos piden que ordenemos los resultados según el ID de empleado 
para que la visualización sea más sencilla. */

SELECT shipped_date
	FROM orders;

UPDATE orders
	SET shipped_date = NULL
	WHERE shipped_date = '0000-00-00 00:00:00';

SELECT customer_id, shipped_date, COUNT(order_id), MAX(freight)
	FROM orders
    WHERE shipped_date NOT IN ('0000-00-00 00:00:00')
    GROUP BY customer_id
    ORDER BY customer_id;Ç
    
/* Números de pedidos por día:
El siguiente paso en el análisis de los pedidos va a consistir en conocer mejor la distribución de los mismos 
según las fechas. Por lo tanto, tendremos que generar una consulta que nos saque el número de pedidos para 
cada día, mostrando de manera separada el día (DAY()), el mes (MONTH()) y el año (YEAR()). */

SELECT *
	FROM orders;
    
SELECT COUNT(order_id), DAY(order_date), MONTH(order_date), YEAR(order_date)
	FROM orders
    GROUP BY order_id;
    
/* Número de pedidos por mes y año:
La consulta anterior nos muestra el número de pedidos para cada día concreto, pero esto es demasiado detalle. 
Genera una modificación de la consulta anterior para que agrupe los pedidos por cada mes concreto de cada año. */

SELECT COUNT(order_id), MONTH(order_date), YEAR(order_date)
	FROM orders
    GROUP BY MONTH(order_date), YEAR(order_date);

/*Seleccionad las ciudades con 4 o más empleadas:
Desde recursos humanos nos piden seleccionar los nombres de las ciudades con 4 o más empleadas de cara a 
estudiar la apertura de nuevas oficinas. */

USE northwind;

SELECT *
	FROM employees;
    
SELECT city, COUNT(employee_id)
	FROM employees
    GROUP BY city
    HAVING COUNT(employee_id) >= 4;

/* Cread una nueva columna basándonos en la cantidad monetaria:
Necesitamos una consulta que clasifique los pedidos en dos categorías ("Alto" y "Bajo") en función 
de la cantidad monetaria total que han supuesto: por encima o por debajo de 2000 euros. */

SELECT *
	FROM order_details;
    
SELECT order_id, 
	SUM(unit_price) AS total_unit_price, 
	SUM(quantity) AS total_quantity, 
    MAX(discount) AS max_discount, 
    SUM(unit_price * quantity * (1 - discount)) AS total_price,
		CASE 
			WHEN SUM(unit_price * quantity * (1 - discount)) > 2000 THEN "alto"
			ELSE "bajo"
			END AS categoría
		FROM order_details
		GROUP BY order_id;