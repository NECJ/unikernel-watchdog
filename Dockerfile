FROM alpine:3.17

COPY bin/fwatchdog-amd64 ./fwatchdog
RUN chmod +x /fwatchdog

RUN apk add qemu-system-x86_64

ENTRYPOINT ["/fwatchdog"]