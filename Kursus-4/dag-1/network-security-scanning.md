# Network Security: Skanning og Sårbarhedsanalyse

I de følgende opgaver skal I prøve at skanne og kortlægge et netværk samt lave nogle sårbarhedsskanninger.

Opgaverne dækker følgende målpind:

> Lærlingen skal kunne evaluere netværkets sikkerhed gennem sårbarhedsscanning og penetrationstest herunder nødvendigheden af sikkerhedsopdateringer.

Først laver vi nogle skanninger. Derefter prøver vi at lave nogle basic pentests for at se, hvilke sårbarheder der kunne være på serverne.

## Nmap scanning

En scanning med Nmap anvendes til at kortlægge et netværk og identificere aktive systemer samt åbne porte.

Ved at sende pakker til en række porte på en målvært kan scanneren afgøre, hvilke services der er tilgængelige, og hvordan de responderer.

Under en typisk scanning vil værktøjet forsøge at etablere forbindelser til kendte porte såsom:

- `22` SSH
- `80` HTTP
- `443` HTTPS

Responsen analyseres for at afgøre, om porten er:

- åben
- lukket
- filtreret

En stealth scan kan anvendes til at minimere spor, hvor kun dele af en TCP-forbindelse gennemføres.

Resultatet af en Nmap-scanning giver et overblik over:

- hvilke services der kører på systemet
- hvilke porte der er eksponeret
- potentielle angrebspunkter

Nmap arbejder på netværksniveau.

## OSINT og sårbarhedsanalyse med SpiderFoot

En scanning med SpiderFoot fokuserer på at indsamle og analysere information om et mål gennem automatiserede OSINT-teknikker, Open Source Intelligence.

I modsætning til en portscanning arbejder SpiderFoot primært med offentligt tilgængelige data og relationer mellem systemer.

Ved en scanning undersøger værktøjet blandt andet:

- domæner og subdomæner
- IP-adresser og tilknyttede services
- eksponerede e-mails og brugere
- kendte sårbarheder og leaks

SpiderFoot kombinerer data fra mange kilder og visualiserer dem som et netværk af relationer.

Resultatet kan afsløre:

- fejlkonfigurationer
- eksponeret følsom information
- mulige indgangspunkter for angribere

SpiderFoot arbejder på informationsniveau, strategisk og OSINT-orienteret.

## Sårbarhedsscanning med OpenVAS

En scanning med OpenVAS, som er en del af GVM, går et skridt videre ved aktivt at teste systemer for kendte sårbarheder.

I modsætning til Nmap, som primært finder åbne porte, forsøger OpenVAS at afgøre, om en service er sårbar.

Under en scanning vil værktøjet:

- identificere services og versioner
- sammenligne med kendte sårbarheder, CVE'er
- udføre sikre test mod systemet

Resultatet giver:

- konkrete sårbarheder, for eksempel CVE-ID'er
- risikovurdering, severity
- forslag til mitigation

OpenVAS arbejder på sårbarhedsniveau og laver en dybere analyse.

## Sammenligning

| Værktøj | Fokus | Hvad finder det | Niveau |
| --- | --- | --- | --- |
| Nmap | Netværk | Porte og services | Teknisk |
| SpiderFoot | OSINT | Offentlig info og relationer | Strategisk |
| OpenVAS | Sårbarheder | Kendte exploits og CVE'er | Dyb analyse |

## Opgave 1: Installér OpenVAS

I denne opgave installerer vi OpenVAS på Kali-klienten. Hvis I bruger begge Kali-klienter, skal I gøre det på begge.

OpenVAS skal hente opdateringer fra internettet om nye CVE'er og exploits. Derfor installerer vi den først og lader den opdatere sig, mens vi laver de andre opgaver. Selve OpenVAS-skanningen fortsætter vi med i opgave 6.

Åbn Kali SSH i portalen og kør:

```bash
bash /opt/openvas/install.sh
```

Nu begynder installationen af OpenVAS. Scriptet åbner for de ting, der skal være til stede, og begynder at opdatere feeds.

Lad den blive færdig, inden I går videre med næste opgave. Husk at gøre det på begge Kali-maskiner, hvis I bruger begge.

## Opgave 2: OSINT-skanning med SpiderFoot

Nu skal vi prøve at skanne en URL med vores OSINT-skanner, som er indbygget i T-Pot-serveren.

1. Log ind på T-Pot GUI via portalen.
2. Vælg SpiderFoot.
3. Start med at skanne `example.com`.
4. Prøv derefter at skanne `scanme.nmap.org`.

SpiderFoot er et open source-produkt til at skanne URL'er og IP-adresser efter informationer og mulige sårbarheder.

`example.com` kan tage noget tid, da der er en del afhængigheder på denne URL. `scanme.nmap.org` kan også bruges i næste opgave til Nmap-skanning.

## Opgave 3: Kortlæg LAN1 og LAN2 med Nmap

Nu skal vi kortlægge LAN1- og LAN2-netværket og finde ud af, hvilke servere, services og porte der findes på de to netværk.

