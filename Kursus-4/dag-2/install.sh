#! /bin/sh

wget -O /opt/juiceshop-waf/exclusions.conf https://raw.githubusercontent.com/alexandrainst/IU-kursus/refs/heads/main/Kursus-4/dag-2/exclusions.conf
wget -O /opt/juiceshop-waf/docker-compose.yml https://raw.githubusercontent.com/alexandrainst/IU-kursus/refs/heads/main/Kursus-4/dag-2/docker-compose.yml
wget -O - https://raw.githubusercontent.com/alexandrainst/IU-kursus/refs/heads/main/Kursus-4/dag-2/ossec.conf >> /var/ossec/etc/ossec.conf
