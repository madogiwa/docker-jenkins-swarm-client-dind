#!/bin/sh

OPTS=""

if [ -z "${JENKINS_MASTER}" ]; then
    echo "JENKINS_MASTER is not defined."
    exit 1
fi
OPTS="-master ${JENKINS_MASTER} "

if [ ! -z "${JENKINS_USERNAME}" ]; then
    OPTS="${OPTS} -username ${JENKINS_USERNAME}"
fi

if [ ! -z "${JENKINS_PASSWORD}" ]; then
    OPTS="${OPTS} -password ${JENKINS_PASSWORD}"
fi

if [ ! -z "${JENKINS_EXECUTORS}" ]; then
    OPTS="${OPTS} -executors ${JENKINS_EXECUTORS}"
fi

exec java ${JAVA_OPTS} -jar /usr/share/jenkins/swarm-client.jar ${OPTS}

