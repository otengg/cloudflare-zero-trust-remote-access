# Cloudflare Zero Trust Setup (Step-by-Step)

This document explains how I configured **Cloudflare Zero Trust** to secure access to my homelab services using **Cloudflare Tunnel** and **Cloudflare Access**.

---

# 1️⃣ Add Your Domain to Cloudflare

1. Buy a domain name (Namecheap, Google Domains, Porkbun, etc.)
2. Log into Cloudflare → **Add a Site**
3. Import your DNS records
4. Update your registrar to point to Cloudflare nameservers

Once DNS is active, the domain is ready for Zero Trust.

---

# 2️⃣ Enable Cloudflare Zero Trust

1. Navigate to:  
   **Security → Zero Trust**

2. Click **Enable Zero Trust**

3. Set up your:
   - Team name
   - Billing tier (**Free plan is enough for this homelab project**)

---

# 3️⃣ Install the Cloudflare Tunnel Connector (`cloudflared`)

I deployed the connector on a Linux VM inside my homelab.

### Install on Ubuntu:

```bash
curl -fsSL https://pkg.cloudflare.com/cloudflare-main.gpg | sudo gpg --dearmor -o /usr/share/keyrin
