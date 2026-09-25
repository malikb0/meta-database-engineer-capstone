# Database

SQL assets for the Little Lemon database, grouped by role.

| Directory | Contents |
|---|---|
| [`schema/`](schema/) | Forward-engineered schema (`LittleLemonDB-Schema-Script.sql`), the MySQL Workbench model (`LittleLemonDM.mwb`), and ER / database screenshots. |
| [`seed/`](seed/) | Synthetic seed data (`littlelemon_dummy_data.sql`). |
| [`programmability/`](programmability/) | Consolidated, idempotent views and stored procedures (`LittleLemonDB-Programmability.sql`). |

Load order is **schema → seed → programmability**. See [Setup](../docs/setup.md) and
[Database design](../docs/database-design.md).
