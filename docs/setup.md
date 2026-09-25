# Setup

How to configure and run the Little Lemon database, either with Docker Compose or against a
local MySQL server.

## Contents

- [Requirements](#requirements)
- [Configuration](#configuration)
- [Option A — Docker Compose](#option-a--docker-compose)
- [Option B — local MySQL](#option-b--local-mysql)
- [Script run order](#script-run-order)
- [Make targets](#make-targets)
- [Python environment](#python-environment)
- [Related documents](#related-documents)

## Requirements

| Tool | Version | Notes |
|---|---|---|
| Docker + Docker Compose | Compose v2+ | The quickest path. |
| Python | 3.12 | For the notebook and CLI. |
| MySQL | 8.0 | Only for Option B (or Docker pulls `mysql:8.0`). |
| MySQL Workbench | 8.x | Optional — needed to open the `.mwb` model. |

## Configuration

Copy the template and fill in your own local values:

```bash
cp .env.example .env
```

`.env` is git-ignored and must never be committed. It holds:

| Variable | Purpose |
|---|---|
| `DB_USER` | Application user. |
| `DB_PASSWORD` | Application password. |
| `DB_HOST` | Database host (default `127.0.0.1`). |
| `DB_PORT` | Host port mapped to MySQL (default `3306`). |
| `DB_NAME` | Database name (default `LittleLemonDB`). |
| `MYSQL_ROOT_PASSWORD` | Root password used to bootstrap the container. |

## Option A — Docker Compose

One command starts a MySQL 8 container and loads the schema, seed data and programmability
scripts automatically on first start:

```bash
make db-up
```

or directly:

```bash
docker compose up -d
docker compose ps
```

The healthcheck reports `healthy` once MySQL is ready. The init scripts are mounted read-only
from `db/schema`, `db/seed` and `db/programmability`, and only run when the data volume is
empty.

## Option B — local MySQL

Create the database and run the scripts in order from the repository root:

```bash
mysql -u root -p < db/schema/LittleLemonDB-Schema-Script.sql
mysql -u root -p LittleLemonDB < db/seed/littlelemon_dummy_data.sql
mysql -u root -p LittleLemonDB < db/programmability/LittleLemonDB-Programmability.sql
```

Then open [`db/schema/LittleLemonDM.mwb`](../db/schema/LittleLemonDM.mwb) in MySQL Workbench
to inspect or extend the model.

## Script run order

| Order | File | Loads |
|---|---|---|
| 1 | [`db/schema/LittleLemonDB-Schema-Script.sql`](../db/schema/LittleLemonDB-Schema-Script.sql) | Database and seven tables. |
| 2 | [`db/seed/littlelemon_dummy_data.sql`](../db/seed/littlelemon_dummy_data.sql) | Synthetic customers, staff, menu and orders. |
| 3 | [`db/programmability/LittleLemonDB-Programmability.sql`](../db/programmability/LittleLemonDB-Programmability.sql) | Views and stored procedures (idempotent). |

## Make targets

| Target | Runs |
|---|---|
| `make db-up` | `docker compose up -d`, then waits for the healthcheck. |
| `make db-down` | Stops the stack and keeps the data volume. |
| `make db-reset` | `docker compose down -v` then `db-up` — wipes and reseeds. |
| `make health` | `python scripts/littlelemon_cli.py health`. |
| `make summary` | `python scripts/littlelemon_cli.py summary`. |
| `make cli ARGS="…"` | Pass-through to the reporting CLI. |
| `make verify` | Runs the readiness gate (or the portable checks if absent). |
| `make clean` | Removes caches and local exports. |

## Python environment

```bash
python3.12 -m venv .venv
source .venv/bin/activate
pip install -r requirements.txt
bash scripts/verify.sh
```

Pull and then verify. The pinned versions live in
[`requirements.txt`](../requirements.txt); there is no second dependency manifest.

## Related documents

- [Python client](python-client.md) — the notebook and CLI commands.
- [Database design](database-design.md) — the schema these scripts create.
- [Documentation index](README.md) — all docs at a glance.
