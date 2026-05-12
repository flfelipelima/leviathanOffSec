# 🐉 LEVIATHAN — Offensive Security Workstation

```text
 ██╗     ███████╗██╗   ██╗██╗ █████╗ ████████╗██╗  ██╗ █████╗ ███╗   ██╗
 ██║     ██╔════╝██║   ██║██║██╔══██╗╚══██╔══╝██║  ██║██╔══██╗████╗  ██║
 ██║     █████╗  ██║   ██║██║███████║   ██║   ███████║███████║██╔██╗ ██║
 ██║     ██╔══╝  ╚██╗ ██╔╝██║██╔══██║   ██║   ██╔══██║██╔══██║██║╚██╗██║
 ███████╗███████╗ ╚████╔╝ ██║██║  ██║   ██║   ██║  ██║██║  ██║██║ ╚████║
 ╚══════╝╚══════╝  ╚═══╝  ╚═╝╚═╝  ╚═╝   ╚═╝   ╚═╝  ╚═╝╚═╝  ╚═╝╚═╝  ╚═══╝
```

<p align="center">
  <img src="assets/leviathan.png" width="220" alt="Leviathan Logo">
</p>

<h1 align="center">🐉 Leviathan</h1>

<p align="center">
  Portable Docker workstation for bug bounty, pentest, recon and security testing.
</p>

<p align="center">
  <a href="https://hub.docker.com/r/l1m4/leviathan">
    <img src="https://img.shields.io/badge/Docker%20Hub-l1m4%2Fleviathan-2496ED?style=for-the-badge&logo=docker&logoColor=white">
  </a>
  <a href="https://github.com/l1m4/leviathan">
    <img src="https://img.shields.io/badge/GitHub-Leviathan-181717?style=for-the-badge&logo=github&logoColor=white">
  </a>
</p>

<p align="center">
  <img src="https://img.shields.io/badge/Edition-Docker-blue?style=for-the-badge">
  <img src="https://img.shields.io/badge/Image-leviathan:latest-purple?style=for-the-badge">
  <img src="https://img.shields.io/badge/Shell-ZSH-red?style=for-the-badge">
  <img src="https://img.shields.io/badge/Theme-Powerlevel10k%20Dracula-ff79c6?style=for-the-badge">
</p>

---

## 📌 Overview

**Leviathan** is a Docker-based offensive security workstation designed for:

| Area | Purpose |
|---|---|
| Bug Bounty | Recon, web testing, automation and scanning |
| Pentest | Network, web, exploit and password testing |
| Red Team Labs | Isolated tooling environment |
| Learning | Reproducible security lab |
| Portability | Same environment across machines |

Instead of installing dozens of tools directly on your host system, Leviathan provides a clean and reproducible containerized environment.

---

## ✨ Features

| Feature | Description |
|---|---|
| Single Image | Uses one image: `leviathan:latest` |
| Single Container | Runs as one offensive workstation container |
| Persistent Workspace | Project files are mounted into `/workspace` |
| Persistent Configs | ZSH, Powerlevel10k and tmux configs are mounted |
| Wordlists Volume | SecLists and rockyou.txt stored in Docker volume |
| Host Networking | Uses host network mode for realistic scanning |
| Raw Socket Support | Supports tools like `nmap`, `masscan`, `tcpdump` |
| Custom Shell | Oh My Zsh + Powerlevel10k + Dracula |
| Fast Startup | Build once, run whenever needed |
| Easy Cleanup | Remove containers/images/volumes with one command |

---

## 👤 Creator

| Field | Info |
|---|---|
| Creator | Felipe **"l1m4"** Lima |
| Focus | Offensive Security, Bug Bounty, Pentest Automation |
| Project | Leviathan Offensive Security Workstation |

---

## 🧱 Architecture

```text
Host Machine
│
├── leviathan.sh
│   └── Controls build, start, shell, logs, theme, wordlists
│
├── docker/
│   ├── Dockerfile
│   └── docker-compose.yml
│
├── configs/
│   ├── zshrc
│   ├── p10k.zsh
│   └── tmux.conf
│
└── Docker
    ├── Image: leviathan:latest
    ├── Container: leviathan
    ├── Volume: leviathan_wordlists
    └── Workspace: /workspace
```

---

## 📁 Project Structure

```text
leviathan-docker/
├── leviathan.sh              # Main controller script
├── docker/
│   ├── Dockerfile            # Single image definition
│   └── docker-compose.yml    # Container runtime config
├── configs/
│   ├── zshrc                 # ZSH configuration
│   ├── p10k.zsh              # Powerlevel10k configuration
│   └── tmux.conf             # Tmux configuration
├── README.md
└── zshrc_backup
```

