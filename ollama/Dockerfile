FROM ollama/ollama:latest


USER root
WORKDIR /bin/ollama
COPY entrypoint.sh /entrypoint.sh

CMD [ "/usr/bin/bash", "/entrypoint.sh" ]