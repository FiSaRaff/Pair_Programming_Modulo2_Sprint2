USE northwind;

-- EJERCICIO 1 Pedidos por empresa en UK:conocer cuántos pedidos ha realizado cada empresa cliente de UK. Nos piden el ID del cliente y el nombre de la empresa y el número de pedidos.

SELECT c.customer_id, c.company_name
	FROM customers AS c
    INNER JOIN orders AS o
    ON c.customer_id = o.customer_id
    WHERE c.country = "UK";
    
-- EJERCICIO 2 query que nos sirva para conocer cuántos objetos ha pedido cada empresa cliente de UK durante cada año
-- Nos piden concretamente conocer el nombre de la empresa, el año, y la cantidad de objetos que han pedido. Para ello 
-- hará falta hacer 2 joins.    

SELECT c.company_name,o.shipped_date,od.quantity
	FROM order_details AS od
    INNER JOIN orders AS o
    ON od.order_id = o.order_id
    INNER JOIN customers AS c 
    ON o.customer_id = c.customer_id
	WHERE c.country = "UK"
    GROUP BY o.shipped_date
	HAVING COUNT(od.quantity);
    
--    
   
   
    
    
    