#!/bin/bash

#####################################
# Python Code Quality Checking Script
# Integrated with pylint and flake8 for ensuring consistent style, 
# adherence to best practices, and improving code quality.
#
# Created by: Yogesh Maithania
# 
# This script automates the process of running pylint and flake8 to:
# - Check for code smells, unused imports, and PEP8 violations
# - Enforce quality and readability standards
# - Output formatted results to improve debugging and refinement
#
# Requirements:
# pylint 2.4.4
# astroid 2.3.3
# Python 3.6.0 (default, July 3 2023, 01:29:30)
# flake8 3.7.9 (mccabe: 0.6.1, pycodestyle: 2.5.0, pyflakes: 2.1.1)
#####################################

set -e
# Stop script execution if any command fails

if [ $# -eq 0 ]; then
    echo "No directory supplied. Usage: bash $0 <directory_or_file>"
    exit 1
fi

ENFORCED_FILES="$1"

# Define your custom linting preferences
MAX_LINE_LEN="--max-line-length=120"   # Enforces line length of 120 characters
PYLINT_DISABLED_WARNINGS="--disable=R0914,E0401,F401,C0121,R0801,E712,W504"  # Disable specific rules

# Function to handle linting failures
handle_failure() {
    echo -e "\n\n***** Linting failed! Please fix the issues above. *****"
    exit 1
}

echo "Running pylint with custom settings..."
pylint $PYLINT_DISABLED_WARNINGS $MAX_LINE_LEN --msg-template='{abspath}:{line:3d}: {obj}: {msg_id}:{msg}' $ENFORCED_FILES || handle_failure

echo -e "\n\nRunning flake8 with custom settings..."
flake8 --max-complexity 12 --benchmark $MAX_LINE_LEN --ignore=R0914,E712,W504 $ENFORCED_FILES || handle_failure

echo -e "\n\n***** Good work! All lints passed successfully. *****"
exit 0

# For CI/CD pipelines:
# - Install dependencies as part of the pipeline setup to ensure required versions of pylint and flake8 are present
# - Use this script as a part of the pre-build or pre-deployment steps in CI/CD to enforce code quality before the pipeline continues
# - Make sure to collect and display linting logs from this script for better reporting in CI tools like Jenkins or GitLab CI
