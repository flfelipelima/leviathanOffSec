# =============================================================================
# LEVIATHAN — Offensive Security Workstation
# Docker Edition
# =============================================================================

FROM kalilinux/kali-rolling:latest

LABEL name="Leviathan"
LABEL description="Offensive Security Toolkit"
LABEL version="1.0"

ENV DEBIAN_FRONTEND=noninteractive
ENV GOPATH=/root/go
ENV PATH="/root/go/bin:/usr/local/go/bin:/opt/tools/bin:/usr/local/bin:${PATH}"
ENV TERM=xterm-256color

WORKDIR /workspace

# ─── Base system & utils ──────────────────────────────────────────────────────
# Ferramentas essenciais do sistema — raramente mudam
RUN apt-get update && apt-get install -y --no-install-recommends \
    zsh bash curl wget git vim nano tmux \
    unzip zip tar p7zip-full ca-certificates gnupg \
    build-essential make gcc g++ \
    python3 python3-pip python3-venv pipx \
    golang \
    ruby ruby-dev \
    perl \
    jq fzf ripgrep fd-find tree htop \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# ─── Network & recon ──────────────────────────────────────────────────────────
# Ferramentas de rede e reconhecimento passivo
RUN apt-get update && apt-get install -y --no-install-recommends \
    net-tools iproute2 iputils-ping dnsutils whois traceroute \
    nmap masscan netcat-traditional socat \
    tcpdump tshark wireshark-common \
    openssh-client \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# ─── Web enumeration ──────────────────────────────────────────────────────────
# Fuzzing, crawlers e enumeração web
RUN apt-get update && apt-get install -y --no-install-recommends \
    gobuster ffuf feroxbuster dirb wfuzz \
    whatweb \
    sqlmap \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# ─── Password & exploitation ──────────────────────────────────────────────────
# Cracking, wordlists e frameworks de exploração
RUN apt-get update && apt-get install -y --no-install-recommends \
    hydra john hashcat wordlists \
    metasploit-framework \
    exploitdb dirsearch python3-impacket \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# ─── ProjectDiscovery & asset discovery ───────────────────────────────────────
# Suite ProjectDiscovery e ferramentas de descoberta de ativos
RUN apt-get update && apt-get install -y --no-install-recommends \
    nuclei \
    subfinder amass assetfinder \
    httpx-toolkit \
    dnsx \
    naabu \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# ─── Python tools ─────────────────────────────────────────────────────────────
RUN pip3 install --break-system-packages --no-cache-dir \
    dirsearch \
    arjun \
    xsstrike \
    impacket \
    pwntools \
    requests \
    beautifulsoup4 \
    shodan

# ─── Go tools ─────────────────────────────────────────────────────────────────
RUN go install github.com/tomnomnom/httprobe@latest && \
    go install github.com/tomnomnom/waybackurls@latest && \
    go install github.com/tomnomnom/assetfinder@latest && \
    go install github.com/lc/gau/v2/cmd/gau@latest && \
    go install github.com/tomnomnom/anew@latest && \
    go install github.com/tomnomnom/qsreplace@latest && \
    go install github.com/hahwul/dalfox/v2@latest && \
    go install github.com/projectdiscovery/katana/cmd/katana@latest

# ─── Oh My Zsh + Powerlevel10k Dracula ───────────────────────────────────────
RUN sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended || true && \
    git clone --depth=1 https://github.com/romkatv/powerlevel10k.git /root/.oh-my-zsh/custom/themes/powerlevel10k && \
    git clone --depth=1 https://github.com/dracula/powerlevel10k.git /tmp/dracula-powerlevel10k && \
    cp /tmp/dracula-powerlevel10k/files/.zshrc /root/.zshrc && \
    cp /tmp/dracula-powerlevel10k/files/.p10k.zsh /root/.p10k.zsh && \
    git clone --depth=1 https://github.com/zsh-users/zsh-autosuggestions /root/.oh-my-zsh/custom/plugins/zsh-autosuggestions && \
    git clone --depth=1 https://github.com/zsh-users/zsh-syntax-highlighting.git /root/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting

# ─── Workspace ────────────────────────────────────────────────────────────────
RUN mkdir -p /workspace /opt/tools

# ─── Custom configs ───────────────────────────────────────────────────────────
COPY configs/zshrc /root/.zshrc
COPY configs/p10k.zsh /root/.p10k.zsh
COPY configs/tmux.conf /root/.tmux.conf


# ─── Fix PATH + hushlogin ────────────────────────────────────────────────────
RUN echo 'export PATH="/root/go/bin:/usr/local/go/bin:/opt/tools/bin:/usr/local/bin:$PATH"' >> /root/.bashrc && \
    echo 'export PATH="/root/go/bin:/usr/local/go/bin:/opt/tools/bin:/usr/local/bin:$PATH"' >> /root/.zshrc && \
    touch /root/.hushlogin


CMD ["/bin/zsh"]
