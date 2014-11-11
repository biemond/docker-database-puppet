FROM centos:centos6

# Need to enable centosplus for the image libselinux issue
RUN yum install -y yum-utils
RUN yum-config-manager --enable centosplus

RUN yum -y install hostname.x86_64 rubygems ruby-devel gcc git
RUN echo "gem: --no-ri --no-rdoc" > ~/.gemrc
#RUN yum group install "Base"
#RUN yum group install "Development Tools"

RUN rpm --import https://yum.puppetlabs.com/RPM-GPG-KEY-puppetlabs && \
    rpm -ivh http://yum.puppetlabs.com/puppetlabs-release-el-6.noarch.rpm

# configure & install puppet
RUN yum install -y puppet tar
RUN gem install librarian-puppet -v 1.0.3

RUN yum -y install httpd; yum clean all

ADD puppet/Puppetfile /etc/puppet/
ADD puppet/manifests/site.pp /etc/puppet/

WORKDIR /etc/puppet/
RUN librarian-puppet install

# upload software
RUN mkdir /var/tmp/install
RUN chmod 777 /var/tmp/install

RUN mkdir /software
RUN chmod 777 /software

COPY linuxamd64_12c_database_1of2.zip /software/
COPY linuxamd64_12c_database_2of2.zip /software/

RUN puppet apply /etc/puppet/site.pp --verbose --detailed-exitcodes || [ $? -eq 2 ]

EXPOSE 1521

CMD /bin/bash
