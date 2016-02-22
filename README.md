## Oracle Database 12.1.0.2 ( 12c ) Standard Edition Docker image

it will download a minimal CentOS 7 image, Puppet and all its dependencies

The Docker image will be big, and off course this is not supported by Oracle and like always check your license to use this software

Configures Puppet and use librarian-puppet to download all the modules from the Puppet Forge

### Result
- Oracle Database Standard Edition 12.1.0.2
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
Download the following [software 12.1.0.2](http://www.oracle.com/technetwork/database/enterprise-edition/downloads/database12c-linux-download-1959253.html) from Oracle and Agree to the license
- 12.1.0.2 file 1 & 2 ( linuxamd64_12102_database_se2_1of2.zip & linuxamd64_12102_database_se2_2of2.zip )

Add them to this docker folder

### Build image (~ 12GB)
docker build -t oracle/database12102 .

Maybe after the build you should compress it first, see the compress section for more info

### Start container
default, will start the listener & database server
- docker run -i -t -p 1521:1521 oracle/database12102:latest

with bash

docker run -i -t -p 1521:1521 oracle/database12102:latest /bin/bash
- /startup.sh

### Compress image (now ~7.6GB)
- ID=$(docker run -d oracle/database12102:latest /bin/bash)
- docker export $ID > database12102.tar
- cat database12102.tar | docker import - database12102
- docker run -i -t -p 1521:1521 database12102:latest /bin/bash
- /startup.sh

### Boot2docker, MAC OSX
Probably you will run out of space
- Resize boot2docker image https://docs.docker.com/articles/b2d_volume_resize/

VirtualBox forward rules
- VBoxManage controlvm boot2docker-vm natpf1 "database,tcp,,1521,,1521"

Check the ipaddress
- boot2docker ip

### Mac OSX fusion
- docker-machine create --driver vmwarefusion --vmwarefusion-disk-size 40960  vm
- docker-machine env vm

