#!/usr/bin/env bash
# Reproduce the dangling CNAME on beta.science.nasa.gov
# Read-only. Makes no changes and does not register anything.
set -u
echo "=== DNS chain ==="
echo "-- CNAME --"; dig +short CNAME beta.science.nasa.gov
echo "-- A     --"; dig +short A     beta.science.nasa.gov
echo
echo "=== Subject vs controls on the provider platform ==="
for h in nasa-smd.go-vip.net nasa-gov.go-vip.net nasa-hc.go-vip.net nasa-tv.go-vip.net \
         "zz$(date +%s%N).go-vip.net"; do
  printf '%-34s ' "$h"
  curl -sk --max-time 15 "https://$h/" | tr -d '\n' | sed 's/[[:space:]]\+/ /g' | cut -c1-70
  echo
done
echo
echo "=== Body fingerprint comparison ==="
for h in nasa-smd.go-vip.net "zz$(date +%s%N).go-vip.net"; do
  printf '%-34s sha256=%s\n' "$h" \
    "$(curl -sk --max-time 15 "https://$h/" | sha256sum | cut -c1-32)"
done
echo
echo "If the subject fingerprint equals the random control fingerprint, the"
echo "provider site is unclaimed and the CNAME is takeable."
