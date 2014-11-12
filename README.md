# Oracle Database 12.1.0.1 ( 12c ) Standard Edition Docker with puppet 3.7 on CentOS 6

it will download minimal CentOS 6, Puppet 3.7 and all it dependencies

Docker image will be big and off course not supported by Oracle and like always check your license to use this software

Configures Puppet and use librarian-puppet to download all the modules from puppet forge

## Result
- Oracle Database Standard Edition 12.1.0.1, servicename orcl.example.com username sys/Welcome01
- Tablespace MY_TS
- Role apps
- User TESTUSER

or configure your own specific database environment by changing the site.pp (puppet/manifests) and build a new image

## Software
Download the following software from Oracle and Agree to the license
- 12.1.0.1 file 1 & 2 ( linuxamd64_12c_database_1of2.zip )

Add them to this docker folder

## Build image (~ 13GB)
docker build -t oracle/database12101_centos6 .

Maybe compress it first, see the compress image chapter

## Start container
default, will start the listener & database server
- docker run -i -t -p 1521:1521 oracle/database12101_centos6:latest

with bash

docker run -i -t -p 1521:1521 oracle/database12101_centos6:latest /bin/bash
- /startup.sh

## Remove image
docker rmi oracle/database12101_centos6

## Compress image (now ~7.6GB)
- ID=$(docker run -d oracle/database12101_centos6:latest /bin/bash)
- docker export $ID > database12101_centos6.tar
- cat database12101_centos6.tar | docker import - database12101_centos6
- docker run -i -t -p 1521:1521 database12101_centos6:latest /bin/bash
- /startup.sh

## Boot2docker, MAC OSX
Probably run out of space
Resize boot2docker image https://docs.docker.com/articles/b2d_volume_resize/

VirtualBox forward rules
- VBoxManage controlvm boot2docker-vm natpf1 "database,tcp,,1521,,1521"

Check the ipaddress
- boot2docker ip

