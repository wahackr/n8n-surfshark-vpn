# Use the prebuilt image as the base
FROM docker.n8n.io/n8nio/n8n

# Switch to root for package installation
USER root

# Install OpenVPN and curl
RUN apk add --no-cache openvpn curl

# Copy Surfshark OpenVPN config and auth files
COPY openvpn-configs/ /etc/openvpn/

# Create entrypoint script
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

# Ensure container has necessary permissions for VPN
ENV OPENVPN_CONFIG=/etc/openvpn/sg-sng.prod.surfshark.comsurfshark_openvpn_udp.ovpn

# Restore original user (if non-root, replace 'nobody' with actual user)
#USER node

# Run entrypoint script
ENTRYPOINT ["/entrypoint.sh"]
