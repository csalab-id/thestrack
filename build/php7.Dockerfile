FROM php:7.4.33-apache-bullseye
COPY conf/postfix/main.cf /etc/postfix/main.cf
RUN apt-get update && \
apt-get install postfix mailutils libsasl2-2 ca-certificates libsasl2-modules && \
echo "[10.20.0.25]:587 postmaster@server.lab:supersecretpassword" > /etc/postfix/sasl/sasl_passwd && \
postmap /etc/postfix/sasl/sasl_passwd && \
chown root:root /etc/postfix/sasl/sasl_passwd /etc/postfix/sasl/sasl_passwd.db && \
chmod 0600 /etc/postfix/sasl/sasl_passwd /etc/postfix/sasl/sasl_passwd.db && \
postconf -e "relayhost = [10.20.0.25]:587" && \
postconf -e "smtp_sasl_auth_enable = yes" && \
postconf -e "smtp_use_tls = yes" && \
postconf -e "smtp_sasl_password_maps = hash:/etc/postfix/sasl/sasl_passwd" && \
postconf -e "smtp_sasl_security_options = noanonymous" && \
postconf -e "smtp_tls_CAfile = /etc/ssl/certs/ca-certificates.crt" && \
postconf -e "smtp_tls_security_level = encrypt"
# postconf -e "smtp_tls_session_cache_database = btree:/var/lib/postfix/smtp_tls_session_cache"