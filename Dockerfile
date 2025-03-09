ARG GOVERSION=1.23
ARG GOARCH
FROM golang:${GOVERSION} AS builder
ARG GOARCH
ENV GOARCH=amd64
WORKDIR /go/src/k8s.io/kube-state-metrics/
COPY . /go/src/k8s.io/kube-state-metrics/

RUN make install-tools && make build-local

FROM gcr.io/distroless/static-debian12:latest-amd64
COPY --from=builder /go/src/k8s.io/kube-state-metrics/kube-state-metrics /

USER nobody

ENTRYPOINT ["/kube-state-metrics", "--port=8080", "--telemetry-port=8081"]

EXPOSE 8080 8081