Til dette kan der bruges flere forskellige værktøjer, men i denne opgave bruger vi Nmap på `kali01` eller `kali02`.

Åbn Kali SSH via portalen.

I dette setup har vi allerede en topologi med informationerne. I en rigtig pentest eller skanning er det dog ikke sikkert, at man kender netværket på forhånd. Her kan `ipconfig`, `ifconfig` eller IP-informationer på den enhed, man sidder på, bruges til at finde netværket.

Lav først en ping sweep af LAN1 og LAN2:

```bash
nmap -sn 192.168.1.0/24
nmap -sn 192.168.2.0/24
```

Det giver et overblik over, hvilke IP-adresser der er aktive på netværket. Derefter kan vi begynde at skanne efter OS, services og porte.

Prøv at lave en skanning af T-Pot-serveren:

```bash
nmap -sS -T4 --top-ports 100 192.168.1.210
```

Denne kommando laver en stealth scan og skanner efter de 100 mest brugte porte.

Undersøg:

- hvilke porte der er åbne
- hvad de forskellige porte typisk bruges til
- hvilke services der ser interessante ud
- om der er noget, som ligner et potentielt angrebspunkt

Prøv også at lave en online Nmap-skanning mod:

```bash
nmap scanme.nmap.org
```

Se om der er information, der kan bruges i en sikkerhedsanalyse.

## Opgave 4: Opdag skanning i honeypot

Opgave 3 gik ud på at skanne. Nu tager vi sikkerhedsbrillerne på og undersøger, hvordan man kan opdage et skanningsangreb.

Der er forskellige metoder til at opdage et skanningsangreb, men det kan være svært, fordi trafikken ofte ligner almindelig legal trafik. IDS/IPS kan opdage nogle angreb, men ikke nødvendigvis alle.

I dette scenarie har vi lavet en skanning af en honeypot. Der vil normalt ikke være trafik hen mod den.

En honeypot er et system, der er sat op til at tiltrække eller registrere angribere. Den bruges til at opdage scanning, exploitation og anden mistænkelig aktivitet.

### Task

1. Åbn T-Pot GUI via portalen.
2. Gå ind under Kibana.
3. Kontrollér at tidsrummet i højre hjørne dækker tidspunktet, hvor skanningen blev lavet.
4. Undersøg om T-Pot har opdaget skanningen.
5. Find den klient, der skannede honeypotten.

## Opgave 5: Kør T-Pot testscript

Nu skal vi prøve at udnytte en eller flere af de sårbarheder eller services, vi har fundet med vores skanning af T-Pot.

Der er lavet et script til at simulere forskellige typer aktivitet mod T-Pot-serveren, blandt andet:

- skanning
- SSH-forsøg
- banner crawling

### Task

1. Åbn `KALI01` eller `KALI02` GUI.
2. Åbn T-Pot-mappen på skrivebordet.
3. Højreklik på `tpot-script.sh`.
4. Vælg åbn terminal her.
5. Kør scriptet:

```bash
./tpot-script.sh
```

Når scriptet er kørt, skal I undersøge, om der kommer alarmer i T-Pot-serveren under Kibana.

Man vil ofte placere honeypot-servere i et miljø for at få hackeren til at interagere med dem. Det er vigtigt, at de services, der ser åbne ud, giver mening i forhold til miljøet, for eksempel OT/IoT eller servermiljø.

## Opgave 6: OpenVAS-skanning

Nu skal vi lave en OpenVAS-skanning og se, hvilke sårbarheder den finder.

OpenVAS skulle gerne være færdig med at opdatere sit feed, som blev startet i opgave 1.

Åbn `kali01` eller `kali02` GUI via portalen og åbn en browser.

Gå til:

```text
https://localhost:9392
```

OpenVAS er installeret på Kali-klienten og kører en webservice, som kan tilgås lokalt på port `9392`.

Acceptér certificate warning.

Log ind med:

- brugernavn: `admin`
- password: `Password1!`

Her kan I se, om feedet er opdateret, eller om den stadig er i gang. Der kan ikke skannes, før feedet er færdigt med at opdatere. Hvis den ikke bliver færdig, kan opgaven laves senere i dag eller i morgen.

### Skanning

1. Gå ind under Tasks.
2. Vælg tryllestaven i venstre hjørne.
3. Vælg Task Wizard.
4. Indtast IP-adressen på `VULN-SRV01`.
5. Start skanningen.

Undersøg:

- finder den nogle CVE'er?
- hvilken severity har de?
- hvilke services er sårbare?
- hvilke forslag til mitigation giver OpenVAS?

Prøv derefter at skanne forskellige servere i miljøet.

Prøv også at starte Juice Shop Docker via portalen og skan igen.

Undersøg:

- finder OpenVAS Juice Shop-CVE'er?
- skanner den den port, Juice Shop bruger?
- hvis du ikke ved hvilken port Juice Shop bruger, så brug Nmap til at finde åbne porte.
