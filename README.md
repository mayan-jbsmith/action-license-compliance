# Arazutech: License Checker

The Arazutech License Compliance Checker GitHub Action helps you maintain license compliance by verifying the licenses of Python/Node dependencies in your projects. It automatically scans your dependencies and sends notifications if restricted licenses are detected. You can configure it to utilize a Slack webhook for sending notifications.

## Inputs

- runtime (required): Specify the project runtime, e.g., "node" or "python".
- slack_webhook_url (required): Provide the Slack webhook URL for notifications.
- allow_list (optional): Define a regex pattern for allowed licenses.
- block_list (optional): Set a regex pattern for blocked licenses.


## Example Usage

Ensure your repository contains the necessary secrets and variables before configuring the GitHub Action. Modify your workflow YAML file as follows:

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
This example workflow sets up the Arazutech License Compliance Checker GitHub Action to run on push events to the main branch and on pull requests. Ensure that the necessary secrets and variables (SLACK_WEBHOOK_URL, REGEX_ALLOW_LIST, and REGEX_BLOCK_LIST) are properly configured in your repository settings.

## License

This GitHub Action is licensed under the MIT License.
