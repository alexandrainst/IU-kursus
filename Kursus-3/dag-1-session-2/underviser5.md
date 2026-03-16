Find, verificér og forstå logkilder i Wazuh (Manager,
Indexer/Dashboards, Agent)

Formål og læringsmål

\- Eleven kan lokalisere centrale Wazuh-logfiler og overvågningspunkter.

\- Eleven kan forstå dataflowet: OS-logkilde -\> Wazuh Agent -\> Wazuh
Manager -\> Indexer -\> Dashboards.

\- Eleven kan bruge Wazuh UI (Dashboards) og CLI til at verificere, at
logs modtages og korreleres.

\- Eleven kan identificere alerts, regler og decoders, samt basis for
agent-tilstand og integritet.

Forudsætninger og setup

\- Et fungerende Wazuh-lab (fx Wazuh 4.x):

\- Wazuh Manager

\- Wazuh Indexer + Wazuh Dashboards

\- Mindst to agenter: 1x Windows 11 (eller Windows Server) og 1x Ubuntu
(server/desktop)

\- Admin-adgang til Wazuh Dashboards og sudo/admin på agenter.

\- Adgang til OS-standardlogs (Windows Event Logs, /var/log/\* på
Ubuntu).

Opgaveinstruktion til eleverne

\- Arbejd enkeltvis, i par eller små grupper.

1\) Lokalisere Wazuh-logfiler og agentstatus på manager og agenter.

2\) Udløse standard OS-hændelser (som i den tidligere øvelse) og se dem
som Wazuh-alerts.

3\) Identificere matchende Wazuh-regler/decoders for mindst tre
hændelser.

4\) Dokumentere stier, værktøjer og relevante UI-visninger.

5\) Besvare kontrolspørgsmålene og aflevere en kort rapport (1--2
sider).

Tjekliste pr. komponent

Wazuh Manager (server)

\- Centrale logfiler:

\- /var/ossec/logs/ossec.log (manager runtime-events, rule matching,
agent events)

\- /var/ossec/logs/alerts/alerts.json (alerts i JSON -- primær
datakilde)

\- /var/ossec/logs/archives/archives.json (arkiverede/ufiltrerede
events)

\- Konfiguration (læseformål, ikke ændre i denne øvelse):

\- /var/ossec/etc/ossec.conf (global konfiguration)

\- Regler: /var/ossec/etc/rules/ og decoders: /var/ossec/etc/decoders/

\- Kommandoer:

\- sudo tail -f /var/ossec/logs/ossec.log

\- sudo tail -f /var/ossec/logs/alerts/alerts.json \| jq \'.rule.id,
.rule.description, .agent.name\'

\- sudo /var/ossec/bin/agent_control -l (liste agenter og status)

\- sudo /var/ossec/bin/agent_control -i \<ID\> (detaljer for agent)

\- Kontrolspørgsmål:

\- Hvor ses nye alerts først (filsti)? Hvilket format har de?

\- Hvilken regel-ID matchede en specifik hændelse (fx failed SSH login)?

\- Hvad viser ossec.log, når en agent (gen)forbinder?

Wazuh Indexer og Dashboards

\- Dashboards (Web UI):

\- Security events -\> Events/Discover: filtrér på agent.name eller
rule.id

\- Security events -\> Rules: slå regel-ID op og læs
beskrivelse/severity

\- Agents: tjek agent-status (Active/Disconnected, last keepalive)

\- Søgninger (KQL/Query):

\- rule.id: "5710" eller rule.description: "sshd"

\- agent.name: "\<navn-på-agent\>" AND data.win.eventdata.LogonType: "3"

\- event.module: "windows" eller "syscollector" (hvis aktiv)

\- Kontrolspørgsmål:

\- Find en alert fra Windows Security-log (fx EventID 4625) og angiv
rule.id og severity.

\- Find en SSH failed login fra Ubuntu og vis tidsstempel, agent,
regelbeskrivelse.

\- Vis hvordan man bekræfter, at en agent sender data (UI: Agents +
seneste event i Discover).

