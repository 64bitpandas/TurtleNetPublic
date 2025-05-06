# Multi-stage build for GoatCounter v2.5

# Build stage
FROM golang:1.21-alpine AS builder

# Install necessary build dependencies
RUN apk add --no-cache git gcc musl-dev

# Set working directory
WORKDIR /build

# Clone the specific release branch
RUN git clone --branch=release-2.5 https://github.com/arp242/goatcounter.git .

# Build a statically linked binary. Tweak the flags a bit to build on alpine.
# https://github.com/mattn/go-sqlite3/issues/1164
RUN CGO_ENABLED=1 CGO_CFLAGS="-D_LARGEFILE64_SOURCE" \
    go build -tags "osusergo,netgo,sqlite_omit_load_extension,linux,musl" \
    -ldflags="-extldflags '-static'" \
    ./cmd/goatcounter

# Final stage
FROM alpine:latest

# Install CA certificates for HTTPS connections
RUN apk add --no-cache ca-certificates sqlite

# Create non-root user for running the application
RUN addgroup -S goatcounter && adduser -S goatcounter -G goatcounter

# Create directory for database files
RUN mkdir -p /data/db && \
    chown -R goatcounter:goatcounter /data

# Copy the binary from the builder stage
COPY --from=builder /build/goatcounter /usr/local/bin/

# Set necessary capabilities to bind to privileged ports
RUN apk add --no-cache libcap && \
    setcap 'cap_net_bind_service=+ep' /usr/local/bin/goatcounter && \
    apk del libcap

# Set up volume for persistent data
VOLUME ["/data"]

# Switch to non-root user
USER goatcounter

# Set working directory
WORKDIR /data

# Expose the default HTTP and HTTPS ports
EXPOSE 80 443

# Run GoatCounter server. The DB lives in /data/db/goatcounter.sqlite3 by default.
ENTRYPOINT ["/usr/local/bin/goatcounter", "serve"]