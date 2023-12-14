FROM golang:1.18-alpine as builder
RUN apk --no-cache add --virtual build-dependencies git  && \
mkdir -p /root/gocode && \
export GOPATH=/root/gocode && \
go install github.com/mailhog/MailHog@latest

FROM alpine:3
RUN adduser -D -u 1000 mailhog
COPY --from=builder /root/gocode/bin/MailHog /usr/local/bin/
USER mailhog
WORKDIR /home/mailhog
EXPOSE 1025 8025
ENTRYPOINT ["MailHog"]