#!/bin/bash

source step_summary_format.sh

INPUT_FILE="$1"
ALLOW_LIST="$2"
BLOCK_LIST="$3"

process_licenses "$INPUT_FILE" "$ALLOW_LIST" "$BLOCK_LIST"

{
    LICENSE_COUNTER=0
    echo "<table>"
    echo "<th>#</th> <th>Status</th> <th>Name</th> <th>License Type</th>"
} >>"$GITHUB_STEP_SUMMARY"

# Generate the license table
sed 1d "$INPUT_FILE" | while IFS=',' read -r line; do
    ICON=":green_circle:"
    if ! [[ ${line} =~ $ALLOW_LIST ]] || [[ ${line} =~ $BLOCK_LIST ]]; then
        ICON=":red_circle:"
    fi
    if ! [[ ${line} =~ "Name" ]]; then
        LICENSE_COUNTER=$((LICENSE_COUNTER + 1))
        echo "<tr>" "<td>$LICENSE_COUNTER</td>" "<td>$ICON</td>" "<td><a href=\"$(echo "$line" | awk -F '\"' '{print $6}')\" target=\"_blank\">$(echo "$line" | awk -F '\"' '{print $2}')</a></td>" "<td>$(echo "$line" | awk -F '\"' '{print $4}')</td>" "</tr>" >>"$GITHUB_STEP_SUMMARY"
    fi
done

echo "</table>" >>"$GITHUB_STEP_SUMMARY"
