# Cloudflare Zero Trust Remote Access Lab

This repository documents how I built a **Cloudflare Zero Trust–based remote access solution** for my homelab.  
The goal is to replace traditional port forwarding and exposed VPN ports with a **modern, identity-aware, browser-based** access model using **Cloudflare Tunnel + Cloudflare Access**.

---

## 🚀 What this project shows

- Secure remote access to **self-hosted services** (pfSense UI, dashboards, apps) **without** exposing ports to the internet
- Zero Trust controls based on:
  - Identity (Google/Microsoft account, email, etc.)
  - Optional device posture
  - Location / network rules
- Integration with:
  - **Cloudflare Tunnel**
  - **Cloudflare Zero Trust / Access**
  - **Custom domain + Cloudflare DNS**
  - A home network / firewall (pfSense / Netgate)

This repo is part of my **portfolio** to demonstrate practical **network security + Zero Trust** skills.

---

## 🧩 High-Level Architecture
(Adding diagram soon)

---

## 📁 Repo Structure (planned)

```text
diagrams/
docs/
configs/
scripts/
exports/
