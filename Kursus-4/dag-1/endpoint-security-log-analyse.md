# Endpoint Security: Log Analyse

I de næste opgaver skal I kigge på logs og finde hændelser, som er sket på et endpoint eller i et logsystem.

Følgende målpinde er i fokus:

> Lærlingen kan identificere indikatorer på kompromittering, anvende loganalyse og gennemføre forensic analyser for at identificere sikkerhedstrusler.

> Lærlingen kan overvåge og analysere endpoint-logs samt anvende data fra EDR, SIEM, XDR og SOC til at identificere mistænkelig aktivitet.

Opgaverne skal øve jer i at søge efter og analysere hændelser i et SIEM eller logsystem. Der er genereret 3 måneders logs til opgaverne, som skal importeres først.

## Opgave 1: Importér logs

Denne opgave går ud på at importere logs ind i `VULN-SRV01`, så der er noget at arbejde med i de næste opgaver.

Log ind på `VULN-SRV01` via SSH på portalen og kør scriptet:

```bash
bash /opt/install.sh
```

Scriptet installerer Wazuh-agenten på serveren, forbinder den med Wazuh-serveren og henter 3 måneders autogenererede logs med både normale og farlige hændelser.

## Opgave 2: SSH brute force

Nu hvor der er logs i Wazuh, skal vi kigge dem igennem for farlige ting. Normalt vil man opsætte alarmer eller IOC'er til at opdage det, men i dette scenarie skal du manuelt lede efter en hændelse.

### Scenario

En server har oplevet mistænkelig login-aktivitet.

Sikkerhedsteamet mistænker et brute force-angreb med SSH.

### Identificér

- angriberens IP-adresse
- hvilken bruger der blev angrebet
- om login lykkedes
- tidslinjen for angrebet

### Hints

1. Gå til Discover og søg på enten `sshd` eller `failed login`.
2. Filtrér efter `full_log` og `rule.description` under Available fields i venstre side.
3. Kig efter mange gentagne login-fejl fra samme IP ved at tilføje `data.srcip` under Available fields. Tryk på Top 5 values og vælg den med flest hits.
4. Se om der senere optræder en `Accepted password`. Du kan holde musen over en `sshd: authentication failed` under `rule.description` og trykke på minus for at vælge alle andre værdier end den.

## Opgave 3: IDS-alarmer

Nu hvor der er IDS-logs i Wazuh, skal vi analysere dem for at finde ud af, om der er tegn på et aktivt angreb.

Normalt vil man arbejde med alarmer og automatiske detection rules, men i dette scenarie skal du manuelt undersøge logs fra IDS-systemet.

### Scenario

IDS-systemet, Suricata, har registreret flere sikkerhedsalarmer.

Sikkerhedsteamet mistænker, at der er en aktiv angriber på netværket.

### Identificér

- alert-type
- source og destination IP
- severity
- type af angreb

### Hints

1. Gå til Discover og søg på `rule.groups:suricata`. Det giver en oversigt over logs, som indeholder Suricata IDS/IPS-data.
2. Filtrér efter `rule.description`, `rule.level` og `full_log` under Available fields i venstre side. Det giver et overblik over, hvilke typer angreb IDS/IPS har opdaget.
3. Kig på hvilke alerts der optræder, og brug Top values på `rule.description` for at finde den type, der forekommer flest gange.
4. Udvid loglinjerne og find source og destination IP i `full_log`. Identificér også den mest hyppige alert-type. Source og destination IP ligger i selve logindholdet og kan derfor være nødvendige at søge efter i `full_log`.

## Opgave 4: Sudo-aktivitet

Nu hvor vi har kigget på både login-forsøg og IDS-alarmer, skal vi undersøge brug af `sudo` i systemlogs.

Normalt vil sikkerhedsteamet kigge efter usædvanlig brug af administrative rettigheder, fordi det kan være tegn på misbrug eller post-exploitation. I dette scenarie skal du analysere sudo-logs og vurdere, om aktiviteten virker mistænkelig.

### Scenario

En bruger har kørt flere kommandoer med `sudo` på systemet.

Sikkerhedsteamet vil undersøge, om brugen af root-rettigheder virker normal eller mistænkelig.

### Identificér

- hvilken bruger der kørte kommandoen
- hvilken kommando der blev kørt som root
- hvornår det skete
- om aktiviteten virker mistænkelig

### Hints

1. Gå til Discover og søg på `sudo`. Find det felt, der kan bruges til at filtrere på sudo, for eksempel `predecoder.program_name`.
2. Filtrér efter `full_log` og `rule.description` under Available fields i venstre side.
3. Kig efter logs hvor der står `Successful sudo to ROOT executed`, og find værdierne ved `USER=root` og `COMMAND=`.
4. Filtrér på `full_log:"COMMAND=/usr/bin/tee"`. Kig på tidsstemplerne i loggene. Hvis den samme kommando bliver kørt mange gange inden for få sekunder, tyder det på automatiseret eller usædvanlig aktivitet.

## Opgave 5: Samlet angrebskæde

Nu skal vi samle alle logs og analysere et muligt angreb på tværs af flere systemer.

Normalt vil et sikkerhedsteam korrelere logs fra flere kilder for at identificere en angribers adfærd. I dette scenarie skal du finde hele angrebskæden fra start til slut.

### Scenario

En angriber kan have:

- scannet netværket
- angrebet en webapplikation
- forsøgt at få adgang til systemet

Sikkerhedsteamet vil bekræfte, om dette er én sammenhængende angrebskæde.

### Identificér

- angriberens IP
- angrebets faser
- tidslinje
- endelig impact

### Hints

1. Start i Discover med at finde IDS-logs: `rule.groups:ids`.
2. Kig i `rule.description` og find tegn på scanning, for eksempel Nmap.
3. Find derefter samme IP i web logs. Brug for eksempel `full_log`. Kig efter tegn på webangreb, for eksempel SQL injection.
4. Søg på samme IP i SSH logs, for eksempel `sshd` eller login-fejl. Bekræft om der er brute force og eventuel login-succes.

## Opgave 6: Web logs i archives

Denne opgave kan være sværere, fordi den kræver, at Wazuh viser alle logs og ikke kun alerts.

Før vi kan løse opgaven, skal Wazuh sættes op til at liste archive logs. Tidligere opgaver kunne løses via alerts, men denne opgave er baseret på almindelig trafik, som Wazuh ikke nødvendigvis ser som en alert.

### Opsæt archive logs

1. I Wazuh: tryk på menuen i venstre hjørne.
2. Gå til Dashboards Management.
3. Gå til Index patterns.
4. Vælg Create index pattern.
5. Skriv `wazuh-archives-*` og tryk Next.
6. Under Time field vælges `timestamp`.
7. Vælg Create.

Nu kan du se alle logs, som endpoint-agenten har registreret. Gå til Discover og vælg `wazuh-archives-*` som index pattern.

### Scenario

En webapplikation, OWASP Juice Shop, viser usædvanlig trafik.

Der er mistanke om et injection-angreb.

### Identificér

- type af angreb
- den ondsindede request
- kilde-IP
- hvilket endpoint der blev angrebet

### Hints

1. Gå til Discover og filtrér på web logs, for eksempel `apache` eller `nginx`.
2. Tilføj `data.url` under Available fields. Kig efter usædvanlige query strings i requests.
3. Tilføj `data.srcip` og brug Top values. Find en IP, der sender mange ens eller lignende requests.
4. Filtrér på følgende request i `data.url`: `/rest/products/search?q=' OR 1=1--`.
