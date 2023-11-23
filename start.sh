#!/bin/bash
VPN_INTERFACE="tun0"

wget https://configs.ipvanish.com/configs/configs.zip
unzip configs.zip
rm configs.zip

readarray -t countries < exclude_countries

for country in "${countries[@]}"
do
    echo "Removing files with pattern *-$country-*"
    rm -rf *-"$country"-*
done

OVPN_FILE=$(find . -name "*.ovpn" | shuf -n 1)
echo "Today, we'll connect to $OVPN_FILE"

#remove no longer supported openvpn parameter.
sed -i '/keysize/d' "${OVPN_FILE}"

openvpn --config "${OVPN_FILE}" --auth-user-pass pass &

sleep 5
echo "vpn should be connected by now."
ip a
sleep 15
# Local ports to exclude from VPN
iptables -A OUTPUT -o tun0 -p tcp --dport 8080 -j DROP
iptables -t nat -A POSTROUTING -o tun0 -j MASQUERADE

echo "starting configuring qbnox"

mkdir ./qbnox && cd ./qbnox

while true; do
    qbnoxinfos=$(qbittorrent-nox)
    ipinfos=$(ip a)
    echo "qbnox info: $qbnoxinfos... ipinfos: $ipinfos... Sleeping 10m..."
    sleep 600
done
wait
