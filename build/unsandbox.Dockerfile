FROM kalilinux/kali-rolling:latest
RUN sed -i "s/http.kali.org/mirrors.ocf.berkeley.edu/g" /etc/apt/sources.list && \
apt-get update && \
apt-get install -y openbox \
  firefox-esr \
  curl \
  wget \
  unzip \
  proxychains \
  nano \
  vim \
  nautilus \
  libxss-dev \
  terminator \
  tigervnc-standalone-server \
  tigervnc-xorg-extension \
  tigervnc-viewer \
  novnc \
  dbus-x11 && \
sed -i "s/off/remote/g" /usr/share/novnc/app/ui.js && \
sed -i "s/socks4 \t127.0.0.1 9050/http\t10.20.0.20 8080/g" /etc/proxychains.conf
WORKDIR /root
COPY source/unsandbox.startup.sh /startup.sh
EXPOSE 80
ENTRYPOINT [ "/bin/bash", "/startup.sh" ]