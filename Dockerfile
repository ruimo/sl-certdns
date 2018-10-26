FROM python:3
RUN pip install softlayer
RUN apt-get update
RUN apt-get install letsencrypt dnsutils -y
ADD createcert.sh /usr/local/bin/
ADD renewcert.sh /usr/local/bin/
ADD editdns.py /usr/local/bin/
ADD editdns.sh /usr/local/bin/

RUN chmod +x /usr/local/bin/createcert.sh
RUN chmod +x /usr/local/bin/renewcert.sh
RUN chmod +x /usr/local/bin/editdns.sh
