#!/usr/bin/env python3
"""Little Lemon DB command-line reporting tool.

A small automation layer over the Little Lemon database. It connects through a
connection pool, runs parameterised read-only queries and can export results to
CSV.

Usage
-----
    python scripts/littlelemon_cli.py health
    python scripts/littlelemon_cli.py summary
    python scripts/littlelemon_cli.py cuisines
    python scripts/littlelemon_cli.py customers --min-total 60 --csv exports/customers.csv
    python scripts/littlelemon_cli.py check --date 2022-11-12 --table 3

Configuration is read from environment variables (.env is supported).
"""
from __future__ import annotations

import argparse
import csv
import os
import sys
from pathlib import Path

try:
    import mysql.connector as connector
    from mysql.connector import Error
    from mysql.connector.pooling import MySQLConnectionPool
except ImportError:  # pragma: no cover
    sys.exit("mysql-connector-python is required: pipenv install")


def load_env() -> None:
    """Populate os.environ from a .env file (python-dotenv optional)."""
    try:
        from dotenv import load_dotenv

        load_dotenv()
        return
    except ImportError:
        pass

    for candidate in (Path.cwd() / ".env", Path(__file__).resolve().parent.parent / ".env"):
        if candidate.exists():
            for line in candidate.read_text().splitlines():
                line = line.strip()
                if line and not line.startswith("#") and "=" in line:
                    key, value = line.split("=", 1)
                    os.environ.setdefault(key.strip(), value.strip())
            return


def db_config() -> dict:
    cfg = {
        "user": os.getenv("DB_USER"),
        "password": os.getenv("DB_PASSWORD"),
        "host": os.getenv("DB_HOST", "127.0.0.1"),
        "port": int(os.getenv("DB_PORT", "3306")),
        "database": os.getenv("DB_NAME", "LittleLemonDB"),
        "auth_plugin": "mysql_native_password",
    }
    if not cfg["user"] or not cfg["password"]:
        sys.exit("Missing DB credentials. Copy .env.example to .env and fill it in.")
    return cfg


def get_connection():
    try:
        pool = MySQLConnectionPool(pool_name="ll_cli_pool", pool_size=2, **db_config())
        return pool.get_connection()
    except Error as err:
        sys.exit(f"Could not connect to MySQL: {err.msg}")


def query(sql: str, params: tuple = ()) -> tuple[list[str], list[tuple]]:
    connection = get_connection()
    try:
        cursor = connection.cursor()
        cursor.execute(sql, params)
        rows = cursor.fetchall()
        columns = [d[0] for d in cursor.description] if cursor.description else []
        return columns, rows
    finally:
        connection.close()


def print_table(columns: list[str], rows: list[tuple], limit: int | None = None) -> None:
    if not rows:
        print("(no rows)")
        return
    shown = rows if limit is None else rows[:limit]
    widths = [len(c) for c in columns]
    for row in shown:
        for i, value in enumerate(row):
            widths[i] = max(widths[i], len(str(value)))
    fmt = "  ".join(f"{{:<{w}}}" for w in widths)
    print(fmt.format(*columns))
    print(fmt.format(*["-" * w for w in widths]))
    for row in shown:
        print(fmt.format(*[str(v) for v in row]))
    if limit is not None and len(rows) > limit:
        print(f"... {len(rows) - limit} more row(s)")


def write_csv(path: str, columns: list[str], rows: list[tuple]) -> None:
    out = Path(path)
    out.parent.mkdir(parents=True, exist_ok=True)
    with out.open("w", newline="", encoding="utf-8") as handle:
        writer = csv.writer(handle)
        writer.writerow(columns)
        writer.writerows(rows)
    print(f"Wrote {len(rows)} row(s) to {out}")


