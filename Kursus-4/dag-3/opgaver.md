# sudo

Som led i 8.18 (Brug af priviligerede understøttende programmer)
skal de ekstra privilegier som programmer kræver (e.g. ting som kræver `sudo`)
være begrænset til selve programmet/funktionen som skal bruges.
Dette kan ses som princippet _least privilege_,
hvor vi kun tillader en bruger/system at benytte netop det det har brug for.

I opgaven her eksempleviser vi det gennem `sudo` i Unix.
Værktøjet `sudo` giver brugeren særlige rettigheder til systemet gennem `root` brugeren.
Tidligere i kurset har vi benyttet `nmap`, men her er visse funktionaliter begrænset uden brug af `sudo`
Programmet `sudo` kan dog begrænses til således at en bruger kun kan benytte autoriserede programmer.

1. Lav en ny bruger på Kali med `useradd`
3. Skift til brugerne med `su` og se at brugeren ikke kan bruge `sudo`.

2. Tilbage til `kali` brugeren, rediger nu i sudoers filen med `visudo` og tilføj den nye bruger, men kun med rettigheder til `nmap`.
4. Skift til den nye bruger og prøv at køre `sudo nmap` se at det virker
5. Prøv også at køre et andet program med `sudo` og se at det bliver afvist.

Hints: Tjek manualen med `man sudo`.
 


# Web filter

Som led i 8.23 skal I lade en foranstaltning for webfiltering for at undgå at brugere i netværket tilgår upassende indhold.
Dette kan gøres på flere forskellige måder, men den nemmeste måde er at opstille til DNS filter.

1. Log på OPNsense og find Unbound DNS under Services. 
2. Under blocklists bloker nu et valgt domæne (e.g. `facebook.com`).
3. Prøv nu at tilgå siden gennem kali maskinen, enten med `curl` eller en browser.

Hver opmærksom på at DNS filtre kan omgås relativt nemt ved at ændre DNS serveren.


En anden metode er IP filtre, hvor vi i stedet blokerer IP adresser mere direkte.
Prøv nu i stedet at blokere en IP adresse.

1. På prøv at finde en adresse (eller flere) på en side (e.g. `twitter.com`) med `nslookup` eller `dig`.
2. Prøv at tilgå siden enten med browseren eller bare `ping`.
    Prøv et par gange, da adressen godt kan ændre sig undervejs.
3. Tilføj nu i firewall indstillingerne på OPNsense en regel til at blokere trafik til de givne IP'er.
4. Prøv igen at tilgå siden.

I praksis vil man nærmere bruge dynamiske filtre, da IP adresser ændre sig.
Alternativt kan vi gøre det omvendte, hvor vi i stedet kun tillader adgang til nogle kendte steder.

Sidst som bonus opgave, kan I prøve at lave et HTTP(S) filter ved at proxie HTTP pakker, og blokere dem efter behov.
På denne måde kan man mere selektivt vælge hvad man blokere,
eksempelvis en specifik side under et domæne uden at blokere hele domænet.


Følg guiden på
- https://docs.opnsense.org/manual/how-tos/proxytransparent.html

Prøv at tilgå nogle domæner på Kali'en som vil være blokeret.


Sidst, diskuter hvad fordelene/ulemperne ved de forskellige filtre er.
Hvilken slags sikkehed giver det?