---

## ⚙️ Requirements

| Requirement | Version / Notes |
|---|---|
| OS | Linux x86_64 |
| Docker | Docker 24+ recommended |
| Compose | Docker Compose v2 |
| Network | Internet required for first build |
| Terminal Font | Nerd Font recommended |

Recommended fonts:

| Font | Purpose |
|---|---|
| MesloLGS NF | Best Powerlevel10k compatibility |
| JetBrainsMono Nerd Font | Clean modern terminal look |
| FiraCode Nerd Font | Ligatures and icon support |

---

## 🚀 Quick Start

```bash
git clone https://github.com/felipelimart/leviathan.git
cd leviathan
chmod +x leviathan.sh
./leviathan.sh install
./leviathan.sh shell
```

---

## 🧭 Command Reference

| Command | Description |
|---|---|
| `./leviathan.sh install` | Full setup: build image, start container and pull wordlists |
| `./leviathan.sh install-docker` | Install Docker engine only |
| `./leviathan.sh build` | Build `leviathan:latest` image |
| `./leviathan.sh up` | Start Leviathan container |
| `./leviathan.sh down` | Stop and remove Leviathan container |
| `./leviathan.sh shell` | Open interactive ZSH shell |
| `./leviathan.sh run <cmd>` | Run command inside container |
| `./leviathan.sh logs` | Follow container logs |
| `./leviathan.sh ps` | Show container status |
| `./leviathan.sh wordlists` | Download SecLists and rockyou.txt |
| `./leviathan.sh theme` | Install Dracula Powerlevel10k theme |
| `./leviathan.sh pull` | Disabled; local image mode |
| `./leviathan.sh clean` | Remove container, image and volumes |
| `./leviathan.sh help` | Show help menu |

---

## 🐳 Docker Runtime

| Item | Value |
|---|---|
| Image | `leviathan:latest` |
| Container | `leviathan` |
| Network | `host` |
| Shell | `/bin/zsh` |
| Workdir | `/workspace` |
| Mode | Single Image |

Example:

```bash
docker ps
```

Expected:

```text
CONTAINER ID   IMAGE               COMMAND      STATUS        NAMES
xxxxxxxxxxxx   leviathan:latest    "/bin/zsh"   Up x mins     leviathan
```

---

## 📦 Volumes and Mounts

| Host / Volume | Container Path | Purpose |
|---|---|---|
| `../` | `/workspace` | Project workspace |
| `../configs/zshrc` | `/root/.zshrc` | ZSH config |
| `../configs/p10k.zsh` | `/root/.p10k.zsh` | Powerlevel10k config |
| `../configs/tmux.conf` | `/root/.tmux.conf` | Tmux config |
| `leviathan_wordlists` | `/wordlists` | SecLists and rockyou.txt |

---

## 🔐 Docker Permissions

Leviathan is configured for offensive security tooling that may need low-level networking.

| Setting | Reason |
|---|---|
| `network_mode: host` | Required for realistic scanning |
| `privileged: true` | Allows low-level network tooling |
| `NET_ADMIN` | Network administration capabilities |
| `NET_RAW` | Raw sockets for packet crafting |
| `seccomp:unconfined` | Avoids syscall blocking for security tools |

This helps tools like:

| Tool | Reason |
|---|---|
| `nmap` | Raw packets and service detection |
| `masscan` | High-speed scanning |
| `tcpdump` | Packet capture |
| `tshark` | Traffic inspection |
| `naabu` | Port scanning |
| `responder` | Network attacks/lab usage |

---

## 🧰 Included Tool Categories

### Recon

| Tool | Purpose |
|---|---|
| subfinder | Subdomain enumeration |
| amass | Attack surface mapping |
| assetfinder | Asset discovery |
| httpx | HTTP probing |
| naabu | Port scanning |
| dnsx | DNS toolkit |
| nuclei | Vulnerability templates |
| katana | Crawling |
| gau | Historical URLs |
| waybackurls | Wayback URL discovery |

### Web

| Tool | Purpose |
|---|---|
| sqlmap | SQL injection automation |
| ffuf | Fuzzing |
| gobuster | Directory/DNS brute force |
| feroxbuster | Recursive content discovery |
| dirsearch | Web path discovery |
| wfuzz | Web fuzzing |
| whatweb | Web fingerprinting |
| XSStrike | XSS testing |

### Network

| Tool | Purpose |
|---|---|
| nmap | Network scanning |
| masscan | Fast port scanning |
| tcpdump | Packet capture |
| tshark | Packet analysis |
| netcat | TCP/UDP utility |
| socat | Network relay |
| traceroute | Route analysis |
| dnsutils | DNS tools |

### Exploitation

| Tool | Purpose |
|---|---|
| metasploit-framework | Exploitation framework |
| exploitdb | Exploit database |
| searchsploit | Local exploit search |
| impacket | Network protocol toolkit |
| pwntools | Exploit development |

### Passwords

| Tool | Purpose |
|---|---|
| hashcat | Password cracking |
| john | Password cracking |
| hydra | Online brute force |
| wordlists | Default Kali wordlists |

---

## 🧪 Usage Examples

### Open the workstation

```bash
./leviathan.sh shell
```

### Run command without entering shell

```bash
./leviathan.sh run nmap -sV 127.0.0.1
```

### Recon function inside shell

```bash
recon target.com
```

### Nuclei scan

```bash
nuclei -u https://target.com
```

### FFUF directory brute force

```bash
ffuf -u https://target.com/FUZZ \
-w /wordlists/SecLists/Discovery/Web-Content/common.txt
```

### SQLMap

```bash
sqlmap -u "https://target.com/item.php?id=1" --dbs
```

### Start local HTTP server

```bash
http
```

### Show public IP

```bash
myip
```

---

## 🎨 Terminal Theme

Leviathan uses:

| Component | Theme |
|---|---|
| Shell | ZSH |
| Framework | Oh My Zsh |
| Prompt | Powerlevel10k |
| Color scheme | Dracula |
| Font | Nerd Font recommended |

Install Dracula theme:

```bash
./leviathan.sh theme
```

Recommended terminal font:

```text
MesloLGS NF
```

or:

```text
JetBrainsMono Nerd Font
```

---

## 🧠 Aliases

| Alias | Command |
|---|---|
| `ll` | `ls -lah --color=auto` |
| `la` | `ls -la --color=auto` |
| `ports` | `ss -tulnp` |
| `myip` | `curl -s https://ipinfo.io/ip` |
| `workspace` | `cd /workspace` |
| `lev` | `cd /workspace` |
| `seclists` | `ls /wordlists/SecLists/` |
| `rockyou` | `echo /wordlists/rockyou.txt` |
| `sub` | `subfinder -silent` |
| `probehttp` | `httpx -silent` |
| `portscan` | `naabu -silent` |
| `vuln` | `nuclei -silent` |
| `http` | `python3 -m http.server` |

---

## 🧩 Built-in Functions

| Function | Usage | Description |
|---|---|---|
| `recon` | `recon target.com` | Finds subdomains and probes HTTP services |
| `portcheck` | `portcheck host port` | Checks if a port is open |
| `extracturls` | `extracturls file.txt` | Extracts URLs from a file |
| `mkcd` | `mkcd folder` | Creates and enters a directory |

---

## 🗂️ Recommended Workspace Layout

```text
/workspace/
├── targets/
├── scans/
├── loot/
├── notes/
├── reports/
├── screenshots/
└── output/
```

Example:

```bash
mkdir -p /workspace/{targets,scans,loot,notes,reports,screenshots,output}
```

---

## 🔁 Normal Workflow

```bash
./leviathan.sh up
./leviathan.sh shell
```

Work normally inside the container.

When finished:

```bash
exit
./leviathan.sh down
```

The image remains available. You do not need to rebuild every time.

---

## 🏗️ Build Behavior

You only need to rebuild when changing:

| Changed Item | Need Build? |
|---|---|
| `Dockerfile` | Yes |
| Installed tools | Yes |
| `configs/zshrc` | No, if mounted as volume |
| `configs/p10k.zsh` | No, if mounted as volume |
| `configs/tmux.conf` | No, if mounted as volume |
| `README.md` | No |
| `leviathan.sh` | No |

Use:

```bash
./leviathan.sh build
```

Docker will reuse cached layers whenever possible.

---

## 🧹 Cleanup

```bash
./leviathan.sh clean
```

This removes:

| Item | Removed |
|---|---|
| Container | Yes |
| Image | Yes |
| Volumes | Yes |
| Orphans | Yes |

Use carefully.

---

## ⚠️ Legal Notice

This project is intended for:

- authorized security testing
- lab environments
- bug bounty programs
- educational use
- systems you own or have permission to test

Do not use Leviathan against systems without authorization.

---

## 📜 License

MIT License

---

## 🐉 Motto

> Build once. Hack anywhere.  
> Stay isolated. Stay reproducible. Stay dangerous — legally.
