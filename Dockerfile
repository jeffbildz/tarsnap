FROM ubuntu:16.10

ARG deps='curl python-pip lsb-release'

RUN apt-get -qq update && apt-get -qq -y install $deps && \
      curl -sL https://pkg.tarsnap.com/tarsnap-deb-packaging-key.asc | apt-key add - && \
      echo "deb http://pkg.tarsnap.com/deb/$(lsb_release -s -c) ./" >> /etc/apt/sources.list.d/tarsnap.list && \
      apt-get -qq update && apt-get -qq -y install tarsnap && \
      pip install tarsnapper && apt-get -qq -q purge python-pip && \
      mkdir /etc/tarsnapper && \
      apt-get -qq -y autoremove && rm -fr /var/lib/apt/lists/*

COPY docker_files/start.sh /start.sh
COPY docker_files/tarsnap.sh /usr/local/bin/tarsnap.sh
COPY docker_files/tarsnapper.yml /etc/tarsnapper.yml

VOLUME /usr/local/tarsnap-cache

ENTRYPOINT ["/start.sh"]

