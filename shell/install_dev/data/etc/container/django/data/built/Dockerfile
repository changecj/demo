FROM ubuntu:14.04
MAINTAINER prozhou <zhoushengzheng@gmail.com>

WORKDIR /etc/apt
ADD soft/ /opt/soft

RUN mkdir -p /var/log/uwsgi/ && touch /var/log/uwsgi/htdocs.log

RUN mv /opt/soft/sources.list sources.list && \
    apt-get update

RUN   usermod -u 1000 www-data

RUN  apt-get install wget curl wget  python3-dev  python3-pip uwsgi-plugin-python3 uwsgi-plugin-python3 -y &&\
      rm -rf /var/lib/apt/lists/*

COPY soft/requirements.txt requirements.txt

RUN   pip3 install -r requirements.txt
    

WORKDIR /
RUN echo '#!/bin/bash' > /init.sh && \
    echo 'cd /opt/soft && uwsgi --ini uwsgi.ini && while true; do sleep 1000; done ' >> /init.sh && \
    chmod +x /init.sh
CMD ["/init.sh"]

VOLUME ["/opt"]

EXPOSE 9090

   
