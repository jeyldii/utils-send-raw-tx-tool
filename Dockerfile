FROM golang:latest AS builder

RUN mkdir /build
ADD . /build
WORKDIR /build

RUN go build -o bin/main ./server

FROM python:3.7-stretch

ENV DEBIAN_FRONTEND noninteractive

COPY --from=builder /build/bin /app/
COPY --from=builder /etc/ssl/certs/ca-certificates.crt /etc/ssl/certs/

WORKDIR /app

#install dep
RUN apt-get -y update
RUN apt-get -y install libssl-dev zlib1g-dev cmake g++ build-essential libncurses5-dev libgdbm-dev libnss3-dev libssl-dev libreadline-dev libffi-dev gperf expect wget

# build ton client
RUN wget https://test.ton.org/ton-test-liteclient-full.tar.xz
RUN tar -xvf ton-test-liteclient-full.tar.xz
RUN mkdir liteclient-build

WORKDIR /app/liteclient-build
RUN cmake /app/lite-client
RUN cmake --build . --target lite-client
RUN cmake --build . --target fift
RUN wget https://test.ton.org/ton-lite-client-test1.config.json

WORKDIR /app

COPY server/wrappers /app/wrappers

EXPOSE 8080

CMD ["/app/main"]
