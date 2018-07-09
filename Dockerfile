
FROM docker:dind
LABEL maintainer="Hidenori Sugiyama <madogiwa@gmail.com>"

## tini
RUN \
  wget -O /tini https://github.com/krallin/tini/releases/download/v0.18.0/tini-static-amd64 && \
  chmod +x /tini

## tiny-rc
RUN \
  wget -O /tiny-rc https://github.com/madogiwa/tiny-rc/releases/download/v0.1.7/tiny-rc && \
  chmod +x /tiny-rc

## install OpenJDK8 JRE
RUN \
  apk add --update --no-cache openjdk8-jre-base && \
  apk add --update --no-cache sudo && \
  apk add --update --no-cache curl

ENV JAVA_HOME /usr/lib/jvm/java-1.8-openjdk

## install jenkins
ARG CLIENT_VERSION=3.13
ARG ROOT_DIR=/var/jenkins

RUN \
  addgroup -g 1000 jenkins && \
  adduser -G jenkins -u 1000 -h ${ROOT_DIR} -D jenkins && \
  mkdir "${ROOT_DIR}/workspace" && \
  chown jenkins:jenkins "${ROOT_DIR}/workspace" && \
  chmod 775 "${ROOT_DIR}/workspace"

RUN \
  mkdir -p /usr/share/jenkins && \
  curl -sL -o /usr/share/jenkins/swarm-client.jar https://repo.jenkins-ci.org/releases/org/jenkins-ci/plugins/swarm-client/${CLIENT_VERSION}/swarm-client-${CLIENT_VERSION}.jar

## install docker-compose
RUN \
  apk add --update --no-cache py-pip && \
  pip install docker-compose

## make docker group
RUN \
  addgroup -g 500 docker && \
  addgroup jenkins docker

## launch dockerd as service
RUN \
  mkdir /tiny-rc.d && \
  ln -s /usr/local/bin/dockerd-entrypoint.sh /tiny-rc.d/dockerd.service

COPY jenkins-swarm-client /jenkins-swarm-client
COPY jenkins-swarm-client.sh /jenkins-swarm-client.sh

ENTRYPOINT ["/tini", "--"]

WORKDIR $ROOT_DIR
CMD ["/tiny-rc", "/jenkins-swarm-client"]

