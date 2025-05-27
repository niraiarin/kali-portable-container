FROM kalilinux/kali-rolling
## Set ENV (nothing)
## Set ARG
ARG user=alice
## Install Required packages
RUN apt-get update && \
    DEBIAN_FRONTEND=noninteractive TZ=Asia/Tokyo apt-get install -y tzdata && \
    ln -fs /usr/share/zoneinfo/$TZ /etc/localtime && \
    dpkg-reconfigure --frontend noninteractive tzdata && \
    DEBIAN_FRONTEND=noninteractive apt-get -qq full-upgrade -y && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y -qq kali-linux-everything iputils-ping glances speedtest-cli iperf wget curl && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y -qq kali-desktop-xfce xorg xrdp && \
    apt-get autoremove && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*
## Setup SSH & XRDP
RUN useradd -m ${user} && \
    gpasswd -a ${user} sudo && \
    echo "${user}:kali" | chpasswd && \
    adduser xrdp ssl-cert && \
    mkdir -p /home/${user}/.ssh && \
    chown ${user}:${user} /home/${user}/.ssh && \
    chmod 700 /home/${user}/.ssh && \
    chsh ${user} -s /bin/zsh && \
    sed -i 's/#PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config && \
    sed -i 's/#PasswordAuthentication yes/PasswordAuthentication no/' /etc/ssh/sshd_config
COPY authorized_keys /home/${user}/.ssh/authorized_keys
RUN chown nirarin:nirarin /home/${user}/.ssh/authorized_keys && \
    chmod 600 /home/${user}/.ssh/authorized_keys && \
    systemctl enable dbus && \
    systemctl enable xrdp && \
    systemctl enable ssh
CMD ["/sbin/init"]
## Expose ports map
### SSH
EXPOSE 22
### XRDP
EXPOSE 3389
## Set working directory
WORKDIR /workdir
## Set Label
LABEL version="1.0"
LABEL maintainer="niraiarin"
LABEL description="Kali Linux Container \
for any usages."
