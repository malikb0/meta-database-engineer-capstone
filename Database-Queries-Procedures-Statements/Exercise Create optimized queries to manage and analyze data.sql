use LittleLemonDB;

delimiter //
CREATE PROCEDURE IF NOT EXISTS GetMaxQuantity()  
begin
select max(quantity) as 'Max Quantity in Order' from orders;
end //
delimiter ; 

call GetMaxQuantity();


PREPARE GetOrderDetail  from  
'select order_id as OrderID, quantity as Quantity, total_cost as Cost from orders
where customer_id = ?';

SET @id = 1;
EXECUTE GetOrderDetail USING @id;





DELIMITER //
CREATE PROCEDURE CancelOrder(IN id INT)
BEGIN
delete from orders
where order_id = id;
SELECT CONCAT('Order ', id, ' is cancelled') as 'Confirmation';
END //
DELIMITER ;

call CancelOrder(20);




