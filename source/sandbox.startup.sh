#!/bin/bash

rm -rf /root/.vnc/*.pid /root/.vnc/*.log /tmp/.X1* /run/dbus/pid
mkdir -p /root/.vnc/
touch /root/.Xauthority

cat << EOF > /tmp/user.js
user_pref("network.proxy.backup.ssl", "");
user_pref("network.proxy.backup.ssl_port", 0);
user_pref("network.proxy.http", "10.20.0.20");
user_pref("network.proxy.http_port", 8080);
user_pref("network.proxy.share_proxy_settings", true);
user_pref("network.proxy.ssl", "10.20.0.20");
user_pref("network.proxy.ssl_port", 8080);
user_pref("network.proxy.type", 1);
EOF

cat << EOF > /usr/lib/firefox-esr/distribution/policies.json
{
    "policies": {
        "Certificates": {
            "ImportEnterpriseRoots": true,
            "Install": [
                "mitmproxy.crt",
                "/usr/local/share/ca-certificates/mitmproxy.crt"
            ]
        }
    }
}
EOF

cat << EOF > /etc/apt/apt.conf.d/proxy.conf
Acquire::http::Proxy "http://10.20.0.20:8080";
Acquire::https::Proxy "http://10.20.0.20:8080";
EOF

if [[ "$PASSWORD" == "" ]]
then
    vncpasswd -f <<< password > /root/.vnc/passwd
else
    vncpasswd -f <<< $PASSWORD > /root/.vnc/passwd
fi

timeout 5 firefox-esr -headless
cp /tmp/user.js ~/.mozilla/firefox/*.default-esr/
if [ ! -f /usr/local/share/ca-certificates/mitmproxy.crt ]
then
    curl --proxy http://10.20.0.20:8080 http://mitm.it/cert/pem -o /usr/local/share/ca-certificates/mitmproxy.crt
    cat /usr/local/share/ca-certificates/mitmproxy.crt >> /etc/ssl/certs/ca-certificates.crt
fi
update-ca-certificates

vncserver -PasswordFile /root/.vnc/passwd
dbus-daemon --config-file=/usr/share/dbus-1/system.conf
/usr/share/novnc/utils/novnc_proxy --listen 80 --vnc 127.0.0.1:5901