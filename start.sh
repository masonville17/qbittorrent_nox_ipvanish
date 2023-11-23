#!/bin/bash
VPN_INTERFACE="tun0"
OPENVPN_CONFIGS_ZIP_URL="https://configs.ipvanish.com/configs/configs.zip"

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
sleep 45
if ip a show tun0 up > /dev/null 2>&1; then
    echo "VPN is connected."
else
    echo "VPN connection failed."
    exit 1
fi

echo "starting configuring qbnox"

while true; do
    vpn_infos=$(ps -f -p $vpn_pid)
    qbnoxinfos=$(qbittorrent-nox)
    ipinfos=$(ip a)
    echo ""vpn infos: PID: $vpn_pid, $vpn_infos... qbnox info: $qbnoxinfos... ipinfos: $ipinfos... Sleeping 10m..."
    sleep 600
done
wait
