# n8n Container with Surfshark VPN

### Surfshark Login
Get the Username and Password in here: https://my.surfshark.com/vpn/manual-setup/main/openvpn

This is not your normal Surfshark login

You may also download the ovpn location config file there.

Update `openvpn-configs/auth.txt` with the Username and Password.


### VPN Location
If you downloaded new ovpn location config file, modify the line `ENV OPENVPN_CONFIG=/etc/openvpn/sg-sng.prod.surfshark.comsurfshark_openvpn_udp.ovpn` in `Dockerfile`


### Networking
Since after connected the VPN, all traffic would go via the VPN adapter include traffic back to your host network, you have to modify this line `ip route add 10.7.7.0/24 via 172.17.0.1 dev eth0` in `entrypoint.sh` to add the route to fix it.
`172.17.0.1` is the default docker0 bridge IP, you may check it by running `ip addr show docker0` in your host machine. `10.7.7.0/24` is your host network IP, you may check it by running `ip addr` in your host machine. You may also run `ip route` to check the routing table.


### Build Docker Image
`
docker build -t n8n-surfshark:latest .
`


### Start Container
`
docker run -it --name n8n_surfshark_dev --restart always -p 5678:5678 -v n8n_data:/home/node/.n8n -e N8N_USER_FOLDER=/home/node -e GENERIC_TIMEZONE="Asia/Hong_Kong" -e TZ="Asia/Hong_Kong" -e N8N_SECURE_COOKIE=false -e WEBHOOK_URL="http://n8n.alohaonline.asia:5678" --cap-add=NET_ADMIN --device=/dev/net/tun -it n8n-surfshark
`

### Persistent Storage
Set env var `N8N_USER_FOLDER` to the mounted volume, so the n8n configs will be kept even the container is destroyed.
