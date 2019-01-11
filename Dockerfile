FROM golang:1.11-alpine as builder

ENV VERSION v0.8.5

RUN apk add --update git ca-certificates && \
    mkdir -p /go/src/github.com/cloudflare && \
    cd /go/src/github.com/cloudflare && \
    git clone https://github.com/cloudflare/cloudflare-go && \
    cd cloudflare-go && \
    git checkout $VERSION && \
    go get github.com/cloudflare/cloudflare-go/cmd/flarectl && \
    CGO_ENABLED=0 GOOS=linux go install -a -installsuffix cgo github.com/cloudflare/cloudflare-go/cmd/flarectl

FROM scratch
COPY --from=builder /go/bin/flarectl /
COPY --from=builder /etc/ssl/certs/ca-certificates.crt /etc/ssl/certs/ca-certificates.crt
ENTRYPOINT ["/flarectl"]
