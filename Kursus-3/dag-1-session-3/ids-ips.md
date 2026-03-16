**IDS/IPS**

**1. Baggrund og rolle i informationssikkerhed**

Intrusion Detection Systems (IDS) og Intrusion Prevention Systems (IPS)
er defensive sikkerhedskontroller, der er designet til at identificere,
analysere og reagere på ondsindede aktiviteter rettet mod
informationssystemer. De understøtter de grundlæggende principper inden
for informationssikkerhed: fortrolighed, integritet og tilgængelighed
(CIA-triaden).

IDS- og IPS-løsninger fungerer ikke som selvstændige
beskyttelsesmekanismer, men implementeres typisk som en del af en
forsvar-i-dybden-strategi (defense in depth). De anvendes sammen med
andre sikkerhedstiltag som firewalls, endpoint-sikkerhed, adgangskontrol
og sikkerhedsovervågningsplatforme.

**2. IDS -- Intrusion Detection System**

**2.1 Funktion**

Et IDS overvåger løbende netværkstrafik eller aktivitet på værtsniveau
for at opdage tegn på angreb, brud på sikkerhedspolitikker eller unormal
adfærd. Når mistænkelig aktivitet registreres, genererer systemet
alarmer og logger hændelser til videre analyse og efterforskning.

**2.2 Implementeringsmodeller for IDS**

Netværksbaseret IDS (NIDS)

Placering ved strategiske punkter i netværket, hvor systemet inspicerer
datapakker mellem enheder. Anvendes ofte til at overvåge trafik, der
kommer ind i eller forlader netværket.

Hostbaseret IDS (HIDS)

Installeres direkte på servere eller klienter. Overvåger blandt andet
logfiler, systemkald, filintegritet og brugeraktivitet.

**2.3 Styrker ved IDS**

Giver høj synlighed i netværks- og systemadfærd

Understøtter incident response og digitale efterforskninger

Påvirker ikke aktiv trafik og reducerer dermed driftsrisiko

**\**

**2.4 Begrænsninger ved IDS**

Kan ikke automatisk blokere eller stoppe angreb

Kan generere store mængder alarmer, hvilket kan føre til alarmtræthed

Effektiviteten afhænger af kvalificeret sikkerhedspersonale

**3. IPS -- Intrusion Prevention System**

**3.1 Funktion**

IPS forhindrer aktivt identificerede angreb ved at inspicere
netværkstrafik inline og håndhæve sikkerhedsregler. Når ondsindet
aktivitet opdages, kan systemet eksempelvis droppe pakker, nulstille
forbindelser eller blokere kildens IP-adresse.

**3.2 Implementeringsmodeller for IPS**

Inline netværks-IPS

Placeres direkte i trafikstrømmen, hvilket muliggør indgriben i realtid.

Hostbaseret IPS (HIPS)

Beskytter individuelle systemer ved lokalt at blokere ondsindede
handlinger.

**3.3 Styrker ved IPS**

Forhindrer angreb, før skade opstår

Reducerer den tid, en angriber kan operere i systemet

Automatiserer respons på trusler

**3.4 Begrænsninger ved IPS**

Risiko for falske positiver, som kan påvirke forretningsdriften

Kræver omhyggelig konfiguration og løbende justering

Inline-placering skaber afhængighed af systemets tilgængelighed

**\**

**4. Detektionsteknikker**

**4.1 Signaturbaseret detektion**

Denne metode sammenligner observeret aktivitet med kendte angrebsmønstre
gemt i en signaturdatabase.

Fordele

Høj præcision mod kendte trusler

Lav forekomst af falske positiver

Ulemper

Kan ikke opdage nye eller ukendte angreb

Kræver hyppige opdateringer af signaturer

**4.2 Anomalibaseret detektion**

Metoden identificerer afvigelser fra en defineret baseline for normal
adfærd.

Fordele

Kan opdage zero-day- og ukendte angreb

Tilpasser sig ændringer i miljøet

Ulemper

Højere risiko for falske positiver

Kompleks at konfigurere og vedligeholde

**4.3 Adfærds- og heuristisk analyse**

Moderne IDS/IPS-løsninger anvender adfærdsmodeller og heuristik til at
identificere mistænkelige handlingsforløb frem for enkelte hændelser.
Dette forbedrer evnen til at opdage avancerede vedvarende trusler (APT).

**\**

**5. Integration med andre sikkerhedssystemer**

IDS- og IPS-løsninger integreres ofte med:

SIEM-systemer til central overvågning og korrelation

Firewalls som en del af lagdelt trafikstyring

SOAR-platforme til automatiseret hændelseshåndtering

Denne integration øger både detektionsnøjagtighed og responshastighed.

**6. Driftsmæssige overvejelser**

Vigtige driftsudfordringer omfatter:

Løbende justering af regler

Håndtering af krypteret trafik

Kontrol af performancepåvirkning

Balance mellem sikkerhed og tilgængelighed

**7. Anvendelsesområder**

Beskyttelse af offentligt tilgængelige tjenester (webservere, API'er)

Overvågning af interne netværk for lateral bevægelse

Detektion af insidertrusler

Understøttelse af compliance-krav (fx ISO 27001)

**8. Sammenfatning**

IDS og IPS er essentielle komponenter i moderne cybersikkerhed. IDS
fokuserer på detektion og synlighed, mens IPS fokuserer på forebyggelse
og automatiseret respons. Når de er korrekt konfigureret og integreret,
bidrager de markant til at forbedre en organisations samlede
sikkerhedsniveau.

**\**

**Opgaver:**

**Forklaring:**

I opgaverne enabler vi ids/ips på opnsense samt køre nogle test
scripts/sårbarheder og blocker for dem.

Derefter kobler vi opnsense sammen med wazuh for at få samlet logs så vi
kan se og håndtere dem i wazuh SIEM løsningen.

Samt vil der være opgaver hvor der skal oprettes en ids/ips server som
kan se trafikken på netværket da det ikke er sikker alt trafikken flyder
igennem opnsense og vil derfor ikke kunne blocke på trusler.

De første opgave vil være på ukrypteret trafik, men grundet det meste
trafik nu er krypteret vil der også være opgaver hvor vi dekryptere
trafikken og kigge i den.

Åben opnsense gui fra portalen.

Login på opnsense med default login.

User: root

Password: opnsense

**\**

**Opgave 1 -- Enable ids/ips (Suricata)**

Opnsense burger Suricata som ids/ips motor så den skal vi enable og
konfigurere.

Gå til:

Services -\> Intrusion Detection -\> Administration

Sæt:

**Setting Value**

Enabled V

IPS mode V

Promiscuous mode OFF

Interfaces LAN1 & LAN2

Pattern matcher Hyperscan

Enable syslog alerts V

Enable eve syslog output V

Apply og derefter skal servicen genstartes med ikonet
![](media/image1.png){width="0.4000349956255468in"
height="0.3333617672790901in"}

Vent til servicen er genstartet

**\**

**Opgave 2 -- Enable og download regler**

Der skal hentes regler som kan detektere og blokere for ting opnsense
ser, bla. sårbarheder og angrebsmetoder, til denne opgave enabler og
downloader vi alle reglerne, reglerne er sat til Alert så der er ikke
noget der vil blive blocket som standard.

Reglerne er i overordnet emner og kan indeholde mange tusinde regler.

Gå til:

Services -\> Intrusion Detection -\> Download

Vælge alle regler med

![Et billede, der indeholder tekst, skærmbillede, Font/skrifttype,
linje/række AI-genereret indhold kan være
ukorrekt.](media/image2.png){width="4.4837215660542435in"
height="0.808403324584427in"}

så vil næsten alle regler være enablet og kan derefter downloades

Tryk "Download & Update Rules" som er i bunden, nu downloader opnsense
alle reglerne der er enablet, dette kan godt tag lidt tid, når der er en
dato og tidspunkt så er de klar til at bruge.

Der kan være enkelte regler der er downloadet der ikke er enablet pr.
default som hvis der ikke kommer noget i Alerts så kig lige under rules
om der er nogle der ikke er enablet som default, de fleste scan regler
er bla. Disablet.

**\**

**Opaver 3 -- Lave en simple IPS policy**

Nu skal vi lave en simple IPS policy, for at ændre standard Alert som er
på alle regler kan man enten ændre det direkte på reglen eller lave en
policy som ændrer det hvis værdierne i policien er ramt, derefter kan
man ændre "new action" til drop.

Gå til:

Sevices -\> Intrusion Detection -\> Policy

Tryk på + for at lave en ny policy

Sæt:

**Field Value**

Enabled V

Priority 1

Action Alert (Det her er hvad den standard action er så den matcher på
dette)

Rulesets emerging-attack_response.rules

Classtype bad-unknown

Description "Kali http://testmyids.com"

New action Drop (Det her sætter den nye action til drop hvis policien
rammes)

**Apply**

Det tager et par minutter før policien virker da opnsense genstart
Suricata engine hver gang der er ændringer.

For at kontrollere om Suricata enginen er klar så kig under

Services -\> Intrusion Detection -\> Log file

Der står Suricata enginen er stopped, vent derefter til en er startet
igen, 2-3 min.

![](media/image3.png){width="5.392133639545057in"
height="0.35003062117235345in"}

![](media/image4.png){width="6.567235345581802in"
height="0.3917005686789151in"}Hvis der ikke står noget prøv at opdatere
siden ![](media/image5.png){width="0.5583814523184601in"
height="0.4833748906386702in"}

**Opgave 4 -- Test af policien virker fra Kali**

Åben "KALI01 VNC" fra portalen

Password til KALI01 er "Password1!"

Åben en cmd

Fra cmd kør

curl http://testmyids.com

Hvis der kommer noget tilbage fra curl betyder det vores policy ikke
blev ramt også skal vi tilbage for at se om der er nogle ting i vores
policy der ikke er rigtig,gå tilbage til opgave 3 og kontrollere om alle
indstiller er korrekt.

Her er det output man får hvis ips ikke blockere for det

*uid=0(root) gid=0(root) groups=0(root)*

Hvis der ikke kommer noget virker vores policy, gå tilbage til opnsense
gui og se under

Services -\> Intrusion Detection -\> Administration -\> Alerts

Derunder kan vi se at der er ramt en regel og action er BLOCKED og
destination er KALI01 ip-adresse 192.168.1.100, det er fordi ips først
ser det som en trussel på return trafikken.

**Opgave 5 -- Lav selv en ny policy som blocker for et angreb.**

Lav nu en policy som blocker for et angreb.

Åben KALI01 fra portalen og kør en cmd

Kør scriptet som simulerer forskellige angreb

/home/kali/Desktop/testips.sh

Vælg derefter et angreb

Se efter hvad der rammes under Alert og lav en policy det sætter new
action til Drop.

Prøv igen med en af de andre angreb som scriptet simulerer

**Opgave 6 -- Forbind opnsense til wazuh**

Nu skal opnsense forbindes til wazuh for at få et samlet overblik og
logs centralt, wazuh er en SIEM løsning og kan bruges til at se på logs
over forskellige platforme og derfor se på mange forskellige hændelser
og derefter alarmer for det.

Enkelte hændelser i sig selv er ikke farlige men i sammenhæng med
forskellige hændelser kan det være et tegn på angreb eller trusler.

Før vi kan forbinde opnsense med wazuh skal vi installere en wazuh-agent
på opnsense men dette kræver den er opdateret, så det gør vi nu.

Åben opnsense SSH på portalen.

Vælg 12 ) update from console

Vælge Y

Derefter kommer der en patch note om hvad der installeres, tryk q for at
fortsætte.

Nu opgraderes opnsense til den nyeste version, dette kan godt tag et par
minutter.

Mens vi vente kan vi kigge på wazuh, vælg wazuh gui på portalen og kig
lidt hvad der er, f.eks agenter og dashboards.

Opnsense genstarter efter den er opgraderet, når den er klar igen, skal
vi have installeret wazuh-agenten.

Åben OPNSENSE GUI under portalen og vælg derefter.

System -\> firmware -\> plugins

Vælge show community plugins

Søg på os-wazuh-agent og tryk på + for at installere den, nu er der
nogle indstiller der skal laves for at servicen virker i opnsense gui
samt skal agenten starte ved genstart, dette står også under release
notes når den installeres.

Åben opnsense SSH igen fra portalen eller gå tilbage til den der
allerede er åben fra opgrade, tryk derefter 8 ) Shell

Skriv følgende

cp /etc/localtime /var/ossec/etc

service wazuh-agent enable

service wazuh-agent start

På OPNSENSE GUI gå nu ind under, hvis wazuh-agent ikke er der prøv at
opdatere browseren eller så gå tilbage til OPNSENSE SSH og skriv
"service wazuh-agent status" for at se status på servicen

Services -\> wazuh-agent -\> settings

**Settings Value**

Wazuh 192.168.2.20 (ip-adressen på wazuh serveren)

Applications filter (filterlogs)

firewall (firewall)

suricata (suricata)

Efter et par minutter vil opnsense kunne ses som agent under wazuh og
sende logs samt alert til wazuh.

**Opgave 7 -- Dashboard til opnsense alert i wazuh**

Nu hvor opnsense er forbundet til wazuh kan vi se alle fremtidig alert
samlet et sted, få nu opnsense til at genere logs igen ved at køre det
angreb som der er lavet policies på i opgave 4 og 5.

Derefter åben wazuh gui i portalen.

Gå ind under

Threat intelligence -\> Threat hunting

Her vil vi have et samlet overblik over hændelser der er sket, på selve
dashboardet ser vi et samlet overblik med grafer og diagrammer, men
under Events kan vi se hvad der er sket og derefter lave playbook på
hvad der skal ske i fremtiden.

