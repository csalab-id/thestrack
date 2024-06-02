FROM golang:1-stretch as builder
RUN echo "deb http://archive.debian.org/debian stretch main" > /etc/apt/sources.list && \
echo "deb http://archive.debian.org/debian-security stretch/updates main" >> /etc/apt/sources.list && \
apt-get update && \
DEBIAN_FRONTEND=noninteractive apt-get -yq install git && \
mkdir -p /root/gocode && \
export GOPATH=/root/gocode && \
go install github.com/mailhog/mhsendmail@latest

FROM php:5-apache-stretch
COPY --from=builder /root/gocode/bin/mhsendmail /usr/local/bin/mhsendmail
RUN echo "deb http://archive.debian.org/debian stretch main" > /etc/apt/sources.list && \
echo "deb http://archive.debian.org/debian-security stretch/updates main" >> /etc/apt/sources.list && \
apt-get update && \
apt-get -yq install socat && \
cp /usr/local/etc/php/php.ini-development /usr/local/etc/php/php.ini && \
sed -i 's/smtp_port = 25/smtp_port = 1025/g' /usr/local/etc/php/php.ini && \
sed -i 's/;sendmail_path =/sendmail_path = \/usr\/local\/bin\/mhsendmail/g' /usr/local/etc/php/php.ini && \
rm -rf /var/lib/apt/lists/*