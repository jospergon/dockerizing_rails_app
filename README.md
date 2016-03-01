# dockerizing_rails_app
Files to dockerizing a rails app, for development and production. It use puma as rails web server. The rails app contains:
- Development: web and **db(postgresql)** container
- Production:  web, db, reverse proxy(nginx) and postgresql backups containers. Backups are stored in S3.

# Usage
Copy these files into your rails app directory:
* Dockerfile
* docker-compose.yml
* production.yml
* docker.sh

Copy the directory **puma/** inside your rails **app/config** directory.

## Development
### Run containers automatically:
Run de script:
```
docker.sh -a
```
This script create a virtual machine in Virtualbox with docker installed, foward the ports 3000(puma), 5432(postgresql) with the host machine,
bind the docker machine to the actual shell and run the docker containers for development(web and db containers).

## Production

