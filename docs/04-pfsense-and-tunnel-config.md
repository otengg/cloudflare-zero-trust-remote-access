# pfSense + Cloudflare Tunnel Integration

This document explains how I integrated my pfSense firewall with Cloudflare Tunnel to securely route traffic from the internet → Cloudflare → my private homelab services.

---

## 🧱 Network Overview (pfSense Side)

**Device:** Netgate 2100  
**OS:** pfSense Plus  
**Role:** Core firewall + router  
**WAN:** DHCP from ISP  
**LAN:** 10.0.10.0/24 (example)

The Cloudflare Tunnel connector runs on an **internal VM** sitting behind pfSense.

### Why not run cloudflared *on* pfSense?

- pfSense does not officially support Cloudflared
- The connector works best on a full Linux VM
- Linux VM gives better observability, logging, and control

---

# 1. Firewall Rules Needed

Because Cloudflare Tunnel is **outbound-only**, the firewall configuration is simple.

### Required outbound rules:

| Protocol | Port | Purpose                   |
|----------|------|---------------------------|
| TCP      | 7844 | Cloudflared → Cloudflare  |
| TCP      | 443  | Authentication + updates  |

### pfSense rule:

Go to:

**Firewall → Rules → LAN → Add**

Allow:

- Source: The VM running `cloudflared`
- Destination: `any`
- Ports: `443` and `7844`

This ensures the connector VM can reach Cloudflare’s edge.

---

# 2. Static DHCP Mapping (Optional but Recommended)

Give the Cloudflared VM a static IP:

Go to:

**Services → DHCP Server → LAN**

Add a static mapping:

- MAC Address: (VM’s MAC)
- IP Address: `10.0.10.x`  
- Description: Cloudflared Tunnel VM

This stabilizes your routing configuration.

---

# 3. Ensure Internal Services Are Reachable

Your Cloudflare Tunnel config will forward to internal IPs like:

- `https://10.0.10.1` (pfSense UI)
- `http://10.0.20.50:3000` (dashboard)

Make sure:

- pfSense does **NOT** block the connector VM from reaching these services
- Any VLANs or firewall rules allow the connector → target services

Example rule:

```
Action: Allow
Source: <Cloudflared VM IP>
Destination: <Internal Services / LAN>
Ports: Any (or restrict to 443/3000/etc)
Description: Allow Cloudflare Tunnel Connector
```
