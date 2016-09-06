FROM alpine:3.4
MAINTAINER Jeff Hemminger <jeff.hemminger@gmail.com>

ENV TITAN_VERSION 1.0.0
ENV TITAN_FILE titan-$TITAN_VERSION-hadoop1.zip
ENV TITAN_URL "http://s3.thinkaurelius.com/downloads/titan/$TITAN_FILE"

ENV PATH $PATH:/titan/bin

LABEL Description="TitanDB", "Version: "="$TITAN_VERSION"

WORKDIR /

RUN \
    apk update && \
    apk add bash openjdk8-jre-base wget zip && \
    wget -t 100 --retry-connrefused -O "titan-$TITAN_VERSION.zip" "$TITAN_URL" && \
    unzip titan-$TITAN_VERSION.zip && \
    mv titan-$TITAN_VERSION-hadoop1 titan-$TITAN_VERSION && \
    ln -sv titan-$TITAN_VERSION titan && \
    rm -fv titan-$TITAN_VERSION.zip && \
    apk del zip wget

ADD ./conf/titan-hbase-es.properties /titan/conf
#ADD ./conf/gremlin-server.yaml /titan/conf/gremlin-server
ADD ./conf/remote.yaml /titan/conf

EXPOSE 8182
EXPOSE 8183
EXPOSE 8184

CMD ["/bin/bash", "-e", "/titan/bin/gremlin-server.sh"]
