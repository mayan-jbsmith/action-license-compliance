#!/bin/bash

construct_slack_message() {
    local csv_file="$1"
    local dependencies_count="$2"

    echo "{
        \"attachments\": [
            {
                \"blocks\": [
                    {
                        \"type\": \"header\",
                        \"text\": {
                            \"type\": \"plain_text\",
                            \"text\": \":warning:  $repository_name\"
                        }
                    }
                ]
            },
            {
                \"blocks\": [
                    {
                        \"type\": \"context\",
                        \"elements\": [
                            {
                                \"type\": \"mrkdwn\",
                                \"text\": \"*$dependencies_count licenses need to be reviewed*\\n\"
                            }
                        ]
                    },
                    {
                        \"type\": \"divider\"
                    },"

    # Add debugging output to print CSV data
    echo "Debug: Reading CSV data"
    awk -F ',' -v OFS=',' 'NR>1 {gsub(/"/, "", $1); gsub(/"/, "", $2); gsub(/"/, "", $3); print $1, $2, $3}' "$csv_file" | while IFS=',' read -r name license_type dep_url; do
        # Debugging output
        echo "Debug: Processing CSV line: $name, $license_type, $dep_url"

        IFS=';' read -ra licenses <<<"$license_type"
        license_text=$(printf "\\n• %s" "${licenses[@]}")

        echo "                {
                        \"type\": \"section\",
                        \"text\": {
                            \"type\": \"mrkdwn\",
                            \"text\": \" *<$dep_url|$name>*$license_text\"
                        }
                    }"
    done

    echo "            ]
            },
            {
                \"color\": \"#87CEEB\",
                \"blocks\": [
                    {
                        \"type\": \"divider\"
                    },
                    {
                        \"type\": \"section\",
                        \"block_id\": \"section789\",
                        \"fields\": [
                            {
                                \"type\": \"mrkdwn\",
                                \"text\": \"GitHub Action summary: $action_summary_link\"
                            }
                        ]
                    }
                ]
            }
        ]
    }"
}

csv_file="$1"
repository_name="$GITHUB_REPOSITORY"
workflow_run_id="$GITHUB_RUN_ID"
action_summary_link="${GITHUB_SERVER_URL}/${repository_name}/actions/runs/${workflow_run_id}"

if [ -z "$csv_file" ]; then
    echo "Usage: ./csv_to_text.sh <path_to_csv_file>"
    exit 1
fi

if [ ! -f "$csv_file" ]; then
    echo "Error: The specified CSV file does not exist."
    exit 1
fi

dependencies_count=$(($(wc -l <"$csv_file") - 1))

slack_data=$(construct_slack_message "$csv_file" "$dependencies_count")
echo "$slack_data" >slack_message.json
