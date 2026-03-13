FROM quay.io/arkmq-org/arkmq-org-broker-kubernetes@sha256:fb725448599d6ad3d45b89c05338a7a911b3e9ed55840a4026e502ea36dadec1

USER root

ADD script /opt/amq-broker/script

ARG REMOTE_SOURCE_REF=0467611bb875f50fdee76431dfb9d34dc79b8a7f
ARG REMOTE_SOURCE_REP=https://github.com/arkmq-org/yacfg.git
ENV REMOTE_SOURCE_URL=$REMOTE_SOURCE_REP#$REMOTE_SOURCE_REF
### BEGIN REMOTE SOURCE
ARG REMOTE_SOURCE_DIR=/tmp/remote_source
RUN microdnf install -y git && microdnf clean all && rm -rf /var/cache/yum
RUN mkdir -p $REMOTE_SOURCE_DIR/app
RUN git clone $REMOTE_SOURCE_REP $REMOTE_SOURCE_DIR/app
RUN cd $REMOTE_SOURCE_DIR/app && git checkout $REMOTE_SOURCE_REF
### END REMOTE SOURCE
WORKDIR $REMOTE_SOURCE_DIR/app

RUN chmod g+rwx $REMOTE_SOURCE_DIR/app

RUN microdnf install -y python3 python3-jinja2 python3-pyyaml && \
    microdnf clean all && rm -rf /var/cache/yum

RUN python3 setup.py install

USER 185

LABEL name="arkmq-org/arkmq-org-broker-init"
LABEL description="ArkMQ Broker Init is a container image for configuring Apache Artemis broker instances in containerized environments"
LABEL maintainer="ArkMQ <info@arkmq.org>"
LABEL version="3.0.0"
LABEL org.opencontainers.image.title="ArkMQ Broker Init Powered by Apache Artemis"
LABEL org.opencontainers.image.description="ArkMQ Broker Init is a container image for configuring Apache Artemis broker instances in containerized environments"
LABEL org.opencontainers.image.vendor="ArkMQ"
