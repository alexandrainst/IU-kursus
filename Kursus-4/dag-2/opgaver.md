
For generelt forklaring af juiceshop-opgaver, se 
<https://github.com/alexandrainst/IU-kursus/blob/main/Kursus-3/dag-2/opgaver.md>.

# Zed Attack Proxy (ZAP)

Denne opgave underbygger målepinden

> 2. Lærlingen kan identificere og implementere foranstaltninger til at
>    beskytte applikationer mod angreb, herunder brug af Web-Proxy
>    løsninger, samt udføre logging, overvågning og penetrationstest.

ZAP er en webproxy man kan bruge til at penteste, analysere og angribe hjemmesider.

## Opgave 0

1. Åben ZAP på Kali'en, `zapproxy`

2. Tilgå vulnsrv1 med `ssh` og start docker compose-filen i `/opt/juiceshop-waf`
   - check at der ikke kører nogen juiceshop-containere i forvejen med `docker ps`
   - hvis der gør, så luk dem
   - start `juiceshop-waf`-containerne med kommandoen `(cd /opt/juiceshop-waf && docker compose up -d)`

3. Sørg for, at der kører en wazuh-agent på vulnsrv1 og at den opsamler de logs der er i `/opt/juiceshop-waf/logs`, dvs. tilføj følgende til `/var/ossec/etc/ossec.conf`

```
<ossec_config> 
  <localfile>
    <log_format>syslog</log_format>
    <location>/opt/juiceshop-waf/logs/access.log</location>
  </localfile>

  <localfile>
    <log_format>syslog</log_format>
    <location>/opt/juiceshop-waf/logs/error.log</location>
  </localfile>
</ossec_config> 
```

I det næste opgaver skal vi bruge `172.20.0.10:3010` for at tilgå juiceshop. Så kan vi se vores aktivitet blive logget i Wazuh.

## Opgave 1

1. Kør ZAP's automatiserede scanning på `http://172.20.0.10:3010`. Vælg scan policy 'Pen Test', 'use traditional spider' og 'if modern' med 'firefox headless'.

2. Kig i gennem dens resultater
  - Hvilke undersider finder den?
  - Hvilke sårbarheder finder den?

3. Kig i gennem Wazuhs events
  - Hvad bliver logget?
  - Hvad betyder det i praksis?

## Opgave 2

Brug ZAPs kortlægning til at løse juiceshop-opgaven 'Confidential Document'.
Bemærk, at hvis man ikke clearer cookies, så vil ZAPs scanning have 'løst' opgaven automatisk

<details>
<summary>Hints</summary>

1. Led efter filer der lyder hemmelige i de URL'er som ZAP har fundet

2. Måske under `/ftp`?
</details>

## Opgave 3 (Christmas Special)

Brug ZAPs SQL-injection-alert til at løse følgende JuiceShop-opgaven Christmas Special.

En nem fremgangsmåde at 'teste' forskellige SQL-injections, er at 
1) find SQL-injection-URL'en under 'Alerts' i ZAP
2) højreklik på 'Request'-vinduet i 'request-response'-vinduet
3) vælg 'Open in Requester-tab'
4) Nu kan du redigere i requesten og så trykke 'Send' for at se hvordan det ændrer responsen

Formålet med opgaven er, at lykkes med at bestille et produkt som
ellers burde være udgået.

<details>
<summary>Hints:</summary>

1. Find ud af hvad endpointet der har en SQL-injection returnerer

2. Hvordan kan man få responsen til at inkludere udgåede varer?

3. Brug injection-strengen `'))--` til at få returneret alle varer inklusive udgåede produkter i responsen

4. For at få tilføjet det udgåede produkt til din kurv skal du konstruere et manuel POST request til `/api/BasketItems` (her kan du bruge ZAP el BurpSuite)
</details>

## Opgave 4 (Database Schema)

Brug ZAPs SQL-injection-alert til at løse følgende JuiceShop-opgaven Database Schema.

Formålet med opgaven er, at lykkes med at udtrække 'Database Schema'
for den bagvedliggende database.
Grunden til at det er interessant er, at hvis man kender 'Database
Schema', så kan man slå al information op i database (via injection)
uden at skulle gætte sig til hvad specifikke tabeller hedder.

*Denne opgave kræver lidt viden om SQL, skip evt til næste opgave*

<details>
<summary>Hints:</summary>

1. Først find ud af at der en tabel der indeholder
database-information (Database Schema), ved at bruge, at vi kender
Database-typen (SQLite fra fejlbeskeder). Navnet på den tabel kan
findes her: https://www.sqlite.org/faq.html

2. Brug denne information til at lave et såkaldt `UNION
SELECT`-angreb, ved at bruge injection-strengen `')) UNION SELECT *
FROM $SCHEMA_TABLE--` hvor `$SCHEMA_TABLE` er den tabel der
indeholder Database Schema. Dette giver en ny type fejl.

