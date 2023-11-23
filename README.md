# Qbittorrent-nox (bittorrent client webservice) with Split-Tunnel OpenVPN

This Docker setup builds and starts a qbittorrent-nox service behind a split-tunnel OpenVPN connection, utilizing IpVanish as the VPN service.

## Features

- **qbittorrent-nox**: Run latest qbittorrent-nox with a fresh vpn connection every time. Bring over your configuration and remember to seed. Qbittorrent-nox web port is only available locally, and you can exclude any countries from the randomly-selected IPVanish Vpn connection.
- **Split-Tunneling**: Local-only traffic on port 8080 is not sent through VPN, optimizing privacy and efficiency.
- **OpenVPN with IpVanish**: Secure and private connection using OpenVPN and IpVanish as the VPN service provider. Simply change the hardcoded download URI to use a different ovpn-compliant provider's config bundle.

## Configuration

You can customize the setup by filling out `exclude_countries` with any 2-letter country codes you'd like to remove from the downloaded/expanded `configs.zip` file. This allows for more control over the VPN configuration and server selection.

## Run Instructions
Build and run this image in one go. If you want to utilize a different connection, tear down and run this again.
```
sudo docker-compose up -d --build  
```
## Teardown Instructions
copy your files/folders you wish to keep or seed in the future, then, run:
```
sudo docker-compose down --volumes 
```

## Ports:
8080: qbittorrent-nox webservice port

## Todo: 
need to parameterize more things, allow for ssl cert, etc.

## Acknowledgments
This project owes its existence to the outstanding work of the qBittorrent team and the broader qBittorrent-nox community. Immense gratitude goes to all the developers, contributors, and supporters of these projects for their commitment to open-source development, user-friendly design, and their contributions to the world of file sharing and torrenting.

## Licensing and Usage
This project is available for non-commercial use and is built upon open-source foundations. It inherits the permissions and restrictions of its base technologies. We encourage users to honor the licenses and community guidelines of the qBittorrent and qBittorrent-nox projects when utilizing this software.