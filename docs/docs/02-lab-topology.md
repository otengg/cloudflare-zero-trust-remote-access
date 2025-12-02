# Lab Topology & Network Flow

This document describes the topology of my **Cloudflare Zero Trust remote access lab** and how traffic flows from the internet to internal services.

---

## 🗺️ Logical Topology

High-level components:

- **Client (me on the internet)**
- **Cloudflare Edge**
  - DNS
  - Zero Trust / Access
  - Tunnel endpoint
- **Cloudflare Tunnel Connector**
  - `cloudflared` running on a VM inside my homelab
- **Edge Firewall**
  - pfSense (Netgate 2100)
- **Internal Services**
  - pfSense Web UI
  - Dashboards / monitoring
  - Other self-hosted apps

---

## 🔁 Traffic Flow (Step by Step)

1. **User opens a protected URL**

   I visit `https://app.mydomain.com` in a browser.

2. **DNS resolution**

   - `app.mydomain.com` is a **proxied DNS record** in Cloudflare (orange cloud).
   - DNS returns a Cloudflare anycast IP, not my home IP.

3. **Cloudflare Access policy check**

   - Cloudflare checks the **Access policy** attached to `app.mydomain.com`.
   - If I’m not authenticated, I’m redirected to a login page (email / IdP).
   - If my identity satisfies the rules (email, group, etc.), I’m allowed through.

4. **Cloudflare Tunnel forwarding**

   - Cloudflare forwards the request over my **Cloudflare Tunnel**.
   - The tunnel is an **outbound-only** connection from my homelab to Cloudflare, established by `cloudflared`.

5. **Tunnel connector → internal service**

   - The tunnel connector VM receives the request.
   - It forwards traffic to the configured internal target, for example:
     - `10.0.10.1:443` (pfSense UI)
     - `10.0.20.50:3000` (dashboard)
   - This traffic stays entirely inside my private network.

6. **Response back to client**

   - The internal service responds back to the tunnel connector.
   - Cloudflare sends the response to the client over HTTPS.
   - From the outside, only Cloudflare is visible – not my home IP, not any open ports.

---

## 🧱 Physical / Lab Layout (Homelab Side)

In my lab, the main components are:

- **Netgate 2100 (pfSense)**
  - Acts as the main router/firewall
  - Provides LAN segments/VLANs for internal devices
  - Has normal outbound internet access

- **Tunnel Connector VM**
  - Linux VM running `cloudflared`
  - Located on an internal network that can reach:
    - pfSense LAN IP
    - Any internal web services I want to publish

- **Internal Services**
  - pfSense Web UI
  - Monitoring / dashboards
  - Future services (apps, containers, etc.)

The important rule:  
> The connector can reach internal services, but **no inbound ports** need to be exposed on the WAN.

---

## 🔐 Security Considerations

Some of the controls I rely on here:

- No port forwarding on the firewall for these services
- All access goes through:
  - Cloudflare Access (identity-aware)
  - Cloudflare Tunnel (mutual TLS between `cloudflared` and Cloudflare)
- I can add additional policy layers over time:
  - Restrict to certain emails
  - Restrict by country / IP range
  - Require MFA via identity provider

---

## 📎 Next Documents

- `03-cloudflare-zero-trust-setup.md` (planned)
  - Step-by-step Cloudflare configuration
- `04-pfsense-and-tunnel-config.md` (planned)
  - Local network + connector details
- `05-testing-and-troubleshooting.md` (planned)
  - How I verify everything works, and how I debug issues