3. Fejlen
```
SQLITE_ERROR: SELECTs to the left and right of UNION do not have the same number of result columns
```
indikerer, at vi skal 'gætte' hvor mange kolonner i
'Products'-tabellen som det venstre SELECT vælger fra. Vi kan bare
prøve os frem een ad gangen (eller se hvor mange indgange hvert
element har når vi får en almindelig respons)

4. Vi kan komme frem til følgende injection-streng 
`')) UNION SELECT '1', '2', '3', '4', '5', '6', '7', '8', '9' FROM sqlite_master--`

5. For at få fjernet det 'venstre' select, skal vi sørge for, at vi ikke matcher nogle produkter, eg med strengen
`foo')) UNION SELECT '1', '2', '3', '4', '5', '6', '7', '8', '9' FROM sqlite_master--`

6. Tilsidst, kan vi skifte kolonnenavne ud med rigtige kolonnenavne fra `sqlite_master`
`foo')) UNION SELECT type, name, tbl_name, rootpage, sql, '6', '7', '8', '9' FROM sqlite_master--`
</details>

## Opgave 5

Opsæt authentication.

1. Åben en browser via toolbaren i ZAP, opret en bruger og log ind.
2. Gå ind i File > Session Properties > Authentication 
3. Vælg 'Form-based Authentication' og find login-URL'en
4. Prøv at køre et nyt scan med authentication sat til

# Web Application Firewall

Denne opgave underbygger målepinden

> 2. Lærlingen kan identificere og implementere foranstaltninger til at
>    beskytte applikationer mod angreb, herunder brug af Web-Proxy
>    løsninger, samt udføre logging, overvågning og penetrationstest.

ModSecurity er en WAF man kan bruge til at beskytte sin hjemmeside
eller web-applikation mod kendte angrebsmønstre. CRS er et standard
sæt af regler til ModSecurity som beskytter mod en bred række af
angreb.

## Opgave 0

1. Ret docker-compose.yml til så den indeholder følgende opsætning af `owasp/modsecurity-crs:nginx` containeren:
```
  juice-waf:
    image: owasp/modsecurity-crs:nginx
    container_name: juice-waf
    user: root
    ports:
      - "3020:8080"
    environment:
      BACKEND: http://juice-shop:3000
      ERRORLOG: "/var/log/waf/error.log"
      ACCESSLOG: "/var/log/waf/access.log"
      MODSEC_AUDIT_LOG_FORMAT: Native
      MODSEC_AUDIT_LOG_TYPE: Serial
      MODSEC_AUDIT_LOG: "/var/log/waf/modsec_audit.log"
    volumes:
      - ./logs-waf/:/var/log/waf
      - ./exclusions.conf:/etc/modsecurity.d/owasp-crs/rules/REQUEST-900-EXCLUSION-RULES-BEFORE-CRS.conf:ro
    depends_on:
      - juice-shop
```
og sørg for at filen `/opt/juiceshop-waf/exclusions.conf` eksisterer og indeholder følgende
```
SecRule REQUEST_URI "@beginsWith /socket.io/" "id:1000001,phase:1,pass,nolog,ctl:ruleEngine=Off"
```

Dette sørger for at ModSecurity ignorerer `/socket.io/`, som primært
bruges til at opdatere status på challenges.

2. Sørg for at der kører en wazuh-agent på vulnsrv1 og at den opsamler
   de logs der er i `/opt/juiceshop-waf/logs-waf`, dvs. tilføj følgende
   til `/var/ossec/etc/ossec.conf`

```
<ossec_config> 
  <localfile>
    <log_format>syslog</log_format>
    <location>/opt/juiceshop-waf/logs-waf/error.log</location>
  </localfile>
</ossec_config> 
```

I det næste opgaver skal vi bruge `172.20.0.10:3020` for at
illustrerer hvordan WAF'en fungerer.

## Opgave 1

Start WAF-docker på vulnsrv1

- Tilgå `vulnsrv1` via `ssh`
- Tjek at der ikke allerede kør nogle docker-processer med `docker ps`
- Hvis der allerede kører docker-processer så sluk dem med `docker compose down`
- Gå til `/opt/juiceshop-waf` og start docker med `docker compose up -d`

## Opgave 2 - Injection

Forsøg at løse juiceshop-opgaven *Login Admin* med en SQL-injection.

<details>
<summary>Hints:</summary>

1. Log ind med `admin@juice-sh.op' OR 1=1--` og vilkårligt kodeord
</details>

Find ID'et på den regel der blokerer for angrebet i loggen (Wazuh eller direkte i log-filerne) 
Find denne regel på github <https://github.com/coreruleset/coreruleset/tree/main/rules>, for at se hvordan/hvorfor den blev triggered

## Opgave 3 - XSS (DOM)

Forsøg at løse juiceshop-opgaven *XSS DOM*

<details>
<summary>Hints:</summary>

1. Søg efter strengen `<iframe src="javascript:alert('xss')">`
</details>

