# Configuration
BACKEND_DIR := src/backend
UV := $(shell which uv)

# Phony targets (targets that don't represent files)
.PHONY: help all install dev test test-cov test-tox lint format type-check check clean run

# Default target
.DEFAULT_GOAL := help

# Show all available commands
all: help

help:
	@echo "Backend Development Commands:"
	@echo "  install dev test test-cov test-tox"
	@echo "  lint format type-check check clean run"
	@echo ""
	@echo "Run 'make <target>' for details"

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
