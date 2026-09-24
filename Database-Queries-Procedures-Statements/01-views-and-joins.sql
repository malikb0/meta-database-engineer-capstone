USE LittleLemonDB;

/*   Summary view: orders with quantity greater than 2   */
create view Virtual_OrdersView as
select order_id as OrderID, quantity as Quantity, total_cost as Cost 
from orders
where quantity > 2;

select * from Virtual_OrdersView;

/*   Join across customers, orders, menu and menu_item   */
select 
	cst.customer_id as CustomerID, 
    full_name as FullName, 
    order_id as OrderID, 
    total_cost as Cost, 
    menu_name as MenuName,
    course_name as CourseName
from customers as cst 
left join orders as odr on cst.customer_id = odr.customer_id
left join menu as mn on odr.menu_id = mn.menu_id
left join menu_item as mnit on mn.menu_item_id = mnit.menu_item_id
where total_cost > 150;

/*   Subquery: menu items ordered more than twice   */

select menu_name from menu 
where menu_id = any (
select mn.menu_id from menu as mn 
right join orders as odr on mn.menu_id = odr.menu_id
where quantity > 2)


