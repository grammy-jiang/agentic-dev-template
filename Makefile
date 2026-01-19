# Configuration
BACKEND_DIR := src/backend
FRONTEND_DIR := src/frontend
UV := $(shell which uv)

# Phony targets (targets that don't represent files)
.PHONY: help all install dev test test-cov test-tox lint format type-check check clean run frontend-install frontend-dev frontend-build frontend-lint frontend-format frontend-test

# Default target
.DEFAULT_GOAL := help

# Show all available commands
all: help

help:
	@echo "Backend: install dev test test-cov test-tox lint format type-check check clean run"
	@echo "Frontend: frontend-install frontend-dev frontend-build frontend-lint frontend-format frontend-test"

# Install production dependencies
install:
	cd $(BACKEND_DIR) && $(UV) sync --frozen

# Install development dependencies
dev:
	cd $(BACKEND_DIR) && $(UV) sync --frozen --all-extras

# Run tests
test:
	cd $(BACKEND_DIR) && $(UV) run pytest tests/

# Run tests with coverage
test-cov:
	cd $(BACKEND_DIR) && $(UV) run pytest tests/ --cov=. --cov-report=html --cov-report=term

# Run tests via tox (all environments)
test-tox:
	cd $(BACKEND_DIR) && $(UV) run tox

# Run linter
lint:
	cd $(BACKEND_DIR) && $(UV) run ruff check .

# Format code
format:
	cd $(BACKEND_DIR) && $(UV) run ruff format .
	cd $(BACKEND_DIR) && $(UV) run ruff check --fix .

# Type checking
type-check:
	cd $(BACKEND_DIR) && $(UV) run mypy .

# Run all checks
check: lint type-check test

# Clean cache and build artifacts
clean:
	@find . -type d \( -name "__pycache__" -o -name ".pytest_cache" -o -name ".mypy_cache" -o -name ".ruff_cache" -o -name "htmlcov" \) -exec rm -rf {} + 2>/dev/null || true

# Run the backend application
run:
	cd $(BACKEND_DIR) && $(UV) run python -m app.main

# Frontend targets
frontend-install:
	cd $(FRONTEND_DIR) && npm install

frontend-dev:
	cd $(FRONTEND_DIR) && npm run dev

frontend-build:
	cd $(FRONTEND_DIR) && npm run build

frontend-lint:
	cd $(FRONTEND_DIR) && npm run lint

frontend-format:
	cd $(FRONTEND_DIR) && npm run format

frontend-test:
	cd $(FRONTEND_DIR) && npm run test
