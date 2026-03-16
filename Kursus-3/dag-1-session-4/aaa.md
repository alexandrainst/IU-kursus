**AAA**

**Teori om AAA og RADIUS**

**1. Introduktion til AAA**

AAA står for Authentication, Authorization og Accounting (på dansk:
Godkendelse, Rettighedsstyring og Logning/registrering).\
AAA er et grundlæggende sikkerhedsprincip, der bruges til at
kontrollere, hvem der får adgang til et system, hvad de må gøre, og
hvordan deres handlinger bliver registreret.

AAA-modellen bruges især i netværk, servermiljøer og trådløse netværk,
hvor mange brugere skal have adgang på en kontrolleret og sikker måde.

**2. Authentication (Autentifikation)**

Autentifikation handler om at bevise identitet -- altså at sikre, at
brugeren virkelig er den, de udgiver sig for at være.

Dette kan ske ved hjælp af:

- **Noget man ved** -- fx brugernavn og password

- **Noget man har** -- fx smartcard, mobiltelefon eller token

- **Noget man er** -- biometriske data som fingeraftryk eller
  ansigtsgenkendelse

Bogen beskriver, at stærk autentifikation ofte kombinerer flere faktorer
(to-faktor eller multi-faktor autentifikation), fordi passwords alene
ikke er tilstrækkeligt sikre.

Autentifikation kan ske:

- Lokalt på en enhed (fx router eller server)

- Centralt via en AAA-server (fx RADIUS)

**3. Authorization (Autorisation)**

Når en bruger er blevet autentificeret, skal systemet afgøre hvilke
rettigheder brugeren har.

Authorization bestemmer fx:

- Hvilke netværk brugeren må få adgang til

- Om brugeren må konfigurere udstyr

- Hvilke tjenester (mail, internet, databaser) der er tilladt

Rettigheder kan styres via:

- Roller (fx administrator, almindelig bruger, gæst)

- Grupper

- Politikker (policies)

Bogen lægger vægt på princippet om mindste privilegium (least
privilege), hvilket betyder, at brugeren kun skal have de rettigheder,
der er nødvendige for at udføre sit arbejde -- ikke mere.

**4. Accounting (Regnskab/logning)**

Accounting betyder, at systemet registrerer og logger brugerens
aktivitet.

Dette kan omfatte:

- Hvornår brugeren logger ind og ud

- Hvilke ressourcer der bruges

- Hvor meget data der overføres

- Hvilke handlinger der udføres

Accounting er vigtigt for:

- Overvågning

- Fejlfinding

- Sikkerhedskontrol

- Juridisk dokumentation

- Opdagelse af misbrug

Logning gør det muligt at spore hændelser tilbage til bestemte brugere,
hvilket er afgørende ved sikkerhedsbrud.

**5. RADIUS -- Remote Authentication Dial-In User Service**

RADIUS er en protokol, der bruges til at implementere AAA i praksis.\
Den fungerer som en **central server**, der håndterer autentifikation,
autorisation og accounting for mange netværksenheder.

RADIUS bruges ofte til:

- Trådløse netværk (WiFi med login)

- VPN-forbindelser

- Netværksudstyr som routere og switches

- Fjernadgang

**6. Hvordan RADIUS fungerer**

Når en bruger forsøger at logge på et netværk, sker følgende:

1.  Brugeren indtaster loginoplysninger (fx brugernavn og password)

2.  Netværksenheden (fx en switch eller access point) sender
    forespørgslen til RADIUS-serveren

3.  RADIUS-serveren kontrollerer oplysningerne i en database (fx Active
    Directory)

4.  Serveren svarer med:

    a.  Access-Accept (adgang tilladt)

    b.  Access-Reject (adgang nægtet)

5.  Samtidig bestemmer serveren brugerens rettigheder (authorization)

6.  Brugerens aktivitet bliver logget (accounting)

På den måde samles sikkerhedsstyringen ét centralt sted.

### **7. Fordele ved RADIUS**

Bogen fremhæver flere fordele:

- **Central styring** af brugere og rettigheder

- **Højere sikkerhed** end lokale brugerkonti

- **Skalerbarhed** -- kan bruges til mange brugere

- **Let administration**

- **God integration** med andre systemer (fx LDAP og Active Directory)

**8. Sikkerhedsmæssige aspekter**

RADIUS anvender kryptering af passwords, men ikke hele kommunikationen.
Derfor bruges det ofte sammen med:

- IPsec

- TLS

- 802.1X (især i trådløse netværk)

Bogen nævner også alternativer som TACACS+, der krypterer hele
kommunikationen og bruges mere i netværksadministration.

**9. Praktisk anvendelse i IT-sikkerhed**

I praksis bruges AAA og RADIUS til at:

- Sikre trådløse netværk

- Styre adgang til virksomhedens netværk

- Kontrollere fjernadgang via VPN

- Dokumentere brugeraktivitet

- Overholde sikkerhedspolitikker og lovkrav

AAA-modellen sikrer, at:

- Kun autoriserede brugere får adgang

- Brugere kun får de rettigheder, de skal bruge

- Alle handlinger kan spores

**Opgave 1 -- Start freeradius på APPSRV01 samt basis config**

