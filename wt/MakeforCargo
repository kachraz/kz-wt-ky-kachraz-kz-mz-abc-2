SHELL := /bin/bash
.PHONY: run build test doctest clean clippy help

# ANSI color codes
RED := \033[1;31m
GREEN := \033[1;32m
YELLOW := \033[1;33m
BLUE := \033[1;34m
CYAN := \033[1;36m
RESET := \033[0m

# Default target
help: ## Show available commands
	@echo -e "$(CYAN)Available Commands:$(RESET)"
	@grep -E '^[a-zA-Z_-]+:' $(MAKEFILE_LIST) | sed 's/:.*##/:/g' | awk -F ': ' '{printf "  $(GREEN)%-12s$(RESET) %s\n", $$1, $$2}'

run: ## Run the project
	@echo -e "$(GREEN)Running project...$(RESET)"
	@cargo run

build: ## Build the project
	@echo -e "$(YELLOW)Building project...$(RESET)"
	@cargo build --release

test: ## Run unit and integration tests
	@echo -e "$(BLUE)Running tests...$(RESET)"
	@cargo nextest run

doctest: ## Run documentation tests
	@echo -e "$(BLUE)Running documentation tests...$(RESET)"
	@cargo test --doc

clippy: ## Run Clippy (linter) and automatically fix issues
	@echo -e "$(YELLOW)Running Clippy...$(RESET)"
	@cargo clippy --fix --allow-dirty --allow-staged

clean: ## Remove build artifacts
	@echo -e "$(RED)Cleaning up...$(RESET)"
	@cargo clean
