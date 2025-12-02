#!/bin/bash

echo "=== Cloudflare Zero Trust Connectivity Check ==="

echo
echo "[1] DNS lookup via Cloudflare:"
nslookup pfsense.mydomain.com || echo "DNS lookup failed"

echo
echo "[2] HTTPS via Cloudflare (public hostname):"
curl -I https://pfsense.mydomain.com || echo "HTTPS test failed"

echo
echo "[3] Check cloudflared tunnel status (on connector VM):"
systemctl status cloudflared --no-pager || echo "cloudflared service check failed"

echo
echo "Done."
