# dockerizing_rails_app
Files to dockerizing a rails app, for development and production. It use puma as rails web server. The rails app contains:
- Development: web and db(postgresql) container
- Production:  web, db(postgresql), reverse proxy(nginx) and postgresql backups containers. Backups are stored in S3 and performed daily at 3am.

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

Create docker machine in virtualbox:
```
docker-machine create --driver virtualbox docker-dev
```
Stop machine add port forwading to Virtualbox and start machine again
```
docker-machine stop docker-dev
VBoxManage modifyvm "docker-dev" --natpf1 "tcp-port3000,tcp,,3000,,3000";
VBoxManage modifyvm "docker-dev" --natpf1 "tcp-port5432,tcp,,5432,,5432";
docker-machine start docker-dev
```
Bind machine to the actual shell
```
eval "$(docker-machine env docker-dev)"
```
Build the containers
```
docker-compose build
```
Run the web container
```
docker-compose run --service-ports web
```
The --service-ports option permits to use rails debuggers as byebug or pry.
Migrate database
```
docker-compose run web rake db:migrate
```

## Production

### Amazon EC2 
#### (First deploy)
Create ec2 machine
```
docker-machine create --driver amazonec2 --amazonec2-access-key "your_access_key" --amazonec2-secret-key "your_secret_key" --amazonec2-region eu-west-1 aws-sandbox
```
- aws-sandbox: in the name of the machine, replace it for the name that you need.
- --amazonec2-region eu-west-1: Specify your region.
Build containers
```
docker-compose -f docker-compose.yml -f production.yml build
```
Run containers
```
docker-compose -f docker-compose.yml -f production.yml up -d
```
Migrate database
```
docker-compose -f docker-compose.yml -f production.yml run web rake db:migrate
```

#### Deploy changes
```
docker-compose -f docker-compose.yml -f production.yml buld web
docker-compose up --no-deps -d web
```
