# Endpoint Security: Log Analyse: Løsninger

## Opgave 1: Importér logs

Scriptet der skal køres på `VULN-SRV01`:

```bash
bash /opt/install.sh
```

Scriptet installerer Wazuh-agenten, forbinder serveren med Wazuh og henter 3 måneders autogenererede logs med normale og farlige hændelser.

## Opgave 2: SSH brute force

### Konklusion

- Angriber IP: den IP der gentager loginforsøg
- Target bruger: den bruger der forsøges logget ind på
- Login lykkedes: ja, hvis `Accepted password` findes
- Tidslinje:
  - Start: første `Failed password`
  - Slut: `Accepted password`

### Forklaring

Dette er et klassisk MITRE ATT&CK `T1110` Brute Force:

- mange loginforsøg tyder på password guessing
- samme IP tyder på én angriber
- gentagne fejl viser forsøg på at gætte adgangskode
- succes til sidst betyder, at adgang er opnået

Derfor:

- først Brute Force (`T1110`)
- derefter Valid Accounts (`T1078`)

## Opgave 3: IDS-alarmer

### Konklusion

- Alert-type: `ET WEB_SERVER SQL Injection Attempt`
- Severity: `3`
- Source IP: den IP der genererer flest alerts
- Destination IP: den server der bliver angrebet
- Type af angreb: SQL Injection

### Forklaring

Dette matcher flere teknikker fra MITRE ATT&CK:

- `T1046` Network Service Discovery, for eksempel Nmap scan
- `T1190` Exploit Public-Facing Application, for eksempel SQL Injection

Der ses flere forskellige typer alarmer fra samme aktivitet:

- scan, for eksempel Nmap
- exploit-forsøg, for eksempel Shellshock
- webangreb, for eksempel SQL Injection

Kombinationen af flere alerts viser, at en angriber tester systemet, forsøger kendte exploits og udfører konkrete angreb mod applikationen.

Derfor:

- først reconnaissance/scanning (`T1046`)
- derefter exploit-forsøg (`T1190`)

Dette indikerer en aktiv angriber og ikke bare en falsk positiv.

## Opgave 4: Sudo-aktivitet

### Konklusion

- Bruger: `ubuntu`
- Kommando: `/usr/bin/tee -a /opt/wazuh-replay/suricata_eve.json`
- Tidspunkt: omkring `Apr 19 06:38:08-06:38:11`
- Mistænkelig aktivitet: muligvis, men ikke entydigt ondsindet

Brugeren kører en kommando som root via `sudo`. Aktiviteten gentages mange gange på kort tid. Det kan være automatiseret log replay eller administration, men bør undersøges nærmere.

### Forklaring

Dette matcher især `T1059` Command and Scripting Interpreter.

Det kan i nogle tilfælde være relateret til misbrug af privilegerede rettigheder, men loggen viser ikke tydeligt klassisk privilege escalation som for eksempel `/bin/bash` eller `su`.

Det interessante er:

- en almindelig bruger udfører en kommando som root
- samme kommando køres mange gange
- der skrives til en fil med Suricata-data

Derfor observeres først brug af `sudo` til root. Derefter vurderes det, om kommandoen og mængden af aktivitet virker normal. Dette er en opgave i analyse og vurdering, ikke en sikker kompromittering.

## Opgave 5: Samlet angrebskæde

### Konklusion

- Angriber IP: den IP der går igen i alle logs
- Endelig impact: adgang til systemet via valid account

Tidslinje:

1. Scan, Suricata/Nmap
2. Webangreb, SQL Injection
3. Loginforsøg, SSH brute force
4. Login-succes

Fuldt angreb:

```text
Scan -> Exploit -> Access -> Privilege escalation
```

### Forklaring

Dette er en klassisk attack chain:

1. `T1046` Network Discovery, scan
2. `T1190` Exploit Public-Facing Application, webangreb
3. `T1110` Brute Force, loginangreb
4. `T1078` Valid Accounts, login-succes
5. `T1059` Execution / Privilege escalation

## Opgave 6: Web logs i archives

### Konklusion

- Angrebstype: SQL Injection
- Source IP: IP'en der sender requesten
- Endpoint: `/rest/products/search`
- Ondsindet request: `/rest/products/search?q=' OR 1=1--`

Bekræft:

- gentagne forsøg fra samme IP
- variationer af samme payload

### Forklaring

Dette er MITRE ATT&CK `T1190` Exploit Public-Facing Application.

Input manipulation med `OR 1=1` er klassisk SQL injection. Web-endpointet bliver misbrugt, og angriberen forsøger at omgå logik eller hente data. Det er typisk et tidligt trin i et angreb, ofte Initial Access.
