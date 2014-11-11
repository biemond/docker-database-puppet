# Oracle Database 12.1.0.1 Standard Edition Docker with puppet 3.7 on CentOS 6

it will download minimal CentOS 6, Puppet 3.7 and all it dependencies

Configures Puppet and use librarian-puppet to download all the modules from puppet forge

## Result
- Oracle Database Standard Edition 12.1.0.1, sys/Welcome01
- Tablespace MY_TS
- Role apps
- User TESTUSER

or configure your own weblogic environment by changing the common.yaml and build a new image

## Software
Download the following software from Oracle and Agree to the license
- 12.1.0.1 file 1 & 2

Add them to this docker folder

## Build image
docker build -t oracle/database12101_centos6 .

## Remove image
docker rmi oracle/database12101_centos6

## Start container

default, will start the nodemanager & adminserver
- docker run -i -t -p 1521:1521 oracle/database12101_centos6:latest

with bash

docker run -i -t -p 1521:1521 oracle/database12101_centos6:latest /bin/bash
- service dbora start

## Boot2docker, MAC OSX

VirtualBox forward rules
- VBoxManage controlvm boot2docker-vm natpf1 "database,tcp,,1521,,1521"

Check the ipaddress
- boot2docker ip