Hvorfor bliver dette XSS-angreb ikke blokeret?

## Opgave 4 - XSS (Persisted/Stored)

Forsøg at løse juiceshop-opgaven *Client-side XSS Protection*

<details>
<summary>Hints:</summary>

1. Opret en bruger med emailen `<iframe src="javascript:alert('xss')">` 

2. Du er nødt til at aktivere knappen i webinterfacet, eller omgå webinterfacet ved at bruge Burp/ZAP/Postman/cURL
</details>

Find ID'et på den regel der blokerer for angrebet i loggen (Wazuh eller direkte i log-filerne) 
Find denne regel på github <https://github.com/coreruleset/coreruleset/tree/main/rules>, for at se hvordan/hvorfor den blev triggered

## Opgave 5 - Falske positiver

Prøv at få et hint til en opgave på `/#/score-board` (ved at trykke på et af de små lyspære-ikoner under opgavebeskrivelserne).
ModSecurity blokerer for den funktionalitet fordi den tror det er et angreb. Dette er et eksempel på en såkaldt *falsk positiv*.

For at undgå denne er vi nødt til at *tune* vores opsætning af WAF'en.
- Gå ind i Wazuh og find ud af hvad det er for en regel der blokerer for vores "hints"
- Gå ind i Wazuh og find ud af hvilken URI det er der bliver blokeret
- ssh ind på vulnsrv1, rediger `/opt/juiceshop-waf/exclusions.conf` og tilføj linjen
```
SecRule REQUEST_URI "@beginsWith $URI" "id:1000002,phase:1,pass,nolog,ctl:ruleRemoveById=$ID"
```
hvor du indsætter det korrekte `$URI` og regel-`$ID`.

Genstart docker med `(cd /opt/juiceshop-waf && (docker compose down; docker compose up -d))` og test at hint-funktionaliteten virker igen.

Du kan læse mere om falske positiver og tuning af CRS her: 
<https://coreruleset.org/docs/2-how-crs-works/2-3-false-positives-and-tuning/>

# SBOM og sårbarhedsscanning

Denne opgave underbygger målepinden

> 4. Lærlingen kan bidrage til sikkerhedsrevision og dokumentation, samt
>    forklare og anvende Software Bill of Materials (SBOM) og Data Loss
>    Protection (DLP).

## Opgave 1

Installer syft på vulnsrv1 med følgende kommando
```
curl -sSfL https://get.anchore.io/syft | sudo sh -s -- -b /usr/local/bin
```

Scan nogle docker containere ved at køre følgende kommandoer
- `syft bkimminich/juice-shop:latest`
- `syft nginx:alpine`
- `syft owasp/modsecurity-crs:nginx`
- `syft owasp/modsecurity-crs:apache-alpine`

## Opgave 2

Generer forskellige SBOM-formater og sammenlign dem f.eks.

1. `syft -o cyclonedx-json nginx:alpine > cyclonedx.sbom`
2. `syft -o spdx-json nginx:alpine > spdx.sbom`
3. `syft -o json nginx:alpine > json.sbom`

## Opgave 3

Installer grype vulnsrv1 med følgende kommando
```
curl -sSfL https://get.anchore.io/grype | sudo sh -s -- -b /usr/local/bin
```

Scan nogle docker containere ved at køre følgende kommandoer
- `grype bkimminich/juice-shop:latest`
- `grype nginx:alpine`
- `grype owasp/modsecurity-crs:nginx`
- `grype owasp/modsecurity-crs:apache-alpine`

## Opgave 4

Den docker der kører JuiceShop+ModSecurity+CRS bruger containeren
`owasp/modsecurity-crs:nginx`. Burde man måske bruge
`owasp/modsecurity-crs:apache-alpine` i stedet?

## Opgave 5

Slå nogle af de CVE'er I fandt i de forrige opgaver op på internettet,
f.eks på <https://nvd.nist.gov/vuln>

# Ekstra JuiceShop-opgaver

Følgende er ekstra juiceshop-opgaver. Prøv evt både at løse dem på
NGINX (port 3010) og på WAF'en (port 3020), for at se hvilke der
bliver korrekt blokeret.

Hvis et angreb bliver blokeret prøv desuden at slå det regel-ID op som
blokerer for angrebet. Dette ID kan du finde enten i Wazuh eller
direkte i WAF-logfilerne. Reglen kan slås op på Github under
<https://github.com/coreruleset/coreruleset/tree/main/rules>.

## Opgave 1 - XSS (Reflected)

<details>
<summary>Hints:</summary>

1. Du skal være logget ind som en bruger

2. Når du opretter en addresse, så bliver den indsat som HTML 

3. Du kan indsætte et XSS i dine gemte addresser 
</details>

## Opgave N

Løs opgaver fra
<https://github.com/alexandrainst/IU-kursus/blob/main/Kursus-3/dag-2/opgaver.md>
som du ikke nåede sidst.

