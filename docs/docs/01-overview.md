# Cloudflare Zero Trust Remote Access – Project Overview

This project shows how I used **Cloudflare Zero Trust** to secure remote access to my homelab without exposing any direct ports to the internet.

Instead of:
- Port forwarding on my home router
- A publicly exposed VPN endpoint

I use:
- **Cloudflare Tunnel** (outbound-only tunnel from my lab to Cloudflare)
- **Cloudflare Access** (identity-aware access control)
- My own **domain managed in Cloudflare**

---

## 🧠 Problem This Solves

Typical home networks (and even some small businesses) do things like:

- Port forward the firewall or NAS UI to the internet  
- Run a VPN server directly on the WAN and hope it’s secure  
- Rely only on a single password

That creates risks:

- Attackers can scan the public IP and find open ports  
- Weak or reused credentials can be brute-forced  
- No identity-aware rules (who, where, which device)

My goal was to build a setup that looks **closer to a modern enterprise Zero Trust model**:

- No direct inbound ports exposed
- Identity-aware access policies
- Easy for me to reach my services from anywhere

---

## 🧱 High-Level Design

At a high level, the design is:

1. **DNS & Domain**
   - My domain is managed in **Cloudflare DNS**
   - Friendly hostnames like `pfsense.mydomain.com`, `dash.mydomain.com`, etc.

2. **Cloudflare Tunnel**
   - A small agent (`cloudflared`) runs in my homelab
   - It creates an **outbound-only tunnel** to Cloudflare
   - Cloudflare forwards authenticated traffic down that tunnel to my internal services

3. **Cloudflare Zero Trust / Access**
   - All protected URLs sit behind **Cloudflare Access**
   - Users must authenticate with an approved identity provider (e.g., email / Google login)
   - Access policies decide **who** can reach **which** internal apps

4. **Homelab Network**
   - Edge firewall: **pfSense** (Netgate 2100 in my case)
   - Internal services (firewall UI, dashboards, apps) live on private IPs
   - The tunnel connector can reach those private IPs, but they never need to be exposed on the WAN

---

## 🧰 Technologies Used

- **Cloudflare**
  - Cloudflare DNS
  - Cloudflare Zero Trust / Access
  - Cloudflare Tunnel (`cloudflared`)

- **Networking / Homelab**
  - pfSense firewall (Netgate 2100)
  - Internal VLANs / LAN services
  - Tunnel connector host (Linux VM)

- **Tooling & Docs**
  - Git & GitHub for version control
  - Markdown documentation
  - (Planned) diagrams stored under `/diagrams`

---

## 🎯 What This Project Demonstrates

From a recruiter / engineer perspective, this repo shows that I can:

- Design a **Zero Trust–style remote access** solution
- Use **Cloudflare’s security stack** to protect self-hosted services
- Integrate cloud security with a **real network topology**, not just theory
- Document the design in a way that is clear and repeatable

The rest of the `/docs` folder will go into:

- Exact setup steps
- Screenshots / diagrams
- Example configurations (sanitized)

This file is the high-level story behind the project.
