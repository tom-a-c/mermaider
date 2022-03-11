#!/usr/bin/env bash

set -e
poetry export -f requirements.txt --without-hashes --output requirements.txt
git add requirements.txt

