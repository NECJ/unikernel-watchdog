FROM scratch as cache

COPY bin    .

FROM scratch as ship

ARG TARGETPLATFORM
ARG BUILDPLATFORM
ARG TARGETOS
ARG TARGETARCH

COPY --from=cache /fwatchdog-amd64 ./fwatchdog

ENTRYPOINT ["/fwatchdog"]
