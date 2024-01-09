#!/bin/bash

mkdir -p ~/.vnc/
sudo rm -rf ~/.vnc/*.pid ~/.vnc/*.log /tmp/.X1* /run/dbus/pid
touch ~/.Xauthority
vncpasswd -f <<< $PASSWORD > ~/.vnc/passwd
vncserver -PasswordFile ~/.vnc/passwd
sudo dbus-daemon --config-file=/usr/share/dbus-1/system.conf
/usr/share/novnc/utils/novnc_proxy --listen 80 --vnc 127.0.0.1:5901