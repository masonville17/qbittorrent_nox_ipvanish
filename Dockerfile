FROM debian:bookworm
ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update
RUN apt-get install -y \
    qbittorrent-nox \
    openvpn \
    ca-certificates \
    vim \
    iproute2 \
    wget \
    unzip \
    iptables \
    dnsutils \
    net-tools && apt-get clean && rm -rf /var/lib/apt/lists/*
WORKDIR /app
COPY start.sh /app/
COPY pass /app/
COPY exclude_countries /app/
RUN chmod +x /app/start.sh
EXPOSE 8080

CMD ["./start.sh"]
