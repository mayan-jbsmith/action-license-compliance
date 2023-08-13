#!/bin/bash

source slack_message_builder.sh

csv_file="$1"
repository_name="$GITHUB_REPOSITORY"
workflow_run_id="$GITHUB_RUN_ID"
action_summary_link="${GITHUB_SERVER_URL}/${repository_name}/actions/runs/${workflow_run_id}"
dependencies_count=$(($(cat "$1" | wc -l) - 0))

if [ -z "$csv_file" ]; then
    echo "Usage: ./csv_to_text.sh <path_to_csv_file>"
    exit 1
fi

if [ ! -f "$csv_file" ]; then
    echo "Error: The specified CSV file does not exist."
    exit 1
fi

slack_data=$(construct_slack_message "$csv_file" "$dependencies_count")
echo "$slack_data" >slack_message.json
