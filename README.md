# postgresql-from-source

## Description
Dockerfile that builds PostgreSQL from source code on specific commit or branch

## Usage example
```bash
docker build --tag=postgresql:11-beta3 --build-arg BRANCH=REL_11_BETA3 .
```