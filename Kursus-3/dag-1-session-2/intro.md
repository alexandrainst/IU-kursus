## Wazuh -- Introduktion til SIEM, EDR og XDR *(til undervisningsformål )*

### 1. Baggrund og rolle i informationssikkerhed

  -----------------------------------------------------------------------------
  Aspekt                  Beskrivelse
  ----------------------- -----------------------------------------------------
  **Hvad er Wazuh?**      Et gratis, open‑source sikkerhedsplatform, der
                          kombinerer **SIEM**, **EDR** og **XDR** funktioner.
                          Den indsamler logs, udfører trusselsdetektion,
                          fil‑integritets‑monitorering (FIM) og korrelerer data
                          med CVE‑databaser. [wazuh.com](https://wazuh.com/)

  **SIEM‑rollen**         Centraliserer log‑ og hændelsesdata fra mange kilder
                          (OS, applikationer, netværksenheder) og giver
                          korrelation, visualisering og rapportering.

  **EDR‑rollen\**         Agent‑baseret overvågning på hver endpoint
  (Endpoint Detection &   (Linux/Windows) -- samler system‑logs, proces‑ og
  Response)               netværksaktivitet, udfører trussels‑detektion og
                          muliggør fjern‑respons.

  **XDR‑rollen**          Udvider EDR til også at dække cloud, containere og
                          netværk, så trusler kan korreleres på tværs af hele
  (Extended Detection &   miljøet.
  Response)               
  -----------------------------------------------------------------------------

### 2. Funktioner

  -----------------------------------------------------------------------
  Funktion                Hvad den gør            Hvor den bruges
  ----------------------- ----------------------- -----------------------
  **Log‑indsamling**      Indsamler syslog,       Alle endepunkter og
                          Windows Event Log,      servere
                          audit‑logs osv.         

  **File Integrity        Overvåger ændringer i   
  Monitoring (FIM)**      kritiske                
                          filer/directories,      
                          registrerer             
                          uautoriseret ændring,   
                          hjælper med compliance. 

  **Vulnerability         Sammenligner            Server‑ og
  detection**             installeret software    endpoint‑agenter
                          med CVE‑databasen og    
                          udløser advarsler.      

  **Realtime alerting**   Alert‑regler baseret på Dashboard / e‑mail /
                          signaturer, anomalier   webhook
                          eller brugerdefinerede  
                          betingelser.            

  **Dashboard &           Grafisk UI              Web‑grænseflade
  rapportering**          (Kibana‑baseret) med    
                          oversigter, heatmaps,   
                          compliance‑rapporter.   

  **Integrations**        Slack, Microsoft Teams, Ops‑team,
                          ServiceNow, Splunk,     ticket‑systemer
                          Elastic Stack, osv.     
  -----------------------------------------------------------------------

### 3. Begrænsninger

  -----------------------------------------------------------------------
  Begrænsning                         Konsekvens
  ----------------------------------- -----------------------------------
  **Skalerbarhed**                    Selvom Wazuh kan håndtere tusindvis
                                      af agenter, kræver store
                                      deployment‑miljøer korrekt
                                      dimensionering af
                                      Elasticsearch‑klustret.

  **Kompleks konfiguration**          Avancerede regler og korrelationer
                                      kan være svære at forstå for
                                      begyndere; kræver tid til
                                      fin‑tuning.

  **Ingen native cloud‑SaaS**         Der findes ingen fuldt hosted
                                      version fra Wazuh‑holdet (man skal
                                      selv hoste).

  **Support**                         Gratis community‑support; betalt
                                      support kun via tredjepart eller
                                      konsulenter.
  -----------------------------------------------------------------------

## 4. Vigtige funktioner

4.1 Filintegritets‑overvågning (FIM)

Wazuh's funktion for filintegritets‑overvågning (FIM) er designet til at
opdage ændringer i filer eller mapper og markere uventede eller
uautoriserede modifikationer. Til test konfigureres Wazuh agenten til at
overvåge /Dokument-mappen på Windows‑ og Linux‑maskine, det kunne være
andre vigtige filer som logs eller systemkritiske filer. Ved at oprette,
ændre og slette filer, loggede Wazuh-agenten hændelser med detaljer om
tidspunkt, type af ændring (fx fil tilføjet, ændret, slettet) og den
præcise filsti. Wazuh‑dashboard gør det muligt at undersøge detaljer for
hver hændelse, såsom tidsstempler, brugerhandlinger og
regelbeskrivelser. Denne funktion er særligt nyttig til at holde øje med
kritiske systemfiler og sikre, at der ikke forekommer ondsindet
manipulation (tegn på utilsigtet ændring (oprettelse, ændring,
sletning).

4.2 Log‑overvågning

Til log‑overvågning bruges f.eks. Ubuntu‑maskinen. De første tests
omfattede at stoppe og starte Wazuh‑agenten, logge ind og ud af
brugerkonti, bevidst indtaste forkerte adgangskoder flere gange samt
forsøge at installere software som root‑bruger. Wazuh's
log‑overvågningsfunktion fangede alle disse aktiviteter og viser
real‑time‑detektering af mistænkelig adfærd. Loggen kan nemt ses og
analyseres via dashboard, hvor detaljer som brugerhandlinger,
IP‑adresser og hændelses‑severitet bliv vist tydeligt.

4.3 Indbrudsdetektion

Til indbrudsdetektionen fokuseredes på SSH‑aktivitet mellem min
Wazuh‑server og en Ubuntu‑endpoint. Efter bevidst at indtaste et forkert
kodeord flere gange markerede Wazuh de mislykkede godkendelsesforsøg og
registrerede dem som potentielle brute‑force‑forsøg. Denne hurtige
påvisning af mistænkelig login‑aktivitet fremhævede værdien af Wazuh's
indbyggede regler for indbrudsdetektion og hjælper med at beskytte mod
angreb som brute‑force og credential‑stuffing.

5\. Installation af agenter

Der er 2 muligheder for at installerer agenter på Windows og Linux,
gennem Wazuh manager kan man få en guide med valg som bygger
"installationen" op så man ender med script (oneliner) til at kører fra
clienten (Linux/Windows)

Brug "labprotal" → Wazuh GUI → log på (admin/admin) → Deploy new agent

![](media/image1.png){width="2.236111111111111in"
height="1.1743055555555555in"}![](media/image2.png){width="3.984722222222222in"
height="1.3590277777777777in"}

Her kan så vælges Linux, Windows (macOS) og man skal udfylde følgende:

\- Serverens IP (Wazuh manager)\
- Agent navn (unik)\
- og evt gruppe den skal tilhører

Så får man serveret installations streng (one-liner) og hvordan man
starter agenten

#### 5.1 **Linux** (`terminal)``
``wget https://packages.wazuh.com/4.x/apt/pool/main/w/wazuh-agent/wazuh-agent_4.14.1-1_amd64.deb && sudo WAZUH_MANAGER='192.168.100.4' WAZUH_AGENT_NAME='Linux1' dpkg -i ./wazuh-agent_4.14.1-1_amd64.deb`

*Start agenten:\*
sudo systemctl daemon-reload\
sudo systemctl enable wazuh-agent\
sudo systemctl start wazuh-agent

#### 5.3 **Windows** (Powershell):

Invoke-WebRequest -Uri
https://packages.wazuh.com/4.x/windows/wazuh-agent-4.14.1-1.msi -OutFile
\$env:tmp\\wazuh-agent; msiexec.exe /i \$env:tmp\\wazuh-agent /q
WAZUH_MANAGER=\'x.x.x.x\' WAZUH_AGENT_NAME=\'WindowsClient01\'

`Start the agent:``
``net start wazuh-agent`

#### 5.4 **Konfigurér File Integrity Monitoring (FIM)**

Rediger\
`/var/ossec/etc/shared/fim_rules.xml` (Linux) eller \
`C:\Program Files (x86)\ossec-agent\etc\shared\fim_rules.xml` (Windows).\
\
Eksempel:

`<directory check_all="yes">/etc</directory>``
``<directory check_all="yes">/var/www/html</directory>``
``<file>/etc/passwd</file>`

Genindlæs konfigurationen:

`sudo /var/ossec/bin/ossec-control restart`

> FIM‑regler kan også defineres per‑agent via **localfile**‑sektionen
> i `ossec.conf`. Se Wazuh‑manualen for detaljer

## 6. Øvelser

  -------------------------------------------------------------------------------------
  Øvelse                Formål                    Kort beskrivelse
  --------------------- ------------------------- -------------------------------------
  **1. Deploy en        Forstå agent‑registrering Installer agenten på en anden VM,
  Linux‑agent**         og kommunikation.         brug `manage_agents` til at tilføje
                                                  den, kontroller forbindelsen i
                                                  manager‑dashboardet.

  **2. Deploy en        Arbejde med               Installer MSI‑pakken,
  Windows‑agent**       Windows‑miljøet og        kør `agent-auth`, tjek at
                        Sysmon‑integration.       agent‑status viser "Active".

  **3. Konfigurér FIM   Praktisk anvendelse af    Rediger `fim_rules.xml` til at
  for en kritisk        File Integrity            monitorere `/etc` (Linux)
  mappe**               Monitoring.               og `C:\Windows\System32` (Windows).
                                                  Lav en filændring og observer alert i
                                                  UI.

  **4 Skriv en simpel   Introducere               Opret en regel
  alert‑regel**         regel‑skrivning og        i `rules/local_rules.xml` der udløser
                        korrelation.              en alarm, når en `.exe`‑fil
                                                  i `C:\Temp` ændres. Test ved at
                                                  kopiere en fil og bekræft alarmen i
                                                  dashboardet.
  -------------------------------------------------------------------------------------

*Tip:* Hvis man vil nørde - Eksportere log‑output
fra `/var/ossec/logs/alerts/alerts.json` og analysere JSON‑strukturen
for at forstå, hvordan Wazuh formidler hændelser.

7\. Hvor kan du finde mere detaljeret dokumentation?

- **Wazuh [https://wazuh.com](https://wazuh.com/)**
- **Wazuh - Vulnerability Explorer
  <https://cti.wazuh.com/vulnerabilities/cves>**
- **Officiel Wazuh‑dokumentation** -- alle sider kan vises som ren
  Markdown ved at erstatte `.html` med `.md` i URL'en\
  <https://documentation.wazuh.com/current/getting-started/index.html>
- **GitHub‑repo** -- kildekode, eksempler og community‑issues.\
  <https://github.com/wazuh/wazuh>
- **4Geeks‑guide** -- god introduktion til SIEM/EDR‑begreber med
  Wazuh‑eksempler. https://4geeks.com/lesson/wazuh-siem-and-edr-for-cybersecurity
