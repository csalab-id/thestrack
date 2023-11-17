FROM debian:12
RUN apt update && \
apt install -y openbox \
  firefox-esr \
  terminator \
  tigervnc-standalone-server \
  tigervnc-xorg-extension \
  tigervnc-viewer \
  novnc \
  dbus-x11 && \
sed -i "s/off/remote/g" /usr/share/novnc/app/ui.js
WORKDIR /root
COPY source/openbox.startup.sh /startup.sh
EXPOSE 80
ENTRYPOINT [ "/bin/bash", "/startup.sh" ]