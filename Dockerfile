FROM python:3
#FROM certbot/certbot
RUN apt-get update && \
  apt-get install dnsutils certbot -y
#RUN snap install core && \
#  snap refresh core && \
#  snap install --classic certbot && \
#  ./certbot-auto -q; exit 0
#RUN certbot-auto -q; exit 0
#RUN mv /certbot-auto /usr/local/bin/certbot
RUN pip install softlayer
ADD createcert.sh /usr/local/bin/
ADD renewcert.sh /usr/local/bin/
ADD editdns.py /usr/local/bin/
ADD editdns.sh /usr/local/bin/

RUN chmod +x /usr/local/bin/createcert.sh
RUN chmod +x /usr/local/bin/renewcert.sh
RUN chmod +x /usr/local/bin/editdns.sh
