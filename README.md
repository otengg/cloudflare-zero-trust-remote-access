# Cloudflare Zero Trust Remote Access Lab

This repository documents how I built a **Cloudflare Zero Trust remote access** solution for my homelab.  
The goal: create **secure, identity-aware access** to internal services (pfSense UI, dashboards, apps) **without exposing any ports** to the internet — using **Cloudflare Tunnel + Cloudflare Access**.

---

# 📌 Table of Contents

- [Overview](#overview)
- [Architecture](#architecture)
- [Why Zero Trust?](#why-zero-trust)
- [Lab Topology](#lab-topology)
- [Setup Documentation](#setup-documentation)
- [Configs](#configs)
- [Testing & Troubleshooting](#testing--troubleshooting)
- [Skills Demonstrated](#skills-demonstrated)
- [Future Improvements](#future-improvements)

---

# 🔎 Overview

Typical home networks expose their services using:

- Port forwarding  
- Public VPN servers  
- Weak access controls  

This creates unnecessary attack surface.

**Cloudflare Zero Trust** replaces this with:

- Identity-aware access policies  
- Outbound-only tunnels  
- No publicly exposed ports  
- Cloud-based access control  
- Internal services staying 100% private  

This repo walks through:

- Design  
- Cloudflare configuration  
- pfSense integration  
- Tunnel routing  
- End-to-end testing  
- Troubleshooting  

---

# 🧱 Architecture


      Internet User
            |
            v
  +---------------------------+
  |        Cloudflare         |
  |  - DNS (proxied records)  |
  |  - Zero Trust / Access    |
  |  - Tunnel Endpoint        |
  +-------------+-------------+
                |
                |  (outbound-only tunnel)
                v
      +------------------------+
      |  cloudflared Connector |
      |   (Linux VM in lab)    |
      +-----------+------------+
                  |
                  v
        +----------------------+
        |      pfSense LAN     |
        |  Internal Services   |
        +----------------------+


The connector VM creates an encrypted **outbound-only** tunnel to Cloudflare.  
All traffic enters through Cloudflare → Zero Trust policy → Tunnel → internal service.

pfSense never exposes any ports to the internet.

---

# 🛡️ Why Zero Trust?

This approach provides:

- No public attack surface  
- Identity-based authentication  
- Device posture enforcement (optional)  
- Cloud-based access logs  
- Private services accessible anywhere securely  

It mirrors **modern enterprise security**, but built in a homelab.

---

# 🗺️ Lab Topology

- **Cloudflare**
  - DNS  
  - Zero Trust / Access  
  - Tunnel endpoint  

- **Homelab network**
  - Netgate 2100 (pfSense)  
  - Linux VM running `cloudflared`  
  - Internal services (pfSense UI, dashboards, etc.)  

Full details:  
📄 [`docs/02-lab-topology.md`](docs/02-lab-topology.md)

---

# 📚 Setup Documentation

Each section of the project has a dedicated guide:

- **Overview** → [`docs/01-overview.md`](docs/01-overview.md)  
- **Architecture + Flow** → [`docs/02-lab-topology.md`](docs/02-lab-topology.md)  
- **Cloudflare Zero Trust Setup** → [`docs/03-cloudflare-zero-trust-setup.md`](docs/03-cloudflare-zero-trust-setup.md)  
- **pfSense Integration Guide** → [`docs/04-pfsense-and-tunnel-config.md`](docs/04-pfsense-and-tunnel-config.md)  
- **Testing & Troubleshooting** → [`docs/05-testing-and-troubleshooting.md`](docs/05-testing-and-troubleshooting.md)

These replicate a real-world deployment process.

---

# 🛠️ Configs

Sample configs used in the lab:

- Cloudflare Tunnel config  
  → [`configs/cloudflare-tunnel-config-example.yml`](configs/cloudflare-tunnel-config-example.yml)

- DNS records  
  → [`configs/dns-records-example.csv`](configs/dns-records-example.csv)

- Connectivity test script  
  → [`scripts/test-connectivity.sh`](scripts/test-connectivity.sh)

---

# 🧪 Testing & Troubleshooting

A full testing guide is available here:

📄 [`docs/05-testing-and-troubleshooting.md`](docs/05-testing-and-troubleshooting.md)

Covers:

- DNS validation  
- Tunnel health  
- Access policy testing  
- Internal connectivity  
- Failure scenarios  

---

# 🧠 Skills Demonstrated

This project showcases:

### 🔹 Network Security  
- Cloudflare Zero Trust  
- Cloudflare Tunnel  
- Identity-aware access control  
- DNS & proxied records  
- TLS routing  
- pfSense firewall rules  

### 🔹 Networking Fundamentals  
- NAT  
- Routing  
- Outbound filtering  
- VLAN segmentation  

### 🔹 Systems + Homelab Engineering  
- Linux VM configuration  
- cloudflared installation  
- Service management  
- Internal service mapping  

### 🔹 Tooling & Documentation  
- Git & GitHub  
- Markdown documentation  
- Repo organization  
- Troubleshooting methodology  

---

# 🚀 Future Improvements

Planned enhancements:

- Add device posture checks  
- Add MFA enforcement  
- Add more internal apps behind Zero Trust  
- Add a public live demo (read-only)  
- Convert topology to a full PNG diagram  
- Optional: build a GitHub Pages site from this repo  

---

# 📎 Conclusion

This repository serves as a complete **Zero Trust remote-access solution** built on Cloudflare and pfSense — replicating real enterprise architecture in a homelab environment.

All configs, docs, and testing were done in a live environment and published here for learning, portfolio use, and reference.
