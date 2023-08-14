# Arazutech: License Checker

This GitHub Action checks the licenses of Python/Node dependencies and sends notifications if restricted licenses are found. It can be configured to use a Slack webhook to send notifications.

## Inputs

runtime (required): Project runtime eg. "node" or "python".\
slack_webhook_url (required): Slack webhook URL for sending notifications.\
allow_list (optional): A regex pattern for allowed licenses.\
block_list (optional): A regex pattern for blocked licenses.


## Example Usage

```yaml
name: Dependency License Check

on:
  push:
    branches: [ main ]
  pull_request:

jobs:
  check-licenses:
    runs-on: ubuntu-latest
    env:
      RUNTIME: 'python'
      SLACK_WEBHOOK_URL: ${{ secrets.SLACK_WEBHOOK_URL }}
      ALLOW_LIST: ${{ vars.REGEX_ALLOW_LIST }}
      BLOCK_LIST: ${{ vars.REGEX_BLOCK_LIST }}
    steps:            
      - name: Python License Check
        uses: arazutech/action-license-compliance@v53
        with:
          runtime: ${{ env.RUNTIME }}
          slack_webhook_url: ${{ env.SLACK_WEBHOOK_URL }}
          allow_list: ${{ env.ALLOW_LIST }}
          block_list: ${{ env.BLOCK_LIST }}
        if: always()
```

## License

This GitHub Action is licensed under the MIT License.