Wazuh Agent -- Windows

\- Dataindsamling:

\- Standard: Windows Event Logs via ossec.conf (winlogbeat/wodle)

\- Kilder: Application, Security, System

\- Lokal verifikation:

\- PowerShell: Get-WinEvent -LogName Security -MaxEvents 5 (udløs
hændelser og krydscheck)

\- Agent-logs (på Windows):

\- C:\\Program Files (x86)\\ossec-agent\\ossec.log (kan variere med
installation)

\- C:\\Program Files (x86)\\ossec-agent\\logs\\ossec.log

\- Kontrolspørgsmål:

\- Udløs en fejlet login (EventID 4625) -- kan du se matchende alert i
Dashboards?

\- Hvilke Windows-lognavne er aktiveret i agentens konfiguration?

\- Hvor ses lokale agent-fejl (sti til ossec.log)?

Wazuh Agent -- Ubuntu

\- Dataindsamling:

\- Standard: /var/log/auth.log, /var/log/syslog m.fl. via
syslog/journald input

\- Agent-logs:

\- /var/ossec/logs/ossec.log (lokal agentlog)

\- Verifikation:

\- sudo tail -n 50 /var/log/auth.log

\- Fremprovokér "Failed password" via SSH fra testkonto

\- Kontrolspørgsmål:

\- Kan du se en "Failed password" alert i Dashboards? Hvilken rule.id
trigges?

\- Find en system-start/stop-hændelse og match regelbeskrivelse.

\- Hvilke filstier på agenten bliver læst af Wazuh (angiv eksempler fra
ossec.conf hvis synligt i labbet)?

Mini-øvelser: Generér synlige Wazuh-events

\- Windows:

\- Forkert login (4625), tjeneste stop/start (7040/7045), brug
UAC/sudo-lignende handlinger.

\- Ubuntu:

\- SSH fejllogin, sudo forsøg, apt install/uninstall (se også Wazuh's
vulnerability/OS info hvis syscollector er aktiv).

\- Manager:

\- Genstart wazuh-manager service og observer ossec.log for agent
reconnects.

Rapportskabelon (elevaflevering)

\- Komponent: \[Manager \| Indexer/Dashboards \| Agent-Windows \|
Agent-Ubuntu\]

\- Værktøjer/UI brugt:

\- Log-/datastier:

\- Tre dokumenterede alerts (rule.id, beskrivelse, agent, tidspunkt):

\- Skærmbillede(r) fra Wazuh Dashboards (Discover/Agents/Rules):

\- Svar på kontrolspørgsmål:

\- Evt. bemærkninger (konnektivitet, forsinkelse, tidszoner)

Facitoversigt (kort, til lærer)

\- Manager:

\- Alerts: /var/ossec/logs/alerts/alerts.json (JSON)

\- Runtime: /var/ossec/logs/ossec.log

\- Agentoversigt: agent_control -l

\- Windows-agent:

\- Kilder: Application/Security/System

\- Lokal agentlog: C:\\Program Files (x86)\\ossec-agent\\logs\\ossec.log

\- Typisk alert fx 4625 -\> Wazuh rule (Windows authentication failure)

\- Ubuntu-agent:

\- Kilder: /var/log/auth.log, syslog, journal

\- Lokal agentlog: /var/ossec/logs/ossec.log

\- Typisk alert: SSH "Failed password" -\> rule.id for sshd
authentication failure

\- Dashboards:

\- Verifikation gennem Discover-søgning på agent.name, rule.id,
event.type

\- Severity og beskrivelse kan hentes via Rules-oversigt

Differentiering

\- Basis: Find stier, verificér at events bliver til alerts, giv 3
eksempler.

\- Øvet: Brug Dashboards til målrettet søgning (KQL), identificér
decoders/rules, forklar severity og mitigerende handling.

\- Avanceret: Korrelér OS-hændelse med Wazuh-alert og vis kæden fra rå
log (OS) til alert (alerts.json) til Dashboard-visualisering, inkl.
tidsstempler og agent-ID.
