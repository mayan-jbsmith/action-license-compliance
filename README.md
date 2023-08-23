# Arazutech: License Checker

The Arazutech License Compliance Checker GitHub Action helps you maintain license compliance by verifying the licenses of Python/Node dependencies in your projects. It automatically scans your dependencies and outputs to the GitHub Action step summary 

## Inputs
- runtime (required): Specify the project runtime, e.g., "node" or "python".
- allow_list (optional): Define a regex pattern for allowed licenses.
- block_list (optional): Set a regex pattern for blocked licenses.
- show_all (optional): Choose whether to show all licenses, both valid and invalid. ['true', 'false']


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
      ALLOW_LIST: ${{ vars.REGEX_ALLOW_LIST }}
      BLOCK_LIST: ${{ vars.REGEX_BLOCK_LIST }}
    steps:            
      - name: Python License Check
        uses: arazutech/action-license-compliance@v53
        with:
          runtime: ${{ env.RUNTIME }}
          allow_list: ${{ env.ALLOW_LIST }}
          block_list: ${{ env.BLOCK_LIST }}
          show_all: 'true'
        if: always()
```
This example workflow sets up the Arazutech License Compliance Checker GitHub Action to run on push events to the main branch and on pull requests. Ensure that the necessary secrets and variables (REGEX_ALLOW_LIST, and REGEX_BLOCK_LIST) are properly configured in your repository settings.

## License

This GitHub Action is licensed under the MIT License.
