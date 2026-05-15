# Detect and Response: Løsninger

## Opgave 1: Klartekst-login

- Type: Cryptographic Failures / usikre credentials i klartekst
- Source IP: `192.168.1.70`
- Endpoint: `/login`
- Eksempler på body:
  - `username=student&password=Password1!`
  - `username=admin&password=Admin123!`

Filter i toppen efter `POST`.

## Opgave 2: Injection-angreb

- Type: Injection
- Source IP: `192.168.1.200`
- Endpoint-eksempler:
  - `/rest/products/search`
  - `/login`
- Payload-eksempler:
  - `' OR 1=1--`
  - `UNION SELECT`
  - `<script>alert(1)</script>`

OWASP beskriver Injection som en central kategori, hvor blandt andet SQL injection og XSS indgår.

## Opgave 3: Broken Access Control

- Source IP: `192.168.1.200`
- Mistænkelige paths:
  - `/admin`
  - `/api/v1/users`
  - `/api/v1/export?file=users.csv`
  - `/backup/customers.db`
  - `/internal/reports`
- Type: Broken Access Control / forced browsing

Broken Access Control er fremhævet som en topkategori i OWASP Top 10:2021.

## Opgave 4: Security Misconfiguration

- Source IP: `192.168.1.201`
- Eksempler på paths:
  - `/.git/config`
  - `/server-status`
  - `/phpinfo.php`
  - `/actuator/health`
  - `/actuator/env`
  - `/swagger-ui/index.html`
- Type: Security Misconfiguration
- IOC: systematisk probing mod debug-, status- og konfigurationsendpoints

## Opgave 5: Sårbare eller forældede komponenter

- Source IP: `192.168.1.202`
- Eksempler på paths:
  - `/vendor/phpunit/phpunit/src/Util/PHP/eval-stdin.php`
  - `/cgi-bin/test.cgi`
  - `/wp-content/plugins/revslider/readme.txt`
  - `/jmx-console/`
  - `/solr/admin/info/system`
  - `/HNAP1/`
  - `/struts2-showcase/index.action`
- Type: Vulnerable and Outdated Components
- Forensic pointe: dette viser målrettet rekognoscering efter kendte svage komponenter

## Bonusopgave: Port scanning

Brug filteret:

```wireshark
tcp.flags.syn == 1 and tcp.flags.ack == 0
```

Der ses mange porte fra:

- Source IP: `192.168.1.200`
