#!/bin/bash

mkdir -p ~/.vnc/
sudo rm -rf ~/.vnc/*.pid ~/.vnc/*.log /tmp/.X1* /run/dbus/pid
touch ~/.Xauthority

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

sudo bash -c 'cat << EOF > /usr/lib/firefox-esr/distribution/policies.json
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
'

sudo bash -c 'cat << EOF > /etc/apt/apt.conf.d/proxy.conf
Acquire::http::Proxy "http://10.20.0.20:8080";
Acquire::https::Proxy "http://10.20.0.20:8080";
EOF
'

timeout 5 firefox-esr -headless
cp /tmp/user.js ~/.mozilla/firefox/*.default-esr/
if [ ! -f /usr/local/share/ca-certificates/mitmproxy.crt ]
then
    sudo curl --proxy http://10.20.0.20:8080 http://mitm.it/cert/pem -o /usr/local/share/ca-certificates/mitmproxy.crt
    sudo bash -c "cat /usr/local/share/ca-certificates/mitmproxy.crt >> /etc/ssl/certs/ca-certificates.crt"
fi
sudo update-ca-certificates

vncpasswd -f <<< $PASSWORD > ~/.vnc/passwd
vncserver -PasswordFile ~/.vnc/passwd
sudo dbus-daemon --config-file=/usr/share/dbus-1/system.conf
/usr/share/novnc/utils/novnc_proxy --listen 80 --vnc 127.0.0.1:5901