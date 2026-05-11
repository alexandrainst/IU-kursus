# Detect and Response

I de næste opgaver skal I arbejde med pcap-filer og forskellige værktøjer til at finde og analysere hændelser i netværkstrafik.

Følgende målpinde er i fokus:

> Lærlingen kan identificere indikatorer på kompromittering, anvende loganalyse og gennemføre forensic analyser for at identificere sikkerhedstrusler.

> Lærlingen kan anvende AI og Machine Learning samt implementere automatiserede responssystemer for at styrke detektion og reaktionstid.

Opgaverne foregår på `kali01` eller `kali02`. Der ligger en pcap-fil på skrivebordet under mappen `wireshark`.

## Opgave 1: Klartekst-login

### Scenario

Der er mistanke om, at brugere sender credentials usikkert over netværket.

### Task

Find:

- hvilken type sikkerhedsproblem der ses
- source IP
- endpoint
- hvilke credentials der sendes i klartekst

### Hints

1. Filtrer på `http.request.method == "POST"`.
2. Kig efter trafik mod `/login`.
3. Se efter `Content-Type: application/x-www-form-urlencoded`.
4. Følg TCP-stream og læs body-indholdet.

## Opgave 2: Injection-angreb

### Scenario

Webapplikationen viser tegn på manipulation af inputfelter.

### Task

Find:

- hvilken attack type der ses
- source IP
- hvilket endpoint der rammes
- mindst en payload

### Hints

1. Filtrer på `tcp.port == 3000` eller `http`.
2. Kig efter requests mod søge- eller loginfunktioner.
3. Søg efter `OR 1=1`, `UNION SELECT` eller `<script>`.
4. Kig på URI'en i request-linjen.

## Opgave 3: Broken Access Control

### Scenario

En bruger forsøger at tilgå funktioner, som normalt bør være beskyttede.

### Task

Find:

- source IP
- hvilke endpoints der ser ud til at være administrative eller interne
- hvilke requests der tyder på forced browsing eller uautoriseret adgang
- om serveren svarer med `200` eller `403`

### Hints

1. Kig efter paths som `/admin`, `/api/admin`, `/internal` og `/backup`.
2. Filtrer på `ip.src == 192.168.1.200`, hvis du vil indsnævre.
3. Sammenlign requests og HTTP response codes.
4. Notér hvilke endpoints der burde være skjulte eller adgangsbeskyttede.

## Opgave 4: Security Misconfiguration

### Scenario

Serveren kan være fejlkonfigureret og eksponerer information, der ikke burde være offentligt tilgængelig.

### Task

Find:

- source IP
- hvilke paths der peger på fejlkonfiguration
- hvilke af dem der giver brugbar respons
- hvorfor det er en IOC eller sikkerhedsrisiko

### Hints

1. Kig efter `/.git/config`, `phpinfo.php`, `server-status` og `actuator`.
2. Filtrer på `ip.src == 192.168.1.201`.
3. Sammenlign `200 OK` og `404 Not Found`.
4. Tænk over, hvilke filer eller services der kan afsløre systeminformation.

## Opgave 5: Sårbare eller forældede komponenter

### Scenario

En angriber søger efter kendte paths og services, der ofte forbindes med ældre eller sårbare komponenter.

### Task

Find:

- source IP
- hvilke requests der tyder på søgning efter sårbare komponenter
- hvilke paths der bliver undersøgt
- hvorfor dette er interessant i en forensic analyse

### Hints

1. Filtrer på `ip.src == 192.168.1.202`.
2. Kig efter lange eller specifikke paths til kendte produkter/plugins.
3. Notér om angriberen undersøger flere forskellige teknologier.
4. Vurdér om det ligner automatiseret probing.

## Bonusopgave: Port scanning

Undersøg om der er tegn på port scanning i trafikken.

### Filter

```wireshark
tcp.flags.syn == 1 and tcp.flags.ack == 0
```

Find den source IP, der sender SYN-pakker mod mange forskellige porte.
