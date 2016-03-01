# dockerizing_rails_app
Files to dockerizing a rails app, for development and production. It use puma as rails web server. The rails app contains:
- Development: web and db(postgresql) container
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

### Run containers manually:
1. Create docker machine in virtualbox:
```
docker-machine create --driver virtualbox docker-dev
```
2. Bind machine to the actual shell
```
eval "$(docker-machine env docker-dev)"
```
3. Build the containers
```
docker-compose build
```
4. Run the web container
```
docker-compose run --service-ports web
```
The --service-ports option permits to use rails debuggers as byebug or pry.

## Production

