# Oracle
FROM oraclelinux:7

RUN rpm --import https://yum.puppetlabs.com/RPM-GPG-KEY-puppetlabs && \
    rpm -ivh http://yum.puppetlabs.com/el/7/products/x86_64/puppetlabs-release-7-11.noarch.rpm && \
    yum -y install hostname.x86_64 rubygems ruby-devel gcc git unzip dos2unix && \
    echo "gem: --no-ri --no-rdoc" > ~/.gemrc && \
    yum install -y --skip-broken puppet tar && \
    gem install librarian-puppet && \
    yum clean all

ADD puppet/Puppetfile /etc/puppet/
ADD puppet/manifests/site.pp /etc/puppet/

WORKDIR /etc/puppet/
RUN librarian-puppet install && \
    mkdir /var/tmp/install && \
    chmod 777 /var/tmp/install && \
    mkdir /software

COPY linuxamd64_12102_database_se2_1of2.zip /software/
COPY linuxamd64_12102_database_se2_2of2.zip /software/

RUN chmod -R 777 /software && \
    puppet apply /etc/puppet/site.pp --verbose --detailed-exitcodes || [ $? -eq 2 ] && \
    rm -rf /software/*  && \
    rm -rf /var/tmp/install/*  && \
    rm -rf /var/tmp/*  && \
    rm -rf /tmp/* && \
    yum clean all

EXPOSE 1521

ADD startup.sh /
RUN dos2unix -o /startup.sh && \
    chmod 0755 /startup.sh

WORKDIR /

CMD bash -C '/startup.sh';'bash'
