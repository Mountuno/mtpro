FROM debian:stable-slim

RUN apt-get -y update && apt-get install -y --no-install-recommends \
	git  \
	wget  \
	gcc \
	build-essential \
	libssl-dev \
	zlib1g-dev \
	net-tools \
 && apt-get -y autoremove
 
WORKDIR /opt/MTProxy
RUN wget -O proxy-secret https://core.telegram.org/getProxySecret --no-check-certificate
RUN wget -O proxy-multi.conf https://core.telegram.org/getProxyConfig --no-check-certificate
RUN git -c http.sslVerify=false clone https://github.com/TelegramMessenger/MTProxy .
RUN make

RUN curl https://core.telegram.org/getProxySecret /etc/telegram/proxy-secret
COPY --from=build /opt/MTProxy/objs/bin/mtproto-proxy /usr/local/bin/
COPY run.sh /
RUN chmod a+x /run.sh
ENTRYPOINT ["/run.sh"]
