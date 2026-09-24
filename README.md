# Little Lemon Database — Meta Database Engineer Capstone

A relational database system for a restaurant ("Little Lemon"), designed and
implemented end-to-end: ER modelling, a normalised MySQL schema, analytical SQL
(views, joins, subqueries, stored procedures, transactions), an interactive
Tableau dashboard, and a Python client using `mysql-connector-python`.

> **Disclaimer:** This is an independent educational/portfolio project. It is not
> affiliated with, authorised, or endorsed by Meta or Coursera. See
> [NOTICE.md](./NOTICE.md) for details.

---

## Overview

Little Lemon is a small à-la-carte restaurant. This project models its day-to-day
operations — bookings, orders, delivery status, menu, customers and staff — and
builds the queries, reports and dashboard the business would need to run and
analyse itself.

The work is organised into four parts:

1. **Database modeling & schema** — a normalised ER model implemented in MySQL.
2. **Analytical SQL** — summary views, multi-table joins, subqueries and
   optimised stored procedures.
3. **Data visualization** — an interactive Tableau dashboard for sales and profit.
4. **Python client** — a Jupyter notebook that connects to MySQL and reports on
   the data.

---

## Tech stack

| Area            | Tools                                                        |
| --------------- | ------------------------------------------------------------ |
| Database        | MySQL 8, MySQL Workbench                                     |
| Queries / logic | SQL — views, joins, subqueries, stored procedures, transactions |
| Visualization   | Tableau                                                      |
| Client          | Python 3.12, `mysql-connector-python`, Jupyter               |
| Packaging       | Pipenv, Docker Compose                                       |

---

## Repository structure

```
.
├── LittleLemon-Database-Setup/          # ER model + schema + programmability
│   ├── LittleLemonDM.mwb                # MySQL Workbench data model
│   ├── LittleLemonDM-ER.png             # ER diagram (exported)
│   ├── LittleLemonDB-Schema-Script.sql  # Forward-engineered schema
│   └── LittleLemonDB-Programmability.sql# Views + stored procedures
├── Database-Queries-Procedures-Statements/
│   ├── 01-views-and-joins.sql           # Summary view, joins, subquery
│   ├── 02-stored-procedures.sql         # GetMaxQuantity, prepared stmt, CancelOrder
│   ├── 03-check-and-validate-bookings.sql
│   ├── 04-manage-bookings-procedures.sql
│   ├── littlelemon_dummy_data.sql       # Synthetic seed data
│   └── Result of *.png                  # Query result screenshots
├── Clients-and-Visualization/
│   ├── LittleLemonData.xlsx             # Data source for Tableau
│   ├── LittleLemonDB-Tableau-Analysis.twb
│   ├── jupyter-python-mysql-client-.ipynb
│   └── *.png                            # Tableau / notebook screenshots
├── scripts/
│   └── littlelemon_cli.py               # Standalone reporting CLI
├── docker-compose.yml                   # One-command MySQL setup
├── .env.example                         # Configuration template (no secrets)
├── NOTICE.md                            # Attribution & disclaimer
└── README.md
```

---

## Database design

The model is normalised (1NF–3NF) with primary keys, foreign keys and referential
actions defined for every relationship.

![ER diagram](./LittleLemon-Database-Setup/LittleLemonDM-ER.png)

The schema was generated with MySQL Workbench's forward-engineering feature:

![Forward engineering](./LittleLemon-Database-Setup/schema-forward-engineering-snap.png)

Resulting database:

![Databases list](./LittleLemon-Database-Setup/LittleLemonDB-DATABASE.png)

**Tables**

| Table             | Purpose                                                        |
| ----------------- | -------------------------------------------------------------- |
| `customers`       | Customer name and contact details                              |
| `bookings`        | Table reservations (date, table number, customer)             |
| `orders`          | Order header (date, quantity, total cost, customer, menu)      |
| `delivery_status` | Delivery state of an order and the assigned staff member       |
| `menu`            | Menu offered per item, with cuisine                            |
| `menu_item`       | Course / starter / drink composition of a menu item            |
| `staff`           | Staff name, role and salary                                    |

---

## Analytical SQL

### Summary views, joins and subqueries

`01-views-and-joins.sql` contains:

- **`OrdersView`** — a summary view of orders with a quantity greater than 2.
- A **multi-table join** across `customers`, `orders`, `menu` and `menu_item`
  for orders above a cost threshold.
- A **subquery** using `ANY` to list menu items ordered more than twice.

Orders above the quantity threshold:

![Virtual table query](./Database-Queries-Procedures-Statements/Result%20of%20Virtual%20Table%20Query.png)

Join result:

![Join result](./Database-Queries-Procedures-Statements/Result%20of%20Join%20Statement.png)

Subquery result:

![Subquery result](./Database-Queries-Procedures-Statements/Result%20of%20SubQuery.png)

### Stored procedures

`02-stored-procedures.sql` implements reusable logic:

- `GetMaxQuantity()` — the maximum quantity ordered.
- `GetOrderDetail` — a **prepared statement** taking a `CustomerID` variable.
- `CancelOrder(order_id)` — deletes an order by id.

![GetMaxQuantity](./Database-Queries-Procedures-Statements/Result%20of%20StoreProcedure%20GetMaxQuantity.png)

Prepared statement:

![Prepared statement](./Database-Queries-Procedures-Statements/Result%20of%20Prepared%20Statement.png)

Cancel order:

![Cancel order](./Database-Queries-Procedures-Statements/Result%20of%20CancelOrder%20procedure.png)

### Bookings: checking and validation

`03-check-and-validate-bookings.sql` seeds the bookings table and adds:

- `CheckBooking(date, table_number)` — reports whether a table is free.
- `AddValidBooking(date, table_number)` — a **transactional** procedure that
  checks availability **before** inserting, rolling back if the table is taken.

![CheckBooking](./Database-Queries-Procedures-Statements/Result%20of%20CheckBooking%20Procedure.png)

![AddValidBooking](./Database-Queries-Procedures-Statements/Result%20of%20AddValidBooking%20Procedure.png)

### Managing bookings

`04-manage-bookings-procedures.sql` adds `AddBooking`, `UpdateBooking` and
`CancelBooking` — each wrapped in a transaction.

![AddBooking](./Database-Queries-Procedures-Statements/Result%20of%20AddBooking%20procedure.png)

![UpdateBooking](./Database-Queries-Procedures-Statements/Result%20of%20UpdateBooking%20Procedure.png)

![CancelBooking](./Database-Queries-Procedures-Statements/Result%20of%20CancelBooking%20Procedure.png)

> The consolidated, idempotent version of all views and procedures lives in
> `LittleLemon-Database-Setup/LittleLemonDB-Programmability.sql`.

---

## Data visualization (Tableau)

The Excel export of the data is analysed in Tableau. Calculations and charts
include a derived `Profit` field (`Sales - Cost`), a customer name split, a
sales bar chart, a profit trend, a bubble chart and a cuisine comparison — all
combined into one interactive dashboard (clicking a customer filters the
bubbles).

Source filtering and name split:

![Tableau source filter](./Clients-and-Visualization/Tableau-Soruce-Select-and-filter.png)

![Customer name split](./Clients-and-Visualization/Tableau-Customer-Name-Split.png)

Calculated profit field:

![Calculated profit](./Clients-and-Visualization/Tableau-Calculated-Profit-field.png)

Charts:

![Customers sales](./Clients-and-Visualization/Tableau-Chart-Customer-Sales.png)

![Profit chart](./Clients-and-Visualization/Tableau-Profit-Chart.png)

![Sales bubble chart](./Clients-and-Visualization/Tableau-Sales-Bubble-Chart.png)

![Cuisine sales and profits](./Clients-and-Visualization/Tableau-Cuisine-Sales-Profits.png)

Interactive dashboard:

![Interactive dashboard](./Clients-and-Visualization/Tableau-Interactive-dashboard.png)

---

## Python client

`Clients-and-Visualization/jupyter-python-mysql-client-.ipynb` connects to MySQL
through a **connection pool**, lists the database tables and runs a reporting
query that returns every customer who spent more than $60.

Successful connection and first query:

![MySQL connection](./Clients-and-Visualization/jupyter-mysql-connection.png)

Join query result:

![Python join query](./Clients-and-Visualization/jupyter-query-with-table-JOIN.png)

Credentials are read from environment variables — see below. The notebook uses
`python-dotenv` when it is installed, and otherwise falls back to reading the
`.env` file directly, so it works either way.

### Command-line reporting tool

`scripts/littlelemon_cli.py` is a standalone automation layer over the database.
It uses the same connection pool and environment configuration, runs
parameterised read-only queries, and can export results to CSV.

```bash
# Connectivity and row counts
python scripts/littlelemon_cli.py health

# Headline metrics: orders, revenue, average order value, max quantity
python scripts/littlelemon_cli.py summary

# Revenue by cuisine
python scripts/littlelemon_cli.py cuisines

# Customers above a spend threshold (export to CSV with --csv)
python scripts/littlelemon_cli.py customers --min-total 60 --limit 10
python scripts/littlelemon_cli.py customers --min-total 60 --csv exports/customers.csv

# Check whether a table is free on a given date
python scripts/littlelemon_cli.py check --date 2022-11-12 --table 3
```

---

## Getting started

### Requirements

- Python 3.12 and [Pipenv](https://pipenv.pypa.io/)
- Docker + Docker Compose (for the quickest path), **or** a local MySQL 8 server
  and MySQL Workbench.

### 1. Configuration

Copy the template and fill in your local values:

```bash
cp .env.example .env
```

`.env` is git-ignored and must never be committed. It contains:

```
DB_USER=...
DB_PASSWORD=...
DB_HOST=127.0.0.1
DB_PORT=3306
DB_NAME=LittleLemonDB
MYSQL_ROOT_PASSWORD=...
```

### 2. Start the database

**Option A — Docker (one command):** builds a MySQL 8 container and loads the
schema, seed data and programmability scripts automatically on first start.

```bash
docker compose up -d
```

**Option B — local MySQL / Workbench:** run the scripts in order:

1. `LittleLemon-Database-Setup/LittleLemonDB-Schema-Script.sql`
2. `Database-Queries-Procedures-Statements/littlelemon_dummy_data.sql`
3. `LittleLemon-Database-Setup/LittleLemonDB-Programmability.sql`

### 3. Run the Python client

```bash
pipenv install
pipenv run jupyter notebook
```

Open `Clients-and-Visualization/jupyter-python-mysql-client-.ipynb` and run the
cells.

---

## Possible improvements

- Move the `menu_item` model to a fully normalised `menu_items(item_name,
  category)` table (currently course/starter/drink are columns).
- Add an integration test that loads the schema into an ephemeral MySQL and
  asserts the procedure behaviour.
- Parameterise the SQL scripts rather than hard-coding seed values.

---

## Attribution & license

- This project was inspired by the **Meta Database Engineer** course on Coursera;
  the course's own material is not included here. See [NOTICE.md](./NOTICE.md).
- Original code and documentation: [MIT License](./LICENSE).
