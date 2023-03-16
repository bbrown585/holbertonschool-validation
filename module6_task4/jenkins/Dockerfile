FROM jenkins/jenkins:lts-jdk11

ENV JAVA_OPTS -Djenkins.install.runSetupWizard=false -Dcasc.jenkins.config=/var/jenkins_home/casc_configs

COPY --chown=jenkins:jenkins ./casc.yaml /var/jenkins_home/casc_configs/casc.yaml
COPY --chown=jenkins:jenkins ./plugins.txt /usr/share/jenkins/ref/plugins.txt
COPY --chown=jenkins:jenkins ./awesome-key.pem /var/jenkins_home/.ssh/awesome-key.pem
COPY --chown=jenkins:jenkins ./awesome-key.pub /var/jenkins_home/.ssh/authorized_keys

RUN jenkins-plugin-cli -f /usr/share/jenkins/ref/plugins.txt