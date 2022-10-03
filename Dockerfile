FROM debian:stable-slim

RUN apt-get -y update && apt-get install -y --no-install-recommends \
	git  \
	curl  \
	gcc \
	build-essential \
	libssl-dev \
	zlib1g-dev \
	net-tools \
 && apt-get -y autoremove
 
WORKDIR /opt/MTProxy
git clone https://github.com/TelegramMessenger/MTProxy
RUN git clone https://github.com/TelegramMessenger/MTProxy .
RUN make

RUN curl https://core.telegram.org/getProxySecret /etc/telegram/proxy-secret
COPY --from=build /opt/MTProxy/objs/bin/mtproto-proxy /usr/local/bin/
COPY run.sh /
RUN chmod a+x /run.sh
ENTRYPOINT ["/run.sh"]