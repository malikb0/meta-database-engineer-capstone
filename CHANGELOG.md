# Changelog

All notable changes to this project are documented here. The format is based on
[Keep a Changelog](https://keepachangelog.com/en/1.1.0/), and this project adheres to
[Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

### Added

- `docs/` documentation suite: index, database design, queries and procedures,
  visualization, Python client, and setup.
- `Makefile`, `requirements.txt`, `pyproject.toml`, `.editorconfig`, `CITATION.cff`,
  `CONTRIBUTING.md`, `CHANGELOG.md`, and a GitHub Actions CI workflow.
- Portable link and readiness checks (`scripts/check_links.py`, `scripts/verify.sh`).

### Changed

- Reorganised the repository into a functional layout (`db/`, `queries/`, `clients/`,
  `scripts/`, `docs/`) using `git mv` so history is preserved.
- Updated `docker-compose.yml` volume paths to the new script locations.
- Rewrote `README.md` as a documentation hub with badges, an at-a-glance table, a
  documentation map, and Mermaid diagrams.

### Removed

- `Pipfile` and `Pipfile.lock`; dependencies now come from a single pinned
  `requirements.txt`.

## [1.0.0]

### Added

- Normalised MySQL 8 schema, analytical SQL, stored procedures and transactions.
- Interactive Tableau dashboard and a Jupyter `mysql-connector-python` client.
- Reporting CLI (`scripts/littlelemon_cli.py`), `docker-compose.yml`, `LICENSE`, and
  `NOTICE.md`.

### Security

- Moved database credentials to a git-ignored `.env` with a committed `.env.example`.
