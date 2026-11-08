# NASA VDP - Subdomain Takeover Proof of Concept

Research PoC for a **dangling CNAME / subdomain takeover** reported under the
[NASA Vulnerability Disclosure Program](https://bugcrowd.com/engagements/nasa-vdp).

| | |
|---|---|
| Affected hostname | `beta.science.nasa.gov` |
| CNAME target | `nasa-smd.go-vip.net` |
| Provider platform | go-vip.net (WordPress VIP / Automattic enterprise hosting) |
| Class | Dangling CNAME - provider site is not provisioned |
| Report to | https://bugcrowd.com/engagements/nasa-vdp |

## What this page is

A benign, static proof-of-concept page. It contains:

- **no NASA branding or content**
- **no credential fields, forms, or login prompts**
- **no scripts, no external requests, no tracking, no cookies**
- a plain explanation of the vulnerability, how to reproduce it, and remediation

It exists solely to demonstrate that a hostname NASA controls
(`*.nasa.gov`) points at third-party infrastructure that an unauthorized
party can occupy.

## Reproduce it yourself

```bash
./reproduce.sh
```

Or manually:

```bash
dig +short CNAME beta.science.nasa.gov
# nasa-smd.go-vip.net.

curl -sk https://beta.science.nasa.gov/ | head -1
# 404 Not Found

curl -sk https://nasa-smd.go-vip.net/ | head -1
# 404 Not Found
```

The point is that `nasa-smd.go-vip.net` returns a bare nginx 404 **identical to
random unregistered hostnames** on that platform, while every provisioned NASA
site returns either the provider's branded "Site not found" page or live
content. The provider distinguishes the two; this hostname falls in the
unregistered class.

> Note: `go-vip.net` DNS is wildcarded - every random hostname resolves to a
> unique IP - so DNS resolution alone proves nothing. The finding rests on the
> HTTP response fingerprint.

## Remediation

1. Remove the `CNAME` record for `beta.science.nasa.gov`, **or**
2. Re-provision the `nasa-smd` site on the provider platform, **or**
3. Point the hostname at infrastructure NASA actually controls.

Also audit the remaining `*.nasa.gov` CNAME records for the same condition.

## Contact

NASA VDP: https://bugcrowd.com/engagements/nasa-vdp
NASA policy: https://www.nasa.gov/vulnerability-disclosure-policy/

*This repository contains no NASA data, no credentials, and no exploit code.*
