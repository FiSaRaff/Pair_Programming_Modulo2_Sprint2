USE northwind;

SELECT  'Hola!'  AS tipo_nombre
FROM customers;

SELECT *
	FROM customers;
    
/* tabla con aquelas compañias que están afincadas en ciudades que empiezan por "A" o "B". 
Necesita que le devolvamos la ciudad, el nombre de la compañia y el nombre de contacto */

SELECT city, company_name, contact_name
	FROM customers
    WHERE city LIKE 'A%' OR city LIKE 'B%'; 

/* devolver los mismos campos que en la query anterior el número de total de pedidos que han 
hecho todas las ciudades que empiezan por "L" */
-- c.city, c.company_name, c.contact_name, COUNT(o.order_date)

SELECT c.city, COUNT(o.order_date)
	FROM customers AS c
    INNER JOIN orders AS o
    ON c.customer_id = o.customer_id
    GROUP BY city
    HAVING city LIKE 'L%';

-- extraer los clientes que no sean de USA. Extraer el nombre de contacto, su pais y el nombre 
-- de la compañia.

SELECT contact_name, country, company_name
	FROM customers
    WHERE country NOT LIKE 'USA';

-- Todos los clientes que no tengan una "A" en segunda posición en su nombre.
-- Devolved unicamente el nombre de contacto.

SELECT contact_name
	FROM customers
    WHERE contact_name NOT LIKE '_A%';

