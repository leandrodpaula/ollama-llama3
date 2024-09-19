FROM ubuntu:latest


USER root
RUN curl -fsSL https://ollama.com/install.sh | sh
COPY entrypoint.sh /entrypoint.sh

RUN ls /usr/bin/ollama
RUN sleep 5

CMD [ "/usr/bin/bash", "/entrypoint.sh" ]

