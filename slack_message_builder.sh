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

    awk -F ',' -v OFS=',' 'NR>1 {gsub(/"/, "", $1); gsub(/"/, "", $2); gsub(/"/, "", $3); print $1, $2, $3}' "$csv_file" | while IFS=',' read -r name license_type dep_url; do
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
