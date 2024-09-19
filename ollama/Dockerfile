FROM ubuntu:latest


USER root
RUN curl -fsSL https://ollama.com/install.sh | sh
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

CMD [ "/usr/bin/bash", "/entrypoint.sh" ]

