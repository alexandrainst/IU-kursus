# Network Security: Skanning og Sårbarhedsanalyse: Løsninger

## Opgave 1: Installér OpenVAS

### Forventet resultat

OpenVAS installeres på Kali-klienten med:

```bash
bash /opt/openvas/install.sh
```

Efter installationen skal OpenVAS hente og opdatere feeds. Skanninger kan først køres, når feed-opdateringen er færdig.

### Kontrolpunkter

- OpenVAS/GVM webinterface kan åbnes på `https://localhost:9392`.
- Login virker med `admin` og `Password1!`.
- Feed status viser, om systemet er klar til skanning.

## Opgave 2: OSINT-skanning med SpiderFoot

### Forventet resultat

Eleverne skal kunne starte en SpiderFoot-skanning fra T-Pot GUI mod:

- `example.com`
- `scanme.nmap.org`

### Analysepunkter

SpiderFoot kan finde og visualisere:

- domæneinformationer
- IP-adresser
- relationer mellem systemer
- offentligt tilgængelige data
- mulige fejlkonfigurationer eller eksponeringer

### Pointe

SpiderFoot er ikke det samme som en portscanner. Det arbejder primært med OSINT og relationer mellem offentlige data.

## Opgave 3: Kortlæg LAN1 og LAN2 med Nmap

### Kommandoer

Ping sweep af LAN1 og LAN2:

```bash
nmap -sn 192.168.1.0/24
nmap -sn 192.168.2.0/24
```

Skanning af T-Pot:

```bash
nmap -sS -T4 --top-ports 100 192.168.1.210
```

Online testmål:

```bash
nmap scanme.nmap.org
```

### Forventet resultat

Eleverne skal finde:

- aktive hosts på `192.168.1.0/24`
- aktive hosts på `192.168.2.0/24`
- åbne porte på `192.168.1.210`
- services der kan undersøges nærmere
- forskellen på host discovery og port/service-skanning

### Analysepunkter

Spørg eleverne:

- Hvilke porte var åbne?
- Hvad bruges portene normalt til?
- Var portene forventede i miljøet?
- Hvilke services ville være interessante i en pentest?
- Hvilke services ville være interessante at overvåge defensivt?

## Opgave 4: Opdag skanning i honeypot

### Forventet resultat

T-Pot/Kibana bør vise aktivitet mod honeypotten, hvis tidsrummet er sat korrekt.

Eleverne skal kunne finde:

- tidspunkt for skanningen
- source IP for klienten der skannede
- destination IP for honeypotten
- eventuelle events eller dashboards der viser scanning eller probes

### Konklusion

Skanning mod en honeypot er mistænkelig, fordi honeypotten normalt ikke bør have legitim trafik.

En mulig defensiv handling er at identificere klienten og isolere den fra netværket eller undersøge den nærmere.

## Opgave 5: Kør T-Pot testscript

### Kommando

Scriptet køres fra T-Pot-mappen på Kali:

```bash
./tpot-script.sh
```

### Forventet resultat

Scriptet simulerer forskellige typer aktivitet, for eksempel:

- skanning
- SSH-forsøg
- banner crawling

Efter scriptet er kørt, bør der kunne ses alarmer eller events i T-Pot/Kibana.

### Analysepunkter

Eleverne skal undersøge:

- hvilke typer events der opstår
- hvilken source IP der står bag aktiviteten
- hvilke services der blev ramt
- om aktiviteten ligner rekognoscering, brute force eller exploitation

### Pointe

Honeypots kan give tidlige signaler om angreb, men de skal placeres troværdigt i miljøet. Services og placering skal give mening, ellers kan en angriber mistænke, at systemet er en honeypot.

## Opgave 6: OpenVAS-skanning

### Adgang

OpenVAS åbnes i browseren på Kali:

```text
https://localhost:9392
```

Login:

- brugernavn: `admin`
- password: `Password1!`

### Forventet arbejdsgang

1. Kontrollér at feeds er færdigopdaterede.
2. Gå til Tasks.
3. Vælg Task Wizard.
4. Indtast IP-adressen på `VULN-SRV01`.
5. Start skanningen.
6. Gennemgå fundene.

### Analysepunkter

Eleverne skal kigge efter:

- CVE-ID'er
- severity
- påvirket service
- port
- beskrivelse af sårbarheden
- anbefalet mitigation

### Juice Shop

Hvis Juice Shop startes via portalen, skal eleverne først sikre sig, hvilken port den kører på.

Hvis OpenVAS ikke finder Juice Shop-relaterede fund, kan årsagen være:

- porten er ikke med i den valgte scan config
- servicen er ikke identificeret korrekt
- OpenVAS har ikke en relevant test for den konkrete applikation
- feedet er ikke færdigopdateret

Brug Nmap til at bekræfte åbne porte:

```bash
nmap -sV <target-ip>
```

### Konklusion

Nmap bruges til at finde hosts, porte og services. SpiderFoot bruges til OSINT og relationer. OpenVAS bruges til at koble services og versioner til kendte sårbarheder og mitigation.
