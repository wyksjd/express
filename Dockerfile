FROM ubuntu:16.04

ENV EXPRESSVPN_CLIENT_DOWNLOAD_VERSION 3.45.0.2-1
ENV EXPRESSVPN_CLIENT_VERSION 3.45.0.2
ENV EXPRESSVPN_CLIENT_BUILD 7586
ENV SHADOWSOCKS_VERSION v1.7.0-alpha.19

RUN apt update && \
    apt install -y iproute2 wget curl iptables iputils* net-tools xz-utils supervisor bash unzip && \
    echo -e "nameserver 8.8.8.8\nnameserver 8.8.4.4\n" > /etc/resolv.conf && \
    wget https://download.expressvpn.xyz/clients/linux/expressvpn_${EXPRESSVPN_CLIENT_DOWNLOAD_VERSION}_amd64.deb -O /opt/expressvpn.deb && \
    wget -N --no-check-certificate "https://github.com/ToyoDAdoubiBackup/shadowsocksr/archive/manyuser.zip" && \
    unzip "manyuser.zip" && \
    cd /opt/ && \
    apt install -y ./expressvpn.deb && \
    cd /shadowsocksr-manyuser && \
    bash initcfg.sh && \
    cd / && \
    rm -rf /var/lib/apt/lists/*

VOLUME /var/lib/expressvpn

ENV VPN_LOCATION=usla1
CMD ["/entrypoint.sh"]

ADD ./supervisor.conf /etc/supervisor/conf.d/supervisor.conf
ADD ./entrypoint.sh /entrypoint.sh

