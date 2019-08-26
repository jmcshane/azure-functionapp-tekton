FROM ubuntu:latest
RUN apt-get update && apt-get install -y ca-certificates curl wget apt-transport-https lsb-release gnupg && \
  curl -sL https://packages.microsoft.com/keys/microsoft.asc | \
    gpg --dearmor | \
    tee /etc/apt/trusted.gpg.d/microsoft.asc.gpg > /dev/null && \
  AZ_REPO=$(lsb_release -cs) && \
  echo "deb [arch=amd64] https://packages.microsoft.com/repos/azure-cli/ $AZ_REPO main" | \
    tee /etc/apt/sources.list.d/azure-cli.list && \
  apt-get update && apt-get install -y azure-cli && \
  wget -q https://packages.microsoft.com/config/ubuntu/19.04/packages-microsoft-prod.deb && \
  dpkg -i packages-microsoft-prod.deb && \
  apt-get update && apt-get install -y azure-functions-core-tools

ADD deploy.sh /