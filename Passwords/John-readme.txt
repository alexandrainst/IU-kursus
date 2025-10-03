easy.zip = 4 cifret pin
simple.zip = et (dansk) ord på 7 bogstav, lowercase
medium.zip = 12 tilfældige karakterer (inkl.symboler)
hard.zip = 20 tilfædige karakterer

Nogle af filerne findes også som AES krypteret - Kan JohnTheRipper klare dem?


Der findes en vejledning til JohnTheRipper på:
https://www.openwall.com/john/doc/EXAMPLES.shtml

Nice to know :
>'john --wordlist=password.lst <hash>' kan bruges til at angive en dictionary fil (password.lst)
>'john --max-length=10 <hash>'  kan bruges til at angive max-længden på passwordet (10)


Derudover findes der flere eksempler på https://openwall.info/wiki/john/sample-non-hashes

I kan også prøve med jeres egne passwords (c:\windows\system32\config\SAM, /etc/passwd og /etc/shadow) eller et java keystore