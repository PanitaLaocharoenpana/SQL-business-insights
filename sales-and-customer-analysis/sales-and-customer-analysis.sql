USE aa630_m2_activity;
# 1.1 all products whose description contains the word “jet.”
SELECT prod_id, prod_desc
FROM products
WHERE prod_desc LIKE '%JET%';
# 1.2 returns the product ID and product price from the Products table
# creates a calculated field called new_price that adds $0.50 to each product’s price.
# sort the results by new_price from largest to smallest.
SELECT CONCAT (prod_id, prod_price) AS new_price
FROM products
ORDER BY new_price DESC;
#1.3 groups the rows in the OrderItems table by item_price and returns each price 

SELECT item_price, COUNT(*) 
FROM orderitems
GROUP BY item_price
ORDER BY item_price ASC;
#PART2 Subqueries
#2.1 returns the cust_id values from the Orders table 
# Orders table for orders that include at least one item priced at $10 or more.
SELECT cust_id
FROM orders
WHERE order_num IN (SELECT order_num
					FROM orderitems
                    WHERE item_price >=10);
                    
#2.2 returns the cust_id and the order_date for all orders 
SELECT cust_id, order_date
FROM orders
WHERE order_num IN (SELECT order_num
					FROM orderitems
                    WHERE prod_id = 'FB')
ORDER BY order_date ASC;
#2.3 returns each product’s prod_name along with the total quantity sold for that product
SELECT prod_name,
(SELECT Sum(quantity) FROM orderitems
WHERE orderitems.prod_id = products.prod_id ) AS quant_sold
FROM products ; 
#3.1 returns the customer name and order number 
#by performing an INNER JOIN between the Customers and Orders tables.
#Match records using the cust_id field, and then sort the results by cust_name and order_num in ascending order.
SELECT cust_name, order_num
FROM customers INNER JOIN orders
ON customers.cust_id = orders.cust_id
ORDER BY cust_name, order_num ASC;
#3.2 returns the customer name and order number by joining the Customers and Orders tables 
#using a JOIN clause. Match the rows using the cust_id field, 
#and then sort the results by cust_name in ascending order
SELECT cust_name, order_num
FROM customers JOIN orders
ON customers.cust_id = orders.cust_id
ORDER BY cust_name ASC;
#3.3 returns the customer name and order number using a LEFT OUTER JOIN 
#between the Customers and Orders tables. 
# Make sure the join keeps all customers, 
#even if they have no matching orders, and then sort the results by cust_name.
SELECT cust_name, order_num
FROM customers 
LEFT OUTER JOIN orders
ON customers.cust_id = orders.cust_id
ORDER BY cust_name;
