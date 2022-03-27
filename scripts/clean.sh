#!/usr/bin/env bash
set -e

rm -rf .cache .pytest_cache coverage .coverage src/build src/vendor src/local.py

# Clean up any poetry environments
if [[ -n $(eval poetry env list) ]]
  then
    echo "Removing previously installed poetry envs for this project"
    poetry env remove python
fi