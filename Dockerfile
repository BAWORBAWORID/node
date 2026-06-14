FROM ubuntu:22.04

ENV DEBIAN_FRONTEND=noninteractive
ENV TZ=Asia/Jakarta

RUN apt-get update && apt-get upgrade -y && \
    apt-get install -y tzdata && \
    ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone && \
    apt-get install -y --no-install-recommends \
        curl \
        wget \
        ca-certificates \
        gnupg \
        unzip \
        xz-utils \
        git \
        libgtk-3-0 \
        libgbm1 \
        libasound2 \
        libx11-xcb1 \
        libxcb1 \
        libxcomposite1 \
        libxcursor1 \
        libxdamage1 \
        libxi6 \
        libxtst6 \
        libnss3 \
        libcups2 \
        libdrm2 \
        libpango-1.0-0 \
        libatk1.0-0 \
        libatk-bridge2.0-0 \
        libnspr4 \
        libxrandr2 \
        libxfixes3 \
        libxss1 \
        fonts-liberation \
        libappindicator3-1 \
        libu2f-udev \
        xdg-utils \
        sudo \
        && rm -rf /var/lib/apt/lists/*

RUN curl -fsSL https://deb.nodesource.com/setup_20.x | bash - && \
    apt-get install -y nodejs && \
    rm -rf /var/lib/apt/lists/*

# Install Docker
RUN curl -sSL https://get.docker.com/ | CHANNEL=stable bash

# Setup Wings daemon directories
RUN mkdir -p /etc/pterodactyl && \
    mkdir -p /var/lib/pterodactyl/volumes && \
    mkdir -p /var/log/pterodactyl

# Download Wings
RUN curl -L -o /usr/local/bin/wings "https://github.com/pterodactyl/wings/releases/latest/download/wings_linux_$(uname -m | sed 's/aarch64/arm64/;s/x86_64/amd64/')" && \
    chmod u+x /usr/local/bin/wings

# Write config.yml
RUN echo "debug: false" > /etc/pterodactyl/config.yml && \
    echo "uuid: fc8e3088-7b9b-4eb8-b4bf-c874969686f9" >> /etc/pterodactyl/config.yml && \
    echo "token_id: UkCozU1LbLeMv6wD" >> /etc/pterodactyl/config.yml && \
    echo "token: z1pidcdpd8N23gIP03v6gujz3GOqcYnESoeFcPygAI3xkt0VqRRTTTvRpkkKLs2w" >> /etc/pterodactyl/config.yml && \
    echo "api:" >> /etc/pterodactyl/config.yml && \
    echo "  host: 0.0.0.0" >> /etc/pterodactyl/config.yml && \
    echo "  port: 8080" >> /etc/pterodactyl/config.yml && \
    echo "  ssl:" >> /etc/pterodactyl/config.yml && \
    echo "    enabled: false" >> /etc/pterodactyl/config.yml && \
    echo "    cert: /etc/letsencrypt/live/node.alwayscodex.my.id/fullchain.pem" >> /etc/pterodactyl/config.yml && \
    echo "    key: /etc/letsencrypt/live/node.alwayscodex.my.id/privkey.pem" >> /etc/pterodactyl/config.yml && \
    echo "  upload_limit: 100" >> /etc/pterodactyl/config.yml && \
    echo "system:" >> /etc/pterodactyl/config.yml && \
    echo "  data: /var/lib/pterodactyl/volumes" >> /etc/pterodactyl/config.yml && \
    echo "  sftp:" >> /etc/pterodactyl/config.yml && \
    echo "    bind_port: 5000" >> /etc/pterodactyl/config.yml && \
    echo "allowed_mounts: []" >> /etc/pterodactyl/config.yml && \
    echo "remote: 'http://store.alwayscodex.my.id'" >> /etc/pterodactyl/config.yml

# chmod biar bisa di modif path / semuanya
RUN chmod -R 777 /var/lib/pterodactyl/volumes /etc/pterodactyl /var/log/pterodactyl /usr/local/bin/wings

WORKDIR /app

RUN rm -rf /var/run/docker*

EXPOSE 8080 5000 3000

CMD ["wings"]
