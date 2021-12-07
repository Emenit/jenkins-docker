FROM jenkins/jenkins:lts

ARG DOCKER_GID
ARG JENKINS_ADMIN_USER
ARG JENKINS_ADMIN_PASSWORD

USER root
RUN apt-get update \
    && apt-get -qq -y --no-install-recommends --no-install-suggests install \
        apt-transport-https \
        ca-certificates \
        curl \
        gnupg2 \
        software-properties-common \
    && curl -fsSL https://download.docker.com/linux/$(. /etc/os-release; echo "$ID")/gpg > /tmp/dkey; apt-key add /tmp/dkey \
    && add-apt-repository \
        "deb [arch=amd64] https://download.docker.com/linux/$(. /etc/os-release; echo "$ID") \
        $(lsb_release -cs) stable" \
    && apt-get update \
    && apt-get -y install docker-ce \
    && apt-get install wget \
    && wget https://packages.microsoft.com/config/debian/10/packages-microsoft-prod.deb \
    && dpkg -i packages-microsoft-prod.deb \
    && apt-get update \
    && apt-get install -y powershell \
    && apt-get install git \
    && apt-get autoremove -y \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*
RUN groupmod -g ${DOCKER_GID} docker && usermod -a -G docker jenkins
USER jenkins
ENV JAVA_OPTS="-Djenkins.install.runSetupWizard=false"
ENV JENKINS_USER ${JENKINS_ADMIN_USER}
ENV JENKINS_PASS ${JENKINS_ADMIN_PASSWORD}
COPY plugins.txt /usr/share/jenkins/ref/
COPY default-user.groovy /usr/share/jenkins/ref/init.groovy.d/
RUN /usr/local/bin/install-plugins.sh < /usr/share/jenkins/ref/plugins.txt
