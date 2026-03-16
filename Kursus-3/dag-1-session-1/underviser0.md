Find og verificér standard-logfiler på Windows og Ubuntu (klient og
server)

Formål og læringsmål

\- Eleven kan lokalisere og åbne centrale standardlogs.

\- Eleven kan anvende relevante værktøjer (Event Viewer, PowerShell,
journalctl, less/grep).

\- Eleven kan identificere og beskrive konkrete hændelser i loggene.

\- Eleven kan forklare adgangsrettigheder og grundlæggende
retention/rotation.

Forudsætninger og setup

\- Adgang til:

\- Windows 11-klient (lokal administrator-adgang)

\- Windows Server (2019/2022, lokalt admin)

\- Ubuntu Server (22.04+), sudo-adgang

\- Ubuntu Desktop (klient), sudo-adgang

\- Netværksadgang mellem maskiner (valgfrit).

\- Værktøjer: Event Viewer, PowerShell, Command Prompt, terminal med
journalctl, less, grep.

Opgaveinstruktion til eleverne

\- Arbejd i par eller små grupper.

\- For hvert system skal I:

1\) Lokalisere de centrale standard-logs.

2\) Åbne og filtrere dem med relevante værktøjer.

3\) Identificere mindst tre konkrete hændelser/poster.

4\) Notere stier og værktøjer brugt samt evt. rettigheder.

5\) Besvare kontrolspørgsmålene i tjeklisten.

\- Aflevering: Kort rapport (1--2 sider) med:

\- Liste over log-stier og værktøjer pr. system

\- Skærmbilleder/udskrifter af mindst tre hændelser pr. system

\- Svar på kontrolspørgsmål

Tjekliste pr. platform (standard-logs)

Windows 11 (klient)

\- Hvor åbner du standard-logs?

\- Event Viewer (eventvwr.msc) -\> Windows Logs

\- Hvilke standard-logs skal du finde?

\- Application

\- Security

\- System

\- Setup

\- Fysiske filplaceringer:

\- C:\\Windows\\System32\\winevt\\Logs\\\*.evtx

\- CLI-værktøjer:

\- PowerShell: Get-WinEvent -LogName System -MaxEvents 10

\- wevtutil el (list), wevtutil qe System /c:5 /f:text

\- Kontrolspørgsmål:

\- Find en nylig systemhændelse (fx "Kernel-General" eller driver).

\- Find en logon/logoff-hændelse i Security (hint: EventID 4624/4634).

\- Notér stien til .evtx-filerne og hvilke rettigheder, der var
nødvendige.

Windows Server

\- Samme standard-logs som Windows 11:

\- Application, Security, System, Setup

\- Rolle-uafhængig fokus: standard-logs (ignorér rolle-specifikke for
denne opgave).

\- Kontrolspørgsmål:

\- Find en Security-hændelse (fx 4624/4625).

\- Vis log-egenskaber for Security (max size/overwrite policy).

\- Filtrer med PowerShell på EventID 4625 (fejlet logon).

Ubuntu Server

\- Værktøjer:

\- journalctl (systemd)

\- less/grep/tail

\- Standard log-stier (tekst):

\- /var/log/syslog (generelle systembeskeder)

\- /var/log/auth.log (godkendelse, sudo/SSH)

\- /var/log/kern.log (kernel)

\- Apt-relateret: /var/log/apt/history.log, /var/log/apt/term.log

\- Journal (persistent hvis konfigureret):

\- /var/log/journal/ (ellers volatile i /run/log/journal)

\- Kommandoforslag:

\- sudo tail -n 50 /var/log/auth.log

\- journalctl -p warning..emerg \--since \"today\"

\- journalctl -u ssh

\- grep -i \"failed\" /var/log/auth.log

\- Kontrolspørgsmål:

\- Find en SSH-login-hændelse (succes/fejl) i auth.log eller journalctl
-u ssh.

\- Find en nylig apt-installation i /var/log/apt/history.log.

\- Angiv om systemet har persistent journal (ja/nej) og hvordan det
aktiveres.

Ubuntu Desktop (klient)

\- Standard log-stier:

\- /var/log/syslog

\- /var/log/auth.log

\- /var/log/kern.log

\- Journal-centrerede kommandoer:

\- journalctl \--since \"today 08:00\" \--until \"today 12:00\"

\- journalctl -p err..emerg

\- journalctl \--user (brugersession-relateret)

\- Kontrolspørgsmål:

\- Find netværksrelaterede events (hint: journalctl -u NetworkManager).

\- Identificér en brugersession-event via journalctl \--user.

\- Notér hvilke filer/kommandoer der krævede sudo.

Mini-øvelser: skab hændelser der kan logges

\- Windows (begge):

\- Start/stop en tjeneste: net stop spooler; net start spooler. Find
event i System.

\- Lav en kontrolleret fejlet login (fx forkert adgangskode) og find
EventID 4625 i Security.

\- Kør Windows Update manuelt og observer Setup/Application.

\- Ubuntu (begge):

\- Forsøg SSH-login (fejl/succes) fra en testkonto; verificér i
/var/log/auth.log.

\- Installer en testpakke (fx sudo apt install cowsay) og verificér i
apt-logs.

\- Skift netværksprofil (Desktop) og observer NetworkManager-events.

Rapportskabelon (elevaflevering)

\- System: \[Windows 11 \| Windows Server \| Ubuntu Server \| Ubuntu
Desktop\]

\- Værktøjer brugt:

\- Log-stier:

\- Rettigheder krævet:

\- Tre fundne hændelser (kort beskrivelse + tidspunkt + kilde/lognavn):

\- Svar på kontrolspørgsmål:

\- Bemærkninger (fx retention, rotation, særlige observationer):

Facitoversigt (kort, til lærer)

\- Windows standard-logs:

\- Event Viewer: Windows Logs -\> Application, Security, System, Setup

\- Filer: C:\\Windows\\System32\\winevt\\Logs\\\*.evtx

\- Nøgle-EventID: 4624 (logon), 4625 (failed logon), 6005/6006 (Event
Log service start/stop), 7045 (tjeneste installeret), m.fl.

\- Ubuntu standard-logs:

\- /var/log/syslog, /var/log/auth.log, /var/log/kern.log,
/var/log/apt/\*

\- journalctl (persistent journal i /var/log/journal hvis aktiveret)

\- Eksempel: auth.log indeholder "Accepted password"/"Failed password"
for SSH.

Differentiere krav (valgfrit)

\- Basis: Lokalisér, åbne og dokumentér tre hændelser pr. system.

\- Øvet: Filtrér logs efter tidsinterval/priority/EventID og forklar
rettigheder/rotation (logrotate på Ubuntu, log properties på Windows).

\- Avanceret: Korrelér en hændelse på tværs af systemer (fx fejlet login
på Ubuntu og samtidig RDP-forsøg på Windows) og beskriv
fejlsøgningsprocedure.
