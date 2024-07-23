# JAJCE

### Provision Dokku aoplications via Ansible

This project provides a comprehensive Ansible playbook designed to simplify the process of setting up and managing applications on a Dokku server. Dokku is a self-hosted PaaS (Platform as a Service) that helps you deploy and manage applications using Docker containers. This playbook automates the following key tasks:

- **Creation and Configuration of Dokku Applications**: Automates the creation of new applications on your Dokku server, ensuring that all necessary configurations are applied.
- **Setup of Postgres Databases**: Ensures that a Postgres database is created for each application and links the database to the application, facilitating easy and secure data storage.
- **Enabling Let's Encrypt for HTTPS**: Automates the setup of Let's Encrypt to provide HTTPS for your applications, enhancing security by encrypting the data exchanged between the server and clients.
- **Creation of GitHub Actions Workflow**: Automatically generates a GitHub Actions workflow file for continuous deployment, enabling automatic deployments to your Dokku server whenever changes are pushed to the main branch of your repository.

## TLDR

Yes but how do I run it?

Firsty clone the repository, then set up as follows.

1) Install and setup ansible

```bash
make ansible
```

2) Make sure ssh connectivity to your dokku server is in place. The hosts.ini just has dokku. This can modified directly if a different hostname is preferrec, or details can just be added to ~/.ssh.config

```bash
Host dokku
  User dokku
  Hostname example.com
  IdentityFile ~/.ssh/example.com/dokku_rsa
```

3) Add email and domain

An example file is included in group_vars/all/example.yml. Copy to group_vars/all/vars.yml and replace with your domain and email. The email is used for letsencrypt.

 Now we should be able to create our first dokku deployment

```bash
make create
```

This will prompt fot the name of the new deployment.

## RESULT

If the playbook is executed succesfully, a new project will be initialized on the dokku server, and a useable github action will be created in dist, an example is included here below

```yml
name: "dokku"

on:
  push:
    branches:
      - main

jobs:
  deploy:
    runs-on: ubuntu-22.04
    steps:
      - name: Cloning repo
        uses: actions/checkout@v4
        with:
          fetch-depth: 0

      - name: Push to dokku
        uses: dokku/github-action@master
        with:
          branch: "main"
          git_remote_url: "ssh://dokku@example.com/~/austin"
          ssh_private_key: ${{ secrets.SSH_PRIVATE_KEY }}
```

## ALIAS

While the dokku provisioner can be run from inside the repo with `make create`, its preferable to setup a bash/zsh function which means the provisioner can be run from anywhere on your computer - ideally within your repo. When run from your repo, the dokku deploy workflow will be created in `.github/workflows/deploy.yml`. This means your add will already have the workflow setup and ready to deploy to the newly provisioned dokku instance.

An alias can be set up something like this

```bash
dokku () {
  local dokkuloc=$HOME/jajce
  make -f $dokkuloc/Makefile $1 -C $dokkuloc CURDIR=$(pwd)
}
```
