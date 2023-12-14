FROM php:8.3-rc-apache-bookworm
RUN apt-get update && \
DEBIAN_FRONTEND=noninteractive apt-get -yq install golang git socat && \
GOPATH=/root/go go install github.com/mailhog/mhsendmail@latest && \
cp /root/go/bin/mhsendmail /usr/local/bin/mhsendmail && \
cp /usr/local/etc/php/php.ini-development /usr/local/etc/php/php.ini && \
sed -i 's/smtp_port = 25/smtp_port = 1025/g' /usr/local/etc/php/php.ini && \
sed -i 's/;sendmail_path =/sendmail_path = \/usr\/local\/bin\/mhsendmail/g' /usr/local/etc/php/php.ini && \
rm -rf /var/lib/apt/lists/*