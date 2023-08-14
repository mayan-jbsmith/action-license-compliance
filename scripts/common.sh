#!/bin/bash

function process_licenses() {
    INPUT_FILE="$1"
    ALLOW_LIST="$2"
    BLOCK_LIST="$3"

    if [ $# -ne 3 ]; then
        echo "Usage: $0 <licenses.csv> <allow_list> <block_list>"
        exit 1
    fi

    FAIL_COUNTER=0
    TOTAL_COUNTER=0

    {
        while IFS=',' read -r line; do
            TOTAL_COUNTER=$((TOTAL_COUNTER + 1))

            if ! [[ ${line} =~ $ALLOW_LIST ]] || [[ ${line} =~ $BLOCK_LIST ]]; then
                echo $line >>invalid.csv
                if ! [[ ${line} =~ "Name" ]]; then
                    FAIL_COUNTER=$((FAIL_COUNTER + 1))
                    echo "<tr><td>$FAIL_COUNTER</td><td>:red_circle:</td><td><a href=\"$(echo "$line" | awk -F '\"' '{print $6}')\" target=\"_blank\">$(echo "$line" | awk -F '\"' '{print $2}')</a></td><td>$(echo "$line" | awk -F '\"' '{print $4}')</td></tr>"
                fi
            fi
        done < <(sed 1d "$INPUT_FILE")
    } >>"$GITHUB_STEP_SUMMARY"

    if (($FAIL_COUNTER > 0)); then
        echo -e "\n<h4>$FAIL_COUNTER / $TOTAL_COUNTER licenses need to be researched.</h4>\n"
        echo "::error::Some licenses need to be reviewed" && exit 1
    fi
}
