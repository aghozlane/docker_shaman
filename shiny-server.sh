#!/bin/sh

# Make sure the directory for individual app logs exists
mkdir -p /var/log/shiny-server
chown shiny.shiny /var/log/shiny-server

exec shiny-server >> /var/log/shiny-server.log 2>&1
exec nohup /usr/bin/Rscript /usr/bin/run_kronarshy.R&
exec python /usr/bin/shaman_bioblend/shaman_bioblend.py  -w /srv/shiny-server/shaman/www/masque/ -s -d