def cmd_health(args: argparse.Namespace) -> None:
    checks = [
        ("customers", "SELECT COUNT(*) FROM customers"),
        ("orders", "SELECT COUNT(*) FROM orders"),
        ("bookings", "SELECT COUNT(*) FROM bookings"),
        ("menu", "SELECT COUNT(*) FROM menu"),
        ("staff", "SELECT COUNT(*) FROM staff"),
    ]
    print(f"Connected to '{db_config()['database']}' at {db_config()['host']}:{db_config()['port']}\n")
    print(f"{'table':<12}{'rows':>8}")
    print("-" * 20)
    for name, sql in checks:
        _, rows = query(sql)
        print(f"{name:<12}{rows[0][0]:>8}")


def cmd_summary(args: argparse.Namespace) -> None:
    sql = """
        SELECT
            COUNT(*)                        AS orders,
            ROUND(SUM(total_cost), 2)       AS revenue,
            ROUND(AVG(total_cost), 2)       AS avg_order_value,
            MAX(quantity)                   AS max_quantity
        FROM orders
    """
    columns, rows = query(sql)
    print("Business summary")
    print("----------------")
    for column, value in zip(columns, rows[0]):
        print(f"{column:<18}: {value}")


def cmd_cuisines(args: argparse.Namespace) -> None:
    sql = """
        SELECT
            m.cuisine                       AS cuisine,
            COUNT(o.order_id)               AS orders,
            ROUND(SUM(o.total_cost), 2)     AS revenue
        FROM orders AS o
        JOIN menu AS m ON o.menu_id = m.menu_id
        GROUP BY m.cuisine
        ORDER BY revenue DESC
    """
    columns, rows = query(sql)
    print_table(columns, rows)


def cmd_customers(args: argparse.Namespace) -> None:
    sql = """
        SELECT
            c.customer_id                   AS customer_id,
            c.full_name                     AS full_name,
            c.contact_numbers               AS contact_numbers,
            c.email                         AS email,
            ROUND(SUM(o.total_cost), 2)     AS total_spend
        FROM customers AS c
        JOIN orders AS o ON c.customer_id = o.customer_id
        GROUP BY c.customer_id, c.full_name, c.contact_numbers, c.email
        HAVING total_spend > %s
        ORDER BY total_spend DESC
    """
    columns, rows = query(sql, (args.min_total,))
    if args.csv:
        write_csv(args.csv, columns, rows)
    else:
        print_table(columns, rows, limit=args.limit)


def cmd_check(args: argparse.Namespace) -> None:
    sql = """
        SELECT COUNT(*) FROM bookings
        WHERE booking_date = %s AND table_number = %s
    """
    sql_cols, rows = query(sql, (args.date, args.table))
    booked = rows[0][0] > 0
    status = "already booked" if booked else "available"
    print(f"Table {args.table} on {args.date} is {status}.")


def build_parser() -> argparse.ArgumentParser:
    parser = argparse.ArgumentParser(description="Little Lemon DB reporting CLI")
    sub = parser.add_subparsers(dest="command", required=True)

    sub.add_parser("health", help="show database connectivity and row counts").set_defaults(func=cmd_health)
    sub.add_parser("summary", help="show headline business metrics").set_defaults(func=cmd_summary)
    sub.add_parser("cuisines", help="revenue by cuisine").set_defaults(func=cmd_cuisines)

    customers = sub.add_parser("customers", help="customers above a spend threshold")
    customers.add_argument("--min-total", type=float, default=60.0)
    customers.add_argument("--limit", type=int, default=20)
    customers.add_argument("--csv", help="export to this CSV path instead of printing")
    customers.set_defaults(func=cmd_customers)

    check = sub.add_parser("check", help="check whether a table is booked")
    check.add_argument("--date", required=True, help="booking date (YYYY-MM-DD)")
    check.add_argument("--table", required=True, type=int, help="table number")
    check.set_defaults(func=cmd_check)

    return parser


def main() -> None:
    load_env()
    parser = build_parser()
    args = parser.parse_args()
    args.func(args)


if __name__ == "__main__":
    main()
