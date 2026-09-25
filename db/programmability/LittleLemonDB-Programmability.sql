-- ---------------------------------------------------------------------------
-- LittleLemonDB - Programmability (views + stored procedures)
-- ---------------------------------------------------------------------------
-- Consolidated, idempotent script containing the database's views and stored
-- procedures. Safe to re-run.
--
-- Note: the GetOrderDetail PREPARE statement is session-scoped in MySQL, so it
-- cannot live in a schema bootstrap script. It is kept in
-- `queries/02-stored-procedures.sql` instead.
-- ---------------------------------------------------------------------------

USE LittleLemonDB;

-- ---------------------------------------------------------------------------
-- Views
-- ---------------------------------------------------------------------------
DROP VIEW IF EXISTS OrdersView;

CREATE VIEW OrdersView AS
SELECT
    order_id   AS OrderID,
    quantity   AS Quantity,
    total_cost AS Cost
FROM orders
WHERE quantity > 2;

-- ---------------------------------------------------------------------------
-- Procedures
-- ---------------------------------------------------------------------------

DROP PROCEDURE IF EXISTS GetMaxQuantity;
DELIMITER //
CREATE PROCEDURE GetMaxQuantity()
BEGIN
    SELECT MAX(quantity) AS `Max Quantity in Order` FROM orders;
END //
DELIMITER ;

DROP PROCEDURE IF EXISTS CancelOrder;
DELIMITER //
CREATE PROCEDURE CancelOrder(IN order_id_in INT)
BEGIN
    DELETE FROM orders WHERE order_id = order_id_in;
    SELECT CONCAT('Order ', order_id_in, ' is cancelled') AS Confirmation;
END //
DELIMITER ;

DROP PROCEDURE IF EXISTS CheckBooking;
DELIMITER //
CREATE PROCEDURE CheckBooking(IN booking_date_in DATE, IN table_number_in INT)
BEGIN
    SELECT
        CASE
            WHEN COUNT(*) >= 1 THEN CONCAT('Table ', table_number_in, ' is already booked')
            ELSE CONCAT('Table ', table_number_in, ' is available')
        END AS `Booking Status`
    FROM bookings
    WHERE booking_date = booking_date_in AND table_number = table_number_in;
END //
DELIMITER ;

-- Checks availability BEFORE inserting, then commits only if the table is
-- free. This avoids two concurrent inserts both passing the check.
DROP PROCEDURE IF EXISTS AddValidBooking;
DELIMITER //
CREATE PROCEDURE AddValidBooking(IN booking_date_in DATE, IN table_number_in INT)
BEGIN
    DECLARE booking_count INT;
    START TRANSACTION;

    SELECT COUNT(*) INTO booking_count
    FROM bookings
    WHERE booking_date = booking_date_in AND table_number = table_number_in;

    IF booking_count >= 1 THEN
        ROLLBACK;
        SELECT CONCAT('Table ', table_number_in, ' is already booked - booking cancelled') AS `Booking Status`;
    ELSE
        INSERT INTO bookings (booking_date, table_number)
        VALUES (booking_date_in, table_number_in);
        COMMIT;
        SELECT CONCAT('Table ', table_number_in, ' is available - booking confirmed') AS `Booking Status`;
    END IF;
END //
DELIMITER ;

DROP PROCEDURE IF EXISTS AddBooking;
DELIMITER //
CREATE PROCEDURE AddBooking(
    IN booking_id_in INT,
    IN customer_id_in INT,
    IN table_number_in INT,
    IN booking_date_in DATE
)
BEGIN
    DECLARE booking_count INT;
    START TRANSACTION;

    SELECT COUNT(*) INTO booking_count
    FROM bookings
    WHERE booking_date = booking_date_in AND table_number = table_number_in;

    IF booking_count >= 1 THEN
        ROLLBACK;
        SELECT CONCAT('Table ', table_number_in, ' is already booked - booking cancelled') AS `Booking Status`;
    ELSE
        INSERT INTO bookings (booking_id, booking_date, table_number, customer_id)
        VALUES (booking_id_in, booking_date_in, table_number_in, customer_id_in);
        COMMIT;
        SELECT 'New booking added' AS `Booking Status`;
    END IF;
END //
DELIMITER ;

DROP PROCEDURE IF EXISTS UpdateBooking;
DELIMITER //
CREATE PROCEDURE UpdateBooking(IN booking_id_in INT, IN booking_date_in DATE)
BEGIN
    DECLARE test_date DATE;
    START TRANSACTION;

    UPDATE bookings
    SET booking_date = booking_date_in
    WHERE booking_id = booking_id_in;

    SELECT booking_date INTO test_date
    FROM bookings
    WHERE booking_id = booking_id_in;

    IF test_date = booking_date_in THEN
        COMMIT;
        SELECT CONCAT('Booking ', booking_id_in, ' updated') AS Confirmation;
    ELSE
        ROLLBACK;
        SELECT CONCAT('Booking ', booking_id_in, ' update failed') AS Confirmation;
    END IF;
END //
DELIMITER ;

DROP PROCEDURE IF EXISTS CancelBooking;
DELIMITER //
CREATE PROCEDURE CancelBooking(IN booking_id_in INT)
BEGIN
    START TRANSACTION;

    DELETE FROM bookings WHERE booking_id = booking_id_in;

    IF EXISTS (SELECT booking_id FROM bookings WHERE booking_id = booking_id_in) THEN
        ROLLBACK;
        SELECT CONCAT('Booking ', booking_id_in, ' delete failed') AS Confirmation;
    ELSE
        COMMIT;
        SELECT CONCAT('Booking ', booking_id_in, ' cancelled') AS Confirmation;
    END IF;
END //
DELIMITER ;
