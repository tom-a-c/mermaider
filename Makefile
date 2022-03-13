SHELL=/bin/bash

.PHONY: clean
clean:
	scripts/clean.sh

.PHONY: install
install:
	poetry install
	poetry run pre-commit install

.PHONY: lint
lint:
	poetry run isort mermaider tests/
	poetry run black mermaider tests/
	poetry run mypy
	poetry run prospector

.PHONY: stest
stest: ## run tests locally without pytest output capture
	PYTHONPATH=mermaider poetry run pytest -s tests

.PHONY: test
test:
	PYTHONPATH=mermaider poetry run pytest \
	--cov=mermaider \
	--cov-report=html:cov_html \
	tests/

.PHONY: build
build: clean install test

.PHONY: freeze
freeze:
	poetry export -f requirements.txt --without-hashes --output requirements.txt

.PHONY: ci-clean
ci-clean:
	rm -rf venv

.PHONY: ci-setup
ci-setup:
	pip install poetry
	poetry config --local virtualenvs.in-project true

.PHONY: ci-install
ci-install: ci-setup
	poetry install

.PHONY: ci-lint
ci-lint: ci-setup
	poetry run black --check mermaider
	poetry run mypy
	poetry run prospector

.PHONY: ci-test
ci-test: ci-setup
	PYTHONPATH=mermaider poetry run pytest --fulltrace \
	--html=coverage/reports/report.xml \
	--self-contained-html \
	--cov=mermaider
	--cov-report term-missing \
	--cov-report=xml:coverage/coverage.xml \
	--cov-report=html:coverage/html \
	--junitxml=coverage/junit.xml \
	tests

.PHONY: ci
ci:	ci-clean ci-setup ci-install ci-lint ci-test