I denne opgave skal vi starte en freeradius på APPSRV01.

Før vi starter servicen skal vi lige ind og kigge i konfigurations
filerne.

På portalen åben APPSRV01 SSH og går ind i biblioteket /opt/radius, der
ligger docker compose filen samt de konfigurations filer der bliver
brugt til freeradius og openldap.

Under /opt/radius/freeradius ligger filen clients.conf der skal vores
opnsense ip adresse være samt en PSK (pre shared key) som vi skal bruge
i opnsense når vi skal konfigurere den.

For at se indeholdet i filen kan man bruge cat clients.conf, der skulle
gerne være info om opnsense og ip adressen, hvis ikke så ret det til,
noter secret da vi skal bruge den senere.

![](media/image1.png){width="5.542146762904637in"
height="2.3001990376202976in"}

Nu kan servicen startes, dette kan enden gøre direkte fra serveren,

*cd /opt/radius*

*Docker compose ud --d*

Eller fra portalen under tasks, APPSRV01 -- Radius -\> start.

Nu kan vi lave opnsense configuratioen.

På portalen åben OPNSENSE GUI og log in på siden.

Derefter skal vi have gjort så opnsense laver radius forspørgelse op mod
APPSRV01 og bruger den ldap bruger som findes på APPSRV01 til at logge
ind.

Gå ind under

System -\> Access -\> Servers

Derefter +

Udfyld derefter følgende.

"Descriptive name" = navn på serveren f.eks appsrv01

"Type" = Radius

"Hostname or IP address" = 192.168.2.25 (ip adressen på APPSRV01)

"Shared Secret" = Her skal vi bruge den secret der er i clients.conf
(testing123 hvis ikke den er ændret)

Lad resten være default.

Nu kan vi teste om det virker under

System -\> Access -\> Tester

Her kan vi ændre Authentication server til Radius og bruge vores test
bruger.

Username : testuser

Password : testpass

Tryk test.

Så skulle der gerne komme et User: testuser authenticated successfully.
I toppen

Nu skal vi ændre så login metoden i opnsense er radius og ikke kun local
database.

I det her setup beholder vi også local database som login metode, men
man skal være forsigtig med at bruge local database i et produktions
miljø da hvis man ikke har overvågning på login forsøg vil den på sigt
kunne brute forces.

Gå ind under

System -\> Settings -\> Administration

![](media/image2.png){width="6.5in" height="1.0833333333333333in"}

Gå ned til Authentication og ændre Server til Local Database og radius.

Save derefter.

**Opgave 2 -- Opret selv en ny bruger til setupet.**

I denne opgave skal der laves en nye bruger til administration af
opnsense.

Find på et brugernavn og password og ændre 02-users.ldif som findes
under /opt/radius/ldap

Her er hvordan testuser indstillingerne er

dn: uid=testuser,ou=users,dc=mycompany,dc=local

objectClass: inetOrgPerson

cn: testuser

sn: user

uid: testuser

userPassword: testpass

Efter ændring skal man stoppe dockeren og slette de indstillinger den
har importeret.

Brug følgende cmd til det.

*cd /opt/radius*

*docker compose down --v*

*docker compose up --d*

Test nu om bruger virker i opnsense

Åben nu i portalen OPNSENSE GUI og gå ind under

System -\> Access -\> Tester

Så skulle der gerne komme et User: testuser authenticated successfully.
I toppen

Log nu ud af den nuværrende opnsense ved at trykke

Lobby -\> Logout

Brug nu dit nye brugernavn og password.

Virkede det? Nej det er fordi freeradius kun sender en accept og ikke
hvad brugeren har adgang til så lige nu virker Authentication delen men
ikke Authorize delen så det skal vil kigge på i næste opgave samt lave
en.

**Opgave 3 -- bestemt adgang til opnsense**

I denne opgave laver vi 2 forskellige adgang til opnsense via radius så
vores testuser kun har "læse" rettigheder og vores nye selv oprettet
bruger har fuld adgang.

Da opnsense desværre ikke understøtter radius attribute kan vi ikke
sende Authorize fra freeradius, så der skal vi lave 2 grupper lokalt på
opnsense og lave en "fiktiv" bruger som har samme navn som dem vi har,
opnsense vil så bruge radius til at validere brugernavn og password og
derefter give adgang via den lokale bruger.

Lav nu 2 nye grupper under, find selv på nogle navne, best pratice er at
navngiv dem efter hvad de gør eller giver rettigheder til.

System -\> Access -- Groups

Det eneste der skal ændres i Groups er Privileges, lav forskellige for
hver gruppe.

Nu skal der oprettes en bruger og meldes ind i hver deres gruppe.

Under System -\> Access -\> Users

Lav nu 2 bruger som hedder der samme som testuser og den der er blevet
oprettet i forrige opgave, smide dem ind i hver deres gruppe der blev
oprettet samt skal password udfyldes, men så længe freeradius svare og
sender accept eller reject så er det radius passwordet den vil bruge.

Prøv nu at logge ind med de forskellige bruger og se om rettighederne
virker.

**Opgave 4 -- Accounting sendes til APPSRV01 (ikke færdig)**

I denne opgave arbejder vi lidt med Accounting delen så vi kan se hvad
der sker\...\...
