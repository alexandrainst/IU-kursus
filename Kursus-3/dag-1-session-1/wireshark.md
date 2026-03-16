**Wireshark and logs**

![](/media/image.png){width="2.70582895888014in"
height="2.389280402449694in"}![](/media/image2.png){width="2.9831397637795276in"
height="2.388888888888889in"}

**Teori: Wireshark**

Wireshark er et værktøj, der bruges til at se og analysere
netværkstrafik. Det betyder, at man kan se, hvad der bliver sendt frem
og tilbage mellem computere på et netværk.

**Netværkstrafik og pakker**

Når data sendes på et netværk, bliver det delt op i små dele, som kaldes
pakker. En pakke indeholder bl.a.:

- afsenderens IP-adresse

- modtagerens IP-adresse

- hvilken protokol der bruges

- selve dataindholdet (hvis det ikke er krypteret)

Wireshark kan opsnappe disse pakker og vise dem i detaljer.

**Protokoller**

Wireshark bruges til at analysere mange forskellige protokoller, fx:

- **Ethernet** -- lokal netværkskommunikation

- **IP** -- adressering på netværket

- **TCP** -- pålidelig dataoverførsel

- **UDP** -- hurtig, men ikke-pålidelig dataoverførsel

- **HTTP / HTTPS** -- webtrafik

- **DNS** -- oversættelse fra domænenavn til IP-adresse

Ved at analysere protokoller kan man se, hvordan kommunikationen foregår
trin for trin.

**Kryptering og sikkerhed**

En vigtig del af Wireshark-teorien er forskellen på krypteret og
ukrypteret trafik:

- Ukrypteret trafik (fx HTTP) kan læses direkte i Wireshark

- Krypteret trafik (fx HTTPS) kan ikke læses, selvom den opsnappes

Det viser, hvorfor kryptering er afgørende for it-sikkerhed. Uden
kryptering kan følsomme oplysninger som brugernavne og adgangskoder
blive opsnappet.

**Wireshark og IT-sikkerhed**

Wireshark bruges i it-sikkerhed til:

- at opdage sikkerhedsfejl

- at analysere mistænkelig trafik

- at forstå netværksangreb

- at kontrollere, om data sendes sikkert

Værktøjet kan både bruges til at forbedre sikkerheden og til at udnytte
svagheder, afhængigt af hvem der bruger det.

**Lov og etik**

Det er vigtigt at forstå, at man kun må opsnappe trafik på netværk, man
har tilladelse til. At analysere andres netværkstrafik uden tilladelse
kan være ulovligt og i strid med privatlivets fred.

**Kort opsummering**

- Wireshark opsnapper og analyserer netværkspakker

- Det bruges til at forstå netværk og it-sikkerhed

- Ukrypteret trafik kan læses, krypteret trafik kan ikke

- Kryptering beskytter data

Brug af Wireshark kræver ansvar og tilladelse

**Opgave 1 -- Send alt trafik fra lan1 til KALI01**

Nu skal vi kigge lidt logs på lan1, til det skal trafikken fra lan1
sendes til KALI01.

Der kan være forskellige måde at sende trafik som der skal inspiceres
på, i vores setup bruger vi openvswitch til at kopier traffiken og send
det til KALI01, eller kunne man lave en mirror/span på på det fysiske
setup.

På portalen gå ind på tasks siden og enable LAN1 -- Traffic Mirror
(Kali), dette laver en morror port som kopier traffiken på lan1 til
KALI01.

Åben nu wireshark, enten via menuen eller åben en cmd og skrive
wireshark.

KALI01 har et interface der er dedikeret til mirror så det interface der
skal lyttes på er eth2.

Nu kan der generes trafik på lan1, det vil sige find en klient eller
server (må ikke være KALI01) som er på lan1 og prøv at ping 8.8.8.8.

Der er forskellige måder at lave filter på i wireshark, enten kan man
skrive "icmp" får man alle ping/icmp pakker i flowet, der er en del
genvejer til applicationer, f.eks HTTP, DHCP HTTPS.

Hvis man vil følge en session kan man trykke højre mus på en tcp pakke
og vælge Follow og TCP stream, dette kan også gøre med HTTP.

Man kan også lave speciele search ting, bla ip.addr == 192.168.1.1, så
ser man alt trafik som omhandler 192.168.1.1, hvis man vil have alt
andet trafik kan man skifte == ud med != som betyder alt ændret end det
man skriver.

**Opgave 2 -- dekryptere SSL trafik med wireshark**

I denne opgave ser vi hvordan wireshark kan bruges til at dekryptere
pakker hvor vi har privat nøglen, dette vil ikke være tilfældet i
virkeligheden da de privat nøgler ofte er godt beskyttet eller ligger
lokalt på serverne og kan ikke exporteres.

Åben KALI01 VNC fra portalen og kige på skrivebordet, der er en mappe
der hedder wireshark, i mappen findes der en cap fil som er en wireshark
fil, samt en key fil som kan bruges til at dekryptere trafikken.

Åben nu cap filen i wireshark og kig på indeholdet, der er forskellige
protokoller men bemærk SSLv3 trafikken, dette er det krypteret
indenhold.

Nu vil vi prøve at dekrypere med key filen.

I wirehark vælg

Edit -\> preferences -\> Protocols -\> TLS

Der er RSA keys list -\> Edit

![](/media/image3.png){width="6.34221675415573in"
height="3.1252712160979876in"}

Tryk + og under Key File tryk Browse og vælg key filen

![](/media/image4.png){width="4.750411198600175in"
height="0.900077646544182in"}

Derefter ok og ok

Nu vil SSLv3 trafikken være dekrypteret og i wireshark vil protokollen
nu være HTTP

**Opgave 3 -- Find PSK nøglen i WPA2-Private handshake.**
