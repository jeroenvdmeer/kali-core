# Official base image
FROM kalilinux/kali-rolling

# Environmental variables
ENV DEBIAN_FRONTEND noninteractive
ENV TERM xterm-256color

# Apt
RUN apt -y update && apt -y full-upgrade && apt -y autoremove && apt clean

# Install kali-linux-core metapackage and h4x0r toolz
# https://tools.kali.org/kali-metapackages
RUN apt -y --no-install-recommends install kali-linux-core medusa metasploit-framework nmap proxychains sqlmap tor whois wpscan

# Create non-root user (sudoer)
RUN adduser --gecos "" kali sudo
RUN echo "kali:ilak" | chpasswd

# Start Open SSH server
RUN systemctl start ssh

# Initialize Metasploit database and expose port 4444 for LPORT
RUN service postgresql start && msfdb init
VOLUME /root /var/lib/postgresql
EXPOSE 4444

WORKDIR /root
CMD ["/bin/bash", "-c", "echo hello; sleep 100000"]