I en af de fremtidige opgaver skal der oprettes en Suricata server som
holde øje med trafik på de intern netværk da ikke alt trafik flyder
igennem opnsense, de logs som den genererer kan også sendes til wazuh og
ses under Threat hunting.

**Opgave 8 -- lave en suricata server som overvåger lokalt på
netværket**

Til denne opgave skal vi have startet en suricata server op på APPSRV01.

Der ligger allerede en docker-compose.yaml under /opt/suricata/ som kan
startes med følgende cli

cd /opt/suricata

docker compose up --d

Eller starte den på portalen under tasks APPSRV01 -- Suricata -\> Start

Nu henter serveren de nødvendige ting og starter suricata op som en
docker på serveren.

For at se om dockeren er oppe kan man køre

*docker ps* eller se status på portalen under tasks

Derefter skal vi have send alt trafik fra lan1 til den, dette gør vi i
næste opgave

**\**

**Opgave 9 -- send openvswitch logs til Suricata. (mangler test af
den)**

Nu skal vi lave en SPAN eller mirror port på vores openvswitch lan1 som
kopier alt trafik fra lan1 og sende det til APPSRV01 på en mirror port.

På portalen gå ind under tasks -\> LAN1 -- Traffic Mirror -\> Enable
APPSRV01, dette laver en mirror port som kloner alt trafik på lan1 til
APPSRV01 eth2 som vi så kan få suricata til at kigge på.

Der er lavet 2 standard regler på denne suricata under
/opt/suricata/suricata/suricata.rules

alert icmp any any -\> \$HOME_NET any (msg:\"ICMP detected\";
sid:1000001; rev:1;)

alert tcp any any -\> \$HOME_NET 22 (msg:\"SSH attempt\"; sid:1000002;
rev:1;)

Nummer 1 ser på ICMP trafik og nummer 2 ser på SSH trafik.

Hvis der skal tilføjes nye regler, skal de tilføjes til denne fil, samt
skal dockeren stoppes og startes igen, enten fra portalen eller via
*docker compose down --v, docker compose up --d*

Når dockeren køre kan man følge med i om suricata laver alert med
følgende cmd

*tail -f /opt/suricata/logs/fast.log*

Denne cmd køre indtil stoppet med ctrl +c

Prøv nu at ping fra en klient eller server på lan1 til f.eks 8.8.8.8 og
se efter om suricata ser dette.

Ssh til f.eks opnsense med *ssh <root@192.168.1.1>*

Lav et http opslag med *curl <http://testmyids.com>*

Hvad ser den og hvad ser den ikke.

**\**

**Opgave 10 -- send Suricata logs fra serveren til wazuh (ikke færdig)**

Nu hvor vi kan se at suricata ser trafik fra lan1 kan vi forbinde vores
suricata til wazuh for at have et centralt overblik over både vores
opnsense suricata logs og de logs/alert fra APPSRV01.

Dette kan gøres ved at lave et installations cli fra wazuh serveren.

På portalen åben for WAZUH GUI og log in

Derefter gå ind under

Agents Management -\> Summary -\> Deploy new agent

Her skal serverens ip adresse (wazuh serveren 192.168.2.20) og navn på
agenten lokalt udfyldes.

Derefter generere et install script med indstillingerne som bare skal
køres på APPSRV01 via ssh.

Derefter skal servicen enables og startes fra APPSRV01, men det hele
står på agent siden på wazuh under install scriptet.

Derefter skal der tilføjes et par linier i wazuh agenten konfiguration
på APPSRV01 så den læser de logs som suricata generere, dette gøres
under.

\...\...\...\...\...\...\...\....

**Opgave 11 -- lav egne suricata regler på APPSRV01 (ikke færdig)**

I denne opgave skal der laves custom signature/regler på suricata.

**Opgave 12 - få wazuh til at send drop til opnsense hvis den ser en
alert (ikke færdig)**

Man kan få wazuh til at sende en drop til opnsense hvis den ser noget
farligt.

Dette kræver vi åbner for api til opnsense da wazuh servern derefter kan
sende en drop til opnsense

Gå ind under:

System -\> Users

**Opgave 13 -- SSL inspect på opnsense (ikke færdig)**

De opgaver vi har lavet indtil videre, kan kun læse pakkerne da de er
ukrypteret, men størstedelen af trafikken på både internettet og intern
er krypteret med bla. SSL/HTTPS.

Så hvis vi kan have opnsense til at kigge i de pakker bliver vi nødt til
at lave et man-in-the-middle angreb på vores egen trafik og dekryptere
og kryptere trafikken igen.

Til dette skal vi have kontrol over certfikaterne i netværket ellers vil
brugeren få certifikat fejl hver gang de besøger en hjemmeside
