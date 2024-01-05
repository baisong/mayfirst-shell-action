# mayfirst-shell-action
GitHub action to connect to May First shell

Adaptation of [this original bash script by co-op member Jamie McClelland](https://help.mayfirst.org/en/guide/how-to-automate-ssh-access) to work with GitHub actions.

This script was designed to work with [May First's 2023 infrastructure upgrade](https://help.mayfirst.org/en/guide/how-to-tell-if-using-new-infrastructure), and to run immediately before the [`nogsantos/ssh-scp-deploy`](https://github.com/nogsantos/ssh-scp-deploy) SSH/SCP deploy action.

## Example implementation

Add the below to a file at `.github-workflows/main.yml` in your repository, replace the variables for your purpose, and be sure to add the correct secrets in your repository settings:

- `SSH_USER`: your May First username
- `SSH_HOST`: shell.mayfirst.org
- `SSH_PORT`: 22
- `SSH_DIR`: the target (your web configuration root folder's complete filepath)
- `SSH_KEY`: your private key
- `PASSWORD`: your SSH user's password, as a fallback authenticatoin method (SSH key recommended)

...and lastly, be sure to replace the `src` property in the `nogsantos/ssh-scp-deploy` step with the actual static site build directory. The inital use case for this script is a SvelteKit application using the static adapter, so the common static build directory name `./build/*` is listed as the example.

```yaml
name: Build and deploy static site to May First server

on:
  push:
    branches:
      - master
  workflow_dispatch:
    inputs:
      deploy_comment:
        description: "Deploy comment"
        required: true
jobs:
  build:
    runs-on: ubuntu-latest
    name: Build and Deploy
    env:
      EXAMPLE_CONFIDENTIAL_ENV_VARIABLE: ${{secrets.EXAMPLE_CONFIDENTIAL_ENV_VARIABLE}}

    steps:
      - uses: actions/checkout@master

      - name: Bucket actions
        uses: actions/setup-node@v4
        with:
          node-version: 18
      - run: npm i
      - run: npm run build
        
      - name: connect to may first shell
        uses: baisong/mayfirst-shell-action@v0.1.0
        with:
          comment: ${{ inputs.deploy_comment }}
          user: ${{ secrets.SSH_USER }}
          password: ${{ secrets.PASSWORD }}

      - name: Publish
        uses: nogsantos/ssh-scp-deploy@v1.3.0
        with:
          src: ./build/*
          host: ${{ secrets.SSH_HOST }}
          remote: ${{ secrets.SSH_DIR }}
          port: ${{ secrets.SSH_PORT }}
          user: ${{ secrets.SSH_USER }}
          key: ${{ secrets.SSH_KEY }}
```
