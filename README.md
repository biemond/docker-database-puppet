## Oracle Database 12.1.0.1 ( 12c ) Standard Edition Docker image

it will download a minimal CentOS 6 image, Puppet 3.7 and all it dependencies

You can also use use the official Oracle Linux 6.6 docker image, just do the following
- wget http://public-yum.oracle.com/docker-images/OracleLinux/OL6/oraclelinux-6.6.tar.xz
- docker load -i oraclelinux-6.6.tar.xz
- docker run --rm -i -t oraclelinux:6.6 /bin/bash
- Change the first line of the Dockerfile to FROM oraclelinux:6.6

The Docker image will be big, and off course this is not supported by Oracle and like always check your license to use this software

Configures Puppet and use librarian-puppet to download all the modules from the Puppet Forge

### Result
- Oracle Database Standard Edition 12.1.0.1
- Service name = orcl.example.com
- username sys or system
- All passwords = Welcome01
- Demo schemas

Optional, you can add your own DB things, just change the puppet site.pp manifest
- Add your own Tablespaces
- Add Roles
- User with grants
- Change database init parameters
- execute some SQL

### Software
Download the following [software 12.1.01](http://www.oracle.com/technetwork/database/enterprise-edition/downloads/database12c-linux-download-1959253.html) from Oracle and Agree to the license
- 12.1.0.1 file 1 & 2 ( linuxamd64_12c_database_1of2.zip )

Add them to this docker folder

### Build image (~ 13GB)
docker build -t oracle/database12101 .

Maybe after the build you should compress it first, see the compress section for more info

### Start container
default, will start the listener & database server
- docker run -i -t -p 1521:1521 oracle/database12101:latest

with bash

docker run -i -t -p 1521:1521 oracle/database12101:latest /bin/bash
- /startup.sh

### Compress image (now ~7.6GB)
- ID=$(docker run -d oracle/database12101:latest /bin/bash)
- docker export $ID > database12101.tar
- cat database12101.tar | docker import - database12101
- docker run -i -t -p 1521:1521 database12101:latest /bin/bash
- /startup.sh

### Boot2docker, MAC OSX
Probably you will run out of space
- Resize boot2docker image https://docs.docker.com/articles/b2d_volume_resize/

VirtualBox forward rules
- VBoxManage controlvm boot2docker-vm natpf1 "database,tcp,,1521,,1521"

Check the ipaddress
- boot2docker ip

