#!/bin/bash
VPN_INTERFACE="tun0"
OPENVPN_CONFIGS_ZIP_URL="https://configs.ipvanish.com/configs/configs.zip"
ORIGINAL_EXTERNAL_IP=$(curl -s https://ipinfo.io/ip)

# Local ports to exclude from VPN
echo "Adding iptable rules"
iptables -A OUTPUT -o tun0 -p tcp --dport 8080 -j DROP
iptables -t nat -A POSTROUTING -o tun0 -j MASQUERADE

# downloading and configuring openvpn files / connection

# download and inflate, remove zipfile and exclude countries
wget $OPENVPN_CONFIGS_ZIP_URL && unzip *.zip && rm *.zip

readarray -t countries < exclude_countries
for country in "${countries[@]}"
do
    echo "Removing files with pattern *-$country-*"
    rm -rf *-"$country"-*
done

# select random ovpn file and establish connection
OVPN_FILE=$(find . -name "*.ovpn" | shuf -n 1)
echo "Establishing Connection with $OVPN_FILE"
sed -i '/keysize/d' "${OVPN_FILE}"
openvpn --config "${OVPN_FILE}" --auth-user-pass pass & 
vpn_pid=$!

# Wait for VPN to establish connection and check if connection is established
sleep 20
if ip a show tun0 up > /dev/null 2>&1; then
    echo "VPN is connected."z
else
    echo "VPN connection failed."
    exit 1
fi

echo "starting qbnox"
qbittorrent-nox &
qbnox_pid=$!

while true; do
    vpn_infos=$(ps -f -p $vpn_pid)
    ip_addr=$(curl -s https://ipinfo.io/ip)
    ip_addr_infos="You are using $ip_addr as your external IP address (originally $ORIGINAL_EXTERNAL_IP)..."    
    echo "vpn infos: PID: $vpn_pid, vpn_infos... i2p info: $i2pinfos... ipinfos: $ipinfos... Sleeping 10m..."
    sleep 600
done
trap "kill $vpn_pid" EXIT
