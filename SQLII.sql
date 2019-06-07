------PRACTICE JOINS------
--Get all invoices where the unit_price on the invoice_line is greater than $0.99.--

SELECT * FROM invoice i 
JOIN invoice_line il ON il.invoice_id = i.invoice_id
WHERE il.unit_price > 0.99;


--Get the invoice_date, customer first_name and last_name, and total from all invoices.--

SELECT i.invoice_date, c.first_name, c.last_name, i.total
FROM invoice i 
JOIN customer c ON i.customer_id = c.customer_id


--Get the customer first_name and last_name and the support rep's first_name and last_name from all customers.--

SELECT c.first_name, c.last_name, e.first_name, e.last_name
FROM customer c
JOIN employee e ON c.support_rep_id = e.employee_id


--Get the album title and the artist name from all albums.--

SELECT al.title, ar.name
FROM album al
JOIN artist ar ON al.album_id = ar.artist_id


--Get all playlist_track track_ids where the playlist name is Music.--

SELECT pt.track_id
FROM playlist_track pt
JOIN playlist p ON p.playlist_id = pt.playlist_id
WHERE p.name = 'Music';


--Get all track names for playlist_id 5.--

SELECT track.name
FROM track 
JOIN playlist_track ON playlist_track.track_id = track.track_id
WHERE playlist_track.playlist_id = 5;


--Get all track names and the playlist name that they're on ( 2 joins ).--

SELECT t.name, p.name
FROM track t
JOIN playlist_track pt ON t.track_id = pt.track_id
JOIN playlist p ON pt.playlist_id = p.playlist_id


--Get all track names and album titles that are the genre Alternative & Punk ( 2 joins ).--

SELECT t.name, a.title
FROM track t
JOIN album a ON t.album_id = a.album_id
JOIN genre g ON g.genre_id = t.genre_id
WHERE g.name = 'Alternative & Punk'








------PRACTICE NESTED QUERIES------
--Get all invoices where the unit_price on the invoice_line is greater than $0.99.--

SELECT * FROM invoice 
WHERE invoice_id IN (SELECT invoice_id FROM invoice_line WHERE unit_price > 0.99)


--Get all playlist tracks where the playlist name is Music.--

SELECT * FROM playlist_track 
WHERE playlist_id IN (SELECT playlist_id FROM playlist WHERE name = 'Music');


--Get all track names for playlist_id 5.--

SELECT name FROM track
WHERE track_id IN (SELECT track_id FROM playlist_track WHERE playlist_id = 5);


--Get all tracks where the genre is Comedy.--

SELECT * FROM track 
WHERE genre_id IN (SELECT genre_id FROM genre WHERE name = 'Comedy');


--Get all tracks where the album is Fireball.--

SELECT * FROM track 
WHERE album_id IN (SELECT album_id FROM album WHERE title = 'Fireball');


--Get all tracks for the artist Queen ( 2 nested subqueries ).--

SELECT * FROM track
WHERE album_id IN (SELECT album_id FROM album WHERE artist_id IN (
SELECT artist_id FROM artist WHERE name = 'Queen'))






------PRACTICE UPDATING ROWS------
--Find all customers with fax numbers and set those numbers to null.--

UPDATE customer 
SET fax = null 
WHERE fax IS NOT null;


--Find all customers with no company (null) and set their company to "Self".--

UPDATE customer 
SET company = 'Self'
WHERE company IS null;


--Find the customer Julia Barnett and change her last name to Thompson.--

UPDATE customer 
SET last_name = 'Thompson'
WHERE first_name = 'Julia' AND last_name = 'Barnett'


--Find the customer with this email luisrojas@yahoo.cl and change his support rep to 4.--

UPDATE customer 
SET support_rep_id = 4
WHERE email = 'luisrojas@yahoo.cl';


--Find all tracks that are the genre Metal and have no composer. Set the composer to "The darkness around us".--

