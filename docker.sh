#!bin/bash

create_machine(){
  docker-machine create -d virtualbox docker-dev
}

start_machine(){
  docker-machine start docker-dev
}

stop_machine(){
  docker-machine stop docker-dev
}

vbox_port_forwading(){
  VBoxManage modifyvm "docker-dev" --natpf1 "tcp-port3000,tcp,,3000,,3000";
  VBoxManage modifyvm "docker-dev" --natpf1 "tcp-port5432,tcp,,5432,,5432";
  VBoxManage modifyvm "docker-dev" --natpf1 "tcp-port80,tcp,,80,,80";
}

bind_machine(){
  eval "$(docker-machine env docker-dev)"
}

compose_build(){
  bind_machine
  docker-compose build
}

compose_up(){
  bind_machine
  docker-compose up
}

run_web(){
  bind_machine
  docker-compose run --service-ports web
}

deploy(){
  eval "$(docker-machine env $1)"
  docker-compose run -f docker-compose.yml -f production.yml build
  docker-compose run -f docker-compose.yml -f production.yml up -d
}

usage(){
cat <<EOF
Usage: `basename $0` options (-a) (-c) (-s) (-t) (-b) (-u) (-r) (-d)
-a  create machine, stop machine, vbox port forwading, start machine, bind machine to shell,
    compose build, compose up

-c  create machine
-s  start machine
-t  stop machine
-b  compose build
-u  compose up
-r  run web container
-d machine_name deploy containers to the remote machine.
EOF
}

if (! getopts "acstburd" option); then
  usage
fi

while getopts acstburd: OPTION; do
  case $OPTION in
    a)
      create_machine
      stop_machine
      vbox_port_forwading
      start_machine
      bind_machine
      compose_build
      compose_up
      ;;
    c)
      create_machine
      ;;
    s)
      start_machine
      ;;
    t)
      stop_machine
      ;;
    b)
      compose_build
      ;;
    u)
      compose_up
      ;;
    r)
      run_web
      ;;
    d)
      # echo $OPTARG
      deploy $OPTARG
      ;;
  esac
done
