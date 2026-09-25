# Queries

The step-by-step SQL exercise scripts, plus screenshots of their results.

| File | Contains |
|---|---|
| [`01-views-and-joins.sql`](01-views-and-joins.sql) | `OrdersView`, a four-table join, and an `ANY` subquery. |
| [`02-stored-procedures.sql`](02-stored-procedures.sql) | `GetMaxQuantity`, a prepared statement, and `CancelOrder`. |
| [`03-check-and-validate-bookings.sql`](03-check-and-validate-bookings.sql) | `CheckBooking` and the transactional `AddValidBooking`. |
| [`04-manage-bookings-procedures.sql`](04-manage-bookings-procedures.sql) | `AddBooking`, `UpdateBooking`, `CancelBooking`. |
| [`results/`](results/) | Result screenshots. |

The canonical, idempotent definitions live in
[`db/programmability/`](../db/programmability/). See
[Queries and procedures](../docs/queries-and-procedures.md).
