FROM kalilinux/kali-rolling:latest
LABEL maintainer="admin@csalab.id"
RUN sed -i "s/http.kali.org/mirrors.ocf.berkeley.edu/g" /etc/apt/sources.list && \
    apt-get update && \
    apt-get -y upgrade
RUN DEBIAN_FRONTEND=noninteractive apt-get -yq install \
    sudo \
    proxychains \
    curl \
    wget \
    unzip \
    terminator \
    dialog \
    firefox-esr \
    inetutils-ping \
    htop \
    nano \
    vim \
    net-tools \
    tigervnc-standalone-server \
    tigervnc-xorg-extension \
    tigervnc-viewer \
    novnc \
    dbus-x11
RUN DEBIAN_FRONTEND=noninteractive apt-get -yq install \
    xfce4-goodies \
    kali-desktop-xfce && \
    apt-get -y full-upgrade
RUN apt-get -y autoremove && \
    apt-get clean all && \
    rm -rf /var/lib/apt/lists/* && \
    useradd -m -c "Kali Linux" -s /bin/bash -d /home/kali kali && \
    sed -i "s/off/remote/g" /usr/share/novnc/app/ui.js && \
    sed -i "s/socks4 \t127.0.0.1 9050/http\t10.20.0.20 8080/g" /etc/proxychains.conf && \
    echo "kali ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers && \
    touch /usr/share/novnc/index.htm
COPY source/unsandbox.startup.sh /startup.sh
USER kali
WORKDIR /home/kali
ENV PASSWORD=password
ENV SHELL=/bin/bash
EXPOSE 80
ENTRYPOINT [ "/bin/bash", "/startup.sh" ]