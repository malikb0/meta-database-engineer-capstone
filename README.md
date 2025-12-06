# meta-database-engineer-capstone
Repository created for Meta Data Base Engineer Capstone Project 

## Index

1. Database Setup [Go](#littlelemon-database-modeling-and-schema-creation)
2. Create virtual tables [Go](#create-a-virtual-table-to-summarize-data)
3. Creat optimized queires to manage and analyze data [Go](#create-optimized-queires-to-manage-and-analyze-data)
4. Create SQL queries to add and update bookings [Go](#create-sql-queries-to-add-and-update-bookings)



## LittleLemon Database Modeling and Schema Creation 


### Prerequisites 
Use MySQL Workbench to create the ER diagram and to implement it in your MySQL server.


#### Task Instructions 
Little Lemon wants you to use MySQL Workbench to develop a relational database system and implement it in MySQL server. Save your database capstone project files in a folder on your machine and name it db-capstone-project.


#### Task 1
In this task, you need to create a normalized ER diagram (that adheres to 1NF, 2NF and 3NF) with relevant relationships to meet the data requirements of Little Lemon. When creating your diagram, include the following tables:

* Bookings: To store information about booked tables in the restaurant including booking id, date and table number.

* Orders: To store information about each order such as order date, quantity and total cost.

* Order delivery status: To store information about the delivery status of each order such as delivery date and status.

* Menu: To store information about cuisines, starters, courses, drinks and desserts.

* Customer details: To store information about the customer names and contact details.

* Staff information: Including role and salary.

Here is some guidance for completing this task:

* Identify entities and related attributes. 

* Identify primary and foreign keys.

* Define data types and constraints. 

Once you have designed your ER diagram inside your MySQL Workbench Model Editor you then need to save your data model as LittleLemonDM and export it as a PNG file.


![Solution Image](./LittleLemon-Database-Setup/LittleLemonDM-ER.png)


### Task 2
In this second task, you need to implement the Little Lemon data model inside your MySQL server. Here is some guidance for completing this task:

* Use the forward engineer method in MySQL Workbench to implement the Little Lemon data model inside MySQL server. 

* Name your database LittleLemonDB. 

Export the LittleLemonDB as a single contained SQL file and save it in the db-capstone-project folder.


![Solution Image](./LittleLemon-Database-Setup/schema-forward-engineering-snap.png)


### Task 3
In the third and final task, you need to show the databases in the MySQL server. Write a SQL code inside MySQL Workbench SQL editor to show all your databases in MySQL server. Check if the Little Lemon database is included in the list.


![Solution Image](./LittleLemon-Database-Setup/LittleLemonDB-DATABASE.png)


## Create virtual tables to summarize data

### Task instructions

Little Lemon need you to create some reports on the orders placed in the restaurant. Complete the following tasks to help Little Lemon obtain the relevant information about the menu’s orders.

Little Lemon uses an à-la-carte model. Customers may order any single item, including starter-only, dessert-only, or drinks-only items.

### Task 1

In the first task, Little Lemon need you to create a virtual table called OrdersView that focuses on OrderID, Quantity and Cost columns within the Orders table for all orders with a quantity greater than 2. 

Here’s some guidance around completing this task: 

* Use a CREATE VIEW statement.

* Extract the order id, quantity and cost data from the Orders table.

* Filter data from the orders table based on orders with a quantity greater than 2. 

You can query the OrdersView table using the following syntax:

```
     Select * from OrdersView;
```


![Solution Image](./Database-Queries-Procedures-Statements/Result%20of%20Virtual%20Table%20Query.png)
 


Depending on your schema, this column may be named TotalCost. The screenshot uses Cost for simplicity.

### Task 2

For your second task, Little Lemon need information from four tables on all customers with orders that cost more than $150. Extract the required information from each of the following tables by using the relevant JOIN clause: 

* Customers table: The customer id and full name.

* Orders table: The order id and cost.

* Menus table: The menus name.

* MenusItems table: the item’s name and category (e.g., starter, main, dessert, drink).

The result set should be sorted by the lowest cost amount.


![Solution Image](./Database-Queries-Procedures-Statements/Result%20of%20Join%20Statement.png)



### Task 3

For the third and final task, Little Lemon need you to find all menu items for which more than 2 orders have been placed using a subquery. You can carry out this task by creating a subquery that lists the menu names from the menus table for any order quantity with more than 2.

Here’s some guidance around completing this task: 

* Use the ANY operator in a subquery

* The outer query should be used to select the menu name from the menus table.

* The inner query should check if any item quantity in the order table is more than 2. 


![Solution Image](./Database-Queries-Procedures-Statements/Result%20of%20SubQuery.png)



## Create optimized queires to manage and analyze data

### Task 1

In this first task, Little Lemon need you to create a procedure that displays the maximum ordered quantity in the Orders table. 

Creating this procedure will allow Little Lemon to reuse the logic implemented in the procedure easily without retyping the same code over again and again to check the maximum quantity. 

You can call the procedure GetMaxQuantity and invoke it as follows:

```
     CALL GetMaxQuantity();
```


![Solution Image](./Database-Queries-Procedures-Statements/Result%20of%20StoreProcedure%20GetMaxQuantity.png)



### Task 2

In the second task, Little Lemon need you to help them to create a prepared statement called GetOrderDetail. This prepared statement will help to reduce the parsing time of queries. It will also help to secure the database from SQL injections.

The prepared statement should accept one input argument, the CustomerID value, from a variable. 

The statement should return the order id, the quantity and the order cost from the Orders table. 

Once you create the prepared statement, you can create a variable called id and assign it value of 1. 

Then execute the GetOrderDetail prepared statement using the following syntax:

```
     SET @id = 1;
     EXECUTE GetOrderDetail USING @id;

```


![Solution Image](./Database-Queries-Procedures-Statements/Result%20of%20Prepared%20Statement.png)



### Task 3

Your third and final task is to create a stored procedure called CancelOrder. Little Lemon want to use this stored procedure to delete an order record based on the user input of the order id.

Creating this procedure will allow Little Lemon to cancel any order by specifying the order id value in the procedure parameter without typing the entire SQL delete statement.   



![Solution Image](./Database-Queries-Procedures-Statements/Result%20of%20CancelOrder%20procedure.png)



## Create SQL queries to check available bookings based on user input

### Task 1

Little Lemon wants to populate the Bookings table of their database with some records of data. Your first task is to replicate the list of records in the following table by adding them to the Little Lemon booking table. 

You can use simple INSERT statements to complete this task.

| BookingID    | BookingDate  | TableNumber  | CustomerID |
| ------------ | -------------| ------------ | ---------- |
|    1         |   2022-10-10 |    5         |        1   |
|    2         |   2022-11-12 |    3         |        3   |
|    3         |   2022-10-11 |    2         |        2   |
|    4         |   2022-10-13 |    2         |        1   |




![Solution Image](./Database-Queries-Procedures-Statements/Result%20of%20Select%20after%20Inserts.png)




### Task 2

For your second task, Little Lemon need you to create a stored procedure called CheckBooking to check whether a table in the restaurant is already booked. Creating this procedure helps to minimize the effort involved in repeatedly coding the same SQL statements.

The procedure should have two input parameters in the form of booking date and table number. You can also create a variable in the procedure to check the status of each table.



![Solution Image](./Database-Queries-Procedures-Statements/Result%20of%20CheckBooking%20Procedure.png)



### Task 3

For your third and final task, Little Lemon need to verify a booking, and decline any reservations for tables that are already booked under another name. 

Since integrity is not optional, Little Lemon need to ensure that every booking attempt includes these verification and decline steps. However, implementing these steps requires a stored procedure and a transaction. 

To implement these steps, you need to create a new procedure called AddValidBooking. This procedure must use a transaction statement to perform a rollback if a customer reserves a table that’s already booked under another name.  

Use the following guidelines to complete this task:

* The procedure should include two input parameters in the form of booking date and table number.

* It also requires at least one variable and should begin with a START TRANSACTION statement.

* Your INSERT statement must add a new booking record using the input parameter's values.

* Use an IF ELSE statement to check if a table is already booked on the given date. 

* If the table is already booked, then rollback the transaction. If the table is available, then commit the transaction. 



![Solution Image](./Database-Queries-Procedures-Statements/Result%20of%20AddValidBooking%20Procedure.png)



## Create SQL queries to add and update bookings

### Task 1

In this first task you need to create a new procedure called AddBooking to add a new table booking record.

The procedure should include four input parameters in the form of the following bookings parameters:

* booking id, 

* customer id, 

* booking date,

* and table number.



![Solution Image](./Database-Queries-Procedures-Statements/Result%20of%20AddBooking%20procedure.png)



### Task 2

For your second task, Little Lemon need you to create a new procedure called UpdateBooking that they can use to update existing bookings in the booking table.

The procedure should have two input parameters in the form of booking id and booking date. You must also include an UPDATE statement inside the procedure. 



![Solution Image](./Database-Queries-Procedures-Statements/Result%20of%20UpdateBooking%20Procedure.png)



### Task 3


For the third and final task, Little Lemon need you to create a new procedure called CancelBooking that they can use to cancel or remove a booking.

The procedure should have one input parameter in the form of booking id. You must also write a DELETE statement inside the procedure. 



![Solution Image](./Database-Queries-Procedures-Statements/Result%20of%20CancelBooking%20Procedure.png)