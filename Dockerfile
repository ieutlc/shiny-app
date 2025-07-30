FROM rocker/shiny:latest

COPY ./app.R /srv/shiny-server/
COPY ./ui.R /srv/shiny-server/
COPY ./server.R /srv/shiny-server/

EXPOSE 3838

CMD ["/usr/bin/shiny-server"]
