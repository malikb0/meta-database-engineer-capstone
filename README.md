# meta-database-engineer-capstone
Repository created for Meta Data Base Engineer Capstone Project 

## Index

1. Database Setup [Go](#littlelemon-database-modeling-and-schema-creation)


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


### Task 2
In this second task, you need to implement the Little Lemon data model inside your MySQL server. Here is some guidance for completing this task:

* Use the forward engineer method in MySQL Workbench to implement the Little Lemon data model inside MySQL server. 

* Name your database LittleLemonDB. 

Export the LittleLemonDB as a single contained SQL file and save it in the db-capstone-project folder.


### Task 3
In the third and final task, you need to show the databases in the MySQL server. Write a SQL code inside MySQL Workbench SQL editor to show all your databases in MySQL server. Check if the Little Lemon database is included in the list.