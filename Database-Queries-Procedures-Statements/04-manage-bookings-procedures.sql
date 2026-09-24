USE LittleLemonDB;

/* Add a new booking  */

DELIMITER //
CREATE PROCEDURE AddBooking(
IN bk_id INT,
IN cust_id INT ,
IN t_no INT, 
IN b_date DATE)
BEGIN
DECLARE booking_count INT;
DECLARE Booking_Status varchar(50);
START TRANSACTION;
INSERT INTO 
	bookings (booking_id, 
				booking_date, table_number, customer_id) 
                values (bk_id, b_date, t_no, cust_id);
     SELECT 
		COUNT(*) into booking_count 
    FROM bookings
    WHERE booking_date = b_date AND table_number = t_no; 
	IF booking_count > 1 THEN 
		SET Booking_Status = CONCAT('Table ', t_no, ' is already booked - booking cancelled') ;
		rollback;
	ELSE 
		SET Booking_Status = CONCAT('New booking added'); 
		commit;
	END IF;
    Select Booking_Status as 'Booking Status';
END //
DELIMITER ;

call AddBooking(9,3,4,"2022-12-30");


/* Update an existing booking's date  */

DELIMITER //
CREATE PROCEDURE UpdateBooking(IN bk_id INT, IN bk_date DATE)
BEGIN
	DECLARE test_date DATE;
	START TRANSACTION;
	UPDATE bookings 
    set booking_date = bk_date
    where booking_id = bk_id;
    
    Select booking_date into test_date from bookings where booking_id = bk_id;
    
	IF test_date = bk_date THEN
		COMMIT;
        Select CONCAT('Booking ', bk_id,' updated' ) as 'Confirmation';
	ELSE 
		ROLLBACK;
        Select CONCAT('Booking ', bk_id,' update Failed' ) as 'Confirmation';
	END IF;
END //

DELIMITER ;


call UpdateBooking(9,"2022-12-17");



/* Cancel (delete) a booking  */

DELIMITER //
CREATE PROCEDURE CancelBooking(IN bk_id INT)
BEGIN
	DECLARE testBit BOOLEAN;
    START TRANSACTION;
    DELETE FROM bookings where booking_id = bk_id;
    
    IF EXISTS(Select booking_id from bookings where booking_id = bk_id) THEN
		ROLLBACK;
        Select CONCAT('Booking ', bk_id,' Delete Failed' ) as 'Confirmation';
    ELSE
		COMMIT;
        Select CONCAT('Booking ', bk_id,' cancelled' ) as 'Confirmation';
    END IF;
END //
DELIMITER ;

CALL CancelBooking(9);