UPDATE track 
SET composer = 'The darkness around us'
WHERE genre_id = (SELECT genre_id FROM genre WHERE name = 'Metal')
AND composer IS null;






------GROUP BY------
--Find a count of how many tracks there are per genre. Display the genre name with the count.--

SELECT COUNT(*), g.name
FROM track t
JOIN genre g ON t.genre_id = g.genre_id
GROUP BY g.name


--Find a count of how many tracks are the "Pop" genre and how many tracks are the "Rock" genre.--

SELECT COUNT(*), g.name 
FROM track t
JOIN genre g ON g.genre_id = t.genre_id 
WHERE g.name = 'Pop' OR g.name = 'Rock'
GROUP BY g.name


--Find a list of all artists and how many albums they have.--

SELECT ar.name, COUNT(*)
FROM album al
JOIN artist ar ON ar.artist_id = al.artist_id 
GROUP BY ar.name;







------USE DISTINCT------
--From the track table find a unique list of all composers.--

SELECT DISTINCT composer FROM track


--From the invoice table find a unique list of all billing_postal_codes.--

SELECT DISTINCT billing_postal_code FROM invoice 


--From the customer table find a unique list of all companys.--

SELECT DISTINCT company FROM customer;




------DELETE ROWS------
--Delete all 'bronze' entries from the table.--

DELETE FROM practice_delete WHERE type = 'bronze';


--Delete all 'silver' entries from the table.--

DELETE FROM practice_delete WHERE type = 'silver';


--Delete all entries whose value is equal to 150.--

DELETE FROM practice_delete WHERE value = 150;













-- CREATE TABLE users (
--   user_id SERIAL PRIMARY KEY,
--   user_name VARCHAR(50),
--   user_email VARCHAR(100)
-- )
-- CREATE TABLE products (
--   product_id SERIAL PRIMARY KEY,
--   product_name VARCHAR(100),
--   product_price NUMERIC
-- )
-- CREATE TABLE orders (
--   order_id SERIAL PRIMARY KEY,
--   order_quantity INTEGER,
--   order_total NUMERIC,
--   FOREIGN KEY(order_id) REFERENCES orders(order_id)
-- )



-- INSERT INTO users (user_name, user_email)
-- VALUES ('David', 'David@gtg')
-- INSERT INTO users (user_name, user_email)
-- VALUES ('Tom', 'Tom@gtg')
-- INSERT INTO users (user_name, user_email)
-- VALUES ('Mark', 'Mark@gtg')


-- SELECT * FROM users


-- INSERT INTO products (product_name, product_price)
-- VALUES ('Taco', 700)
-- INSERT INTO products (product_name, product_price)
-- VALUES ('Brisket', 20)
-- INSERT INTO products (product_name, product_price)
-- VALUES ('Strawberry', 11)



-- SELECT * FROM products



-- INSERT INTO orders (order_quantity, order_total)
-- VALUES (5, 200)
-- INSERT INTO orders (order_quantity, order_total)
-- VALUES (2, 50)
-- INSERT INTO orders (order_quantity, order_total)
-- VALUES (12, 79)



-- SELECT * FROM orders


------Get all products for the first order.------
SELECT order_quantity FROM orders WHERE order_id = 1


------Get all orders.------
SELECT * FROM orders


------Get the total cost of an order ( sum the price of all products on an order ).------
SELECT SUM(o.order_quantity * p.product_price) FROM orders AS o
INNER JOIN products AS p
ON o.order_id = p.product_id
WHERE order_id = 1


------Add a foreign key reference from orders to users.------
ALTER TABLE users
ADD COLUMN order_id INTEGER REFERENCES orders(order_id)


------Update the orders table to link a user to each order.------
UPDATE users 
SET order_id = user_id;
SELECT * FROM users


------Get all orders for a user.------
SELECT * FROM users
WHERE order_id = 1


------Get how many orders each user has.------
SELECT COUNT(*) FROM users
WHERE order_id = 1

