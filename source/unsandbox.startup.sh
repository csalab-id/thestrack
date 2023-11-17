#!/bin/bash

rm -rf /root/.vnc/*.pid /root/.vnc/*.log /tmp/.X1* /run/dbus/pid
mkdir -p /root/.vnc/
touch /root/.Xauthority

if [[ "$PASSWORD" == "" ]]
then
    vncpasswd -f <<< password > /root/.vnc/passwd
else
    vncpasswd -f <<< $PASSWORD > /root/.vnc/passwd
fi

vncserver -PasswordFile /root/.vnc/passwd
dbus-daemon --config-file=/usr/share/dbus-1/system.conf
/usr/share/novnc/utils/novnc_proxy --listen 80 --vnc 127.0.0.1:5901