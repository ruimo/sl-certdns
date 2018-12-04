FROM python:3
RUN wget https://dl.eff.org/certbot-auto && \
  chmod a+x certbot-auto && \
  ./certbot-auto -q; exit 0
RUN mv /certbot-auto /usr/local/bin/certbot
RUN pip install softlayer
RUN apt-get update
RUN apt-get install dnsutils -y
ADD createcert.sh /usr/local/bin/
ADD renewcert.sh /usr/local/bin/
ADD editdns.py /usr/local/bin/
ADD editdns.sh /usr/local/bin/

RUN chmod +x /usr/local/bin/createcert.sh
RUN chmod +x /usr/local/bin/renewcert.sh
RUN chmod +x /usr/local/bin/editdns.sh
