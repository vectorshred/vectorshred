#!/bin/bash

# Simple script to change .gnmap output to a clean list of IPs

HEADCOMMAND="head"

# 0 Check for head error (MacOS head can't use negative integers)
TEST=$((echo "test" | $HEADCOMMAND -n -1) 2>&1)

if [ "$TEST" = "head: illegal line count -- -1" ]; then
	HEADCOMMAND="ghead"
	TEST=$(echo "test" | $HEADCOMMAND -n -1 2>&1 |cut -d ":" -f 4 | cut -d " " -f 2)
	if [[ "$TEST" == "command" ]]; then
		echo "GNU coreutils needed, e.g. run 'brew install coreutils'"
		exit 1
	fi
fi

# 1. Check command syntax is correct

if [ "$#" -ne 2 ]; then
	echo "Usage: $0 <gnmap_file>.gnmap <IPfile>.txt"
	exit 1
fi

# 2. Assign variables to arguments
GNMAP_FILE="$1"
IP_FILE="$2"

# 3. Check for existence of gnmap file
if [ ! -f "$GNMAP_FILE" ]; then
	echo "Error: Input gnmap file '$GNMAP_FILE' does not exist."
	exit 1
fi

# 4. This step extracts IP addresses and removes any leading or trailing empty lines.
cat $GNMAP_FILE | cut -d " " -f 2 | sort -u | $HEADCOMMAND -n -1 > $IP_FILE

# 5. Verification
if [ $? -eq 0 ]; then
	echo "IPs successfully output to '$IP_FILE'."
else 
	echo "Error: Operation unsuccessful."
	exit 1
fi
