#!/bin/bash

# Get the directory of the script
SCRIPT_DIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

# Path to the directory containing quote files
QUOTE_DIR=$SCRIPT_DIR/quotes

# Path to the standard fortune database
STANDARD_DATABASE_DIR=~/fortunes

mkdir -p $STANDARD_DATABASE_DIR

STANDARD_DATABASE=$STANDARD_DATABASE_DIR/fortune

# Create temporary directory
TEMP_DIR=$(mktemp -d)

# Concatenate all quote files into a single file
cat "$QUOTE_DIR"/*.quote > $TEMP_DIR/all_quotes

# Combine custom quotes with standard fortune database
cat "$TEMP_DIR/all_quotes" > $STANDARD_DATABASE

# Generate index file for the combined database
strfile $STANDARD_DATABASE

# Cleanup temporary directory
rm -rf $TEMP_DIR

