use LittleLemonDB;

/* Task 1 INSERT statements  */

Insert into bookings (booking_id, booking_date, table_number, customer_id)
values 
(1, '2022-10-10', 5, 1),
(2, '2022-11-12', 3, 3),
(3, '2022-10-11', 2, 2),
(4, '2022-10-13', 2, 1);

select * from bookings where booking_id < 5;



/* Task 2 CheckBooking Procedure  */


DELIMITER //
CREATE PROCEDURE CheckBooking(IN b_date DATE, IN t_no INT)
BEGIN
    SELECT 
        CASE 
            WHEN COUNT(*) >= 1 THEN CONCAT('Table ', t_no, ' is already booked')
            ELSE CONCAT('Table ', t_no, ' is Available')
        END AS 'Booking Status'
    FROM bookings
    WHERE booking_date = b_date AND table_number = t_no;
END //
DELIMITER ;
drop PROCEDURE CheckBooking;

call CheckBooking('2022-11-12', 3);

/* Task 3 AddValidBooking Procedure  */
DELIMITER //
CREATE PROCEDURE AddValidBooking(IN b_date DATE, IN t_no INT)
BEGIN
DECLARE booking_count INT;
DECLARE Booking_Status varchar(50);
START TRANSACTION;
INSERT INTO bookings (booking_date, table_number) values (b_date, t_no);
     SELECT 
		COUNT(*) into booking_count 
    FROM bookings
    WHERE booking_date = b_date AND table_number = t_no; 
	IF booking_count > 1 THEN 
		SET Booking_Status = CONCAT('Table ', t_no, ' is already booked - booking cancelled') ;
		rollback;
	ELSE 
		SET Booking_Status = CONCAT('Table ', t_no, ' is Available - booking confirmed'); 
		commit;
	END IF;
    Select Booking_Status as 'Booking Status';
END //
DELIMITER ;

call AddValidBooking('2022-12-17', 6);





