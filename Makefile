# Little Lemon DB — common developer tasks.
# Requires Docker Compose v2+ and Python 3.12 (see docs/setup.md).

PYTHON  ?= python3
COMPOSE ?= docker compose

.PHONY: help db-up db-down db-reset health summary cli verify clean

help:
	@echo "Little Lemon DB targets:"
	@echo "  db-up     start MySQL and wait for the healthcheck"
	@echo "  db-down   stop the stack, keep the data volume"
	@echo "  db-reset  recreate the stack from scratch (wipes data)"
	@echo "  health    connectivity and row counts"
	@echo "  summary   headline business metrics"
	@echo "  cli       pass-through: make cli ARGS=\"cuisines\""
	@echo "  verify    run the readiness checks"
	@echo "  clean     remove caches and local exports"

db-up:
	$(COMPOSE) up -d
	@echo "Waiting for MySQL to become healthy..."
	@for i in $$(seq 1 30); do \
		status=$$($(COMPOSE) ps --format '{{.Health}}' db 2>/dev/null | head -1); \
		if [ "$$status" = "healthy" ]; then echo "MySQL is healthy."; exit 0; fi; \
		sleep 2; \
	done; \
	echo "Timed out waiting for the MySQL healthcheck."; exit 1

db-down:
	$(COMPOSE) down

db-reset:
	$(COMPOSE) down -v
	$(MAKE) db-up

health:
	$(PYTHON) scripts/littlelemon_cli.py health

summary:
	$(PYTHON) scripts/littlelemon_cli.py summary

cli:
	$(PYTHON) scripts/littlelemon_cli.py $(ARGS)

verify:
	@if [ -f .orchestrator/scripts/verify-readiness.sh ]; then \
		bash .orchestrator/scripts/verify-readiness.sh; \
	else \
		bash scripts/verify.sh; \
	fi

clean:
	rm -rf exports/ __pycache__ scripts/__pycache__
