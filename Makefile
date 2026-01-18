.PHONY: help all install dev test lint format type-check check clean run

# Default target: show all commands
all: help

# Show available commands
help:
	@echo "make install      - Install dependencies"
	@echo "make dev          - Install dev dependencies"
	@echo "make test         - Run tests"
	@echo "make check        - Run all checks"
	@echo "make clean        - Remove cache files"

# Install production dependencies
install:
	cd src/backend && uv sync --frozen

# Install development dependencies
dev:
	cd src/backend && uv sync --frozen --all-extras

# Run tests
test:
	cd src/backend && uv run pytest tests/

# Run tests with coverage
test-cov:
	cd src/backend && uv run pytest tests/ --cov=. --cov-report=html --cov-report=term

# Run linter
lint:
	cd src/backend && uv run ruff check .

# Format code
format:
	cd src/backend && uv run ruff format .
	cd src/backend && uv run ruff check --fix .

# Type checking
type-check:
	cd src/backend && uv run mypy .

# Run all checks
check: lint type-check test

# Clean cache and build artifacts
clean:
	find . -type d -name "__pycache__" -exec rm -rf {} + 2>/dev/null || true
	find . -type d -name ".pytest_cache" -exec rm -rf {} + 2>/dev/null || true
	find . -type d -name ".mypy_cache" -exec rm -rf {} + 2>/dev/null || true
	find . -type d -name ".ruff_cache" -exec rm -rf {} + 2>/dev/null || true
	find . -type d -name "htmlcov" -exec rm -rf {} + 2>/dev/null || true

# Run the backend application
run:
	cd src/backend && uv run python -m app.main
