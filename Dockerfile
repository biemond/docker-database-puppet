# CentOS 6
FROM centos:centos6

# Do this to enable Oracle Linux
# wget http://public-yum.oracle.com/docker-images/OracleLinux/OL6/oraclelinux-6.6.tar.xz
# docker load -i oraclelinux-6.6.tar.xz
# FROM oraclelinux:6.6

RUN yum -y install hostname.x86_64 rubygems ruby-devel gcc git unzip
RUN echo "gem: --no-ri --no-rdoc" > ~/.gemrc

RUN rpm --import https://yum.puppetlabs.com/RPM-GPG-KEY-puppetlabs && \
    rpm -ivh http://yum.puppetlabs.com/puppetlabs-release-el-6.noarch.rpm

# configure & install puppet
RUN yum install -y puppet tar
RUN gem install -y librarian-puppet -v 1.0.3

RUN yum clean all

ADD puppet/Puppetfile /etc/puppet/
ADD puppet/manifests/site.pp /etc/puppet/

WORKDIR /etc/puppet/
RUN librarian-puppet install

# upload software
RUN mkdir /var/tmp/install
RUN chmod 777 /var/tmp/install

RUN mkdir /software

COPY linuxamd64_12c_database_1of2.zip /software/
COPY linuxamd64_12c_database_2of2.zip /software/

RUN chmod -R 777 /software

RUN puppet apply /etc/puppet/site.pp --verbose --detailed-exitcodes || [ $? -eq 2 ]

EXPOSE 1521

ADD startup.sh /
RUN chmod 0755 /startup.sh

WORKDIR /

# cleanup
RUN rm -rf /software/*
RUN rm -rf /var/tmp/install/*
RUN rm -rf /var/tmp/*
RUN rm -rf /tmp/*

CMD bash -C '/startup.sh';'bash'
