# Testing & Troubleshooting – Cloudflare Zero Trust Remote Access

This document explains how I validate, monitor, and troubleshoot my Cloudflare Zero Trust remote access setup.  
These steps help confirm that DNS, Access policies, and the Cloudflare Tunnel are all working correctly end-to-end.

---

## ✔️ 1. Basic Connectivity Tests

Before testing Cloudflare pieces, verify foundational network connectivity.

### Test general internet access:

```bash
ping 1.1.1.1
ping google.com

If these fail:

pfSense may be blocking outbound traffic

DNS resolver on pfSense may be misconfigured

✔️ 2. Verify Tunnel Health

Run this on your cloudflared VM:

cloudflared tunnel info


Look for:

HEALTHY: true

Connections: 4

Active ingress rules

If unhealthy:

Check pfSense outbound firewall rules (ports 443 and 7844)

Confirm DNS works on the VM

Review /etc/cloudflared/config.yml

✔️ 3. Test DNS Resolution Through Cloudflare

On ANY device (your PC, phone, etc.):

nslookup pfsense.mydomain.com


Expected output:

A Cloudflare Anycast IP, NOT your home WAN IP

Example: 104.21.xxx.xxx

If you see your home IP:

Cloudflare proxy is OFF (toggle orange cloud to ON)

DNS record might not exist

DNS cache may need flushing:

ipconfig /flushdns

✔️ 4. Test Access Before Authentication

Visit your protected URL:

https://pfsense.mydomain.com


Expected behavior:

The Cloudflare Access login page appears

You must authenticate

After login, you're forwarded over the Tunnel

pfSense UI loads normally

If it loads without Access:

Your Access Application is misconfigured

Hostname might not match the application domain

You may be using HTTP instead of HTTPS (Access enforces HTTPS)

✔️ 5. Test Internal Reachability from the Connector

SSH into the cloudflared VM and run:

Test pfSense UI:
curl -I https://10.0.10.1 --insecure

Test another service:
curl -I http://10.0.20.50:3000


If these fail:

pfSense may be blocking the connector VM

VLAN firewall rules may be wrong

Service may not support HTTPS (or needs insecureSkipVerify)

✔️ 6. Test End-to-End Through Cloudflare Tunnel
curl -I https://pfsense.mydomain.com


Expected:

403 → Access is blocking you (expected if unauthenticated)

302 → Access redirect working

200 → Full authentication + tunnel path success

If you see 502 or 530:

Cloudflare can’t reach the origin (your internal service)

Wrong internal IP in config.yml

Service not running

Firewall rule blocking connector VM

✔️ 7. Reviewing Cloudflare Logs

Go to:

Zero Trust → Logs

You can inspect:

Access login logs (success/denied)

Tunnel connection activity

DNS queries

Application-level requests

This is the BEST place to confirm policies are applied correctly.

🚑 Common Issues & Fixes
❌ “Tunnel is unhealthy”

Fixes:

Allow outbound: TCP 443, 7844

Cloudflared VM has no internet

Wrong tunnel ID or bad credentials file

❌ DNS shows your WAN IP instead of Cloudflare

Fixes:

Turn ON Cloudflare proxy (orange cloud)

Delete and recreate CNAME record

Flush DNS cache

❌ Access login not showing

Fixes:

Check that Access Application domain EXACTLY matches the URL

Make sure HTTPS is used

Ensure Access policies include your email

❌ Access shows “Forbidden”

Fixes:

You’re excluded in the policy

Email identity mismatch

Policy does not “Allow” any valid identity group

🎉 Final Validation Steps

Your setup is fully correct if:

Access login screen appears

You can authenticate with allowed identity

Tunnel shows healthy

Internal services load but remain non-public

Your home WAN IP is never exposed

All inbound ports on pfSense remain closed