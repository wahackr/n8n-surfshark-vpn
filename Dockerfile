# Stage 1: The "Builder" - use a standard Alpine to get the files
FROM alpine:3.20 AS builder
RUN apk add --no-cache openvpn curl

# Stage 2: The Final Image
FROM docker.n8n.io/n8nio/n8n

USER root

# Copy the binaries and libraries from the builder stage
# This bypasses the need for 'apk' in the final hardened image
COPY --from=builder /usr/bin/curl /usr/bin/curl
COPY --from=builder /usr/sbin/openvpn /usr/sbin/openvpn
COPY --from=builder /lib/ /lib/
COPY --from=builder /usr/lib/ /usr/lib/
COPY --from=builder /etc/openvpn /etc/openvpn

# Copy your specific configs
COPY openvpn-configs/ /etc/openvpn/

# Setup entrypoint
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

ENV OPENVPN_CONFIG=/etc/openvpn/sg-sng.prod.surfshark.comsurfshark_openvpn_udp.ovpn

# It is highly recommended to stay as root if you are running OpenVPN, 
# as it needs to create network interfaces.
ENTRYPOINT ["/entrypoint.sh"]