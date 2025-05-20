#!/bin/sh
# Start OpenVPN in the background
openvpn --config $OPENVPN_CONFIG --auth-user-pass /etc/openvpn/auth.txt --daemon

# Wait for VPN to connect
echo "Waiting for VPN connection..."
sleep 10

# Verify VPN connection
if curl --silent https://ipinfo.io | grep -q "country"; then
    echo "VPN is connected."
else
    echo "VPN connection failed."
    exit 1
fi

# Bypass VPN for host subnet
ip route add 10.7.7.0/24 via 172.17.0.1 dev eth0

# Run the original entrypoint/command of the prebuilt image
exec /docker-entrypoint.sh "$@"
