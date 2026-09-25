# Contributing

Thanks for your interest in this portfolio project. It is primarily an educational
demonstration, but corrections and improvements are welcome.

## Repository layout

| Path | Contents |
|---|---|
| `db/schema/` | Forward-engineered schema, Workbench model, ER screenshots. |
| `db/seed/` | Synthetic seed data. |
| `db/programmability/` | Canonical views and stored procedures. |
| `queries/` | Step-by-step SQL exercise scripts and result screenshots. |
| `clients/python/` | Jupyter notebook and screenshots. |
| `clients/tableau/` | Tableau workbook, Excel export and screenshots. |
| `scripts/` | Reporting CLI and verification helpers. |
| `docs/` | Documentation suite. |

## Conventions

- Python: 4-space indentation, line length 100, `ruff`-clean (see `pyproject.toml`).
- SQL: keep the existing style and file numbering.
- Files use LF line endings and UTF-8 (see `.editorconfig` and `.gitattributes`).
- No secrets: configuration belongs in `.env`, never in tracked files.

## Please do not rewrite the working SQL or procedures

The SQL scripts, stored procedures, notebook and CLI behaviour are verified and should not be
rewritten for style alone. Documentation, structure and tests are the welcome surface for
changes.

## Before opening a pull request

1. Copy `.env.example` to `.env` and start the database (`make db-up`).
2. Run `bash scripts/verify.sh` and make sure it reports zero failures.
3. Keep commits focused and describe what changed and why.

## Security

If you spot a credential in the repository or its history, do **not** open a public issue.
Report it privately to the maintainer, and rotate the affected credential.
