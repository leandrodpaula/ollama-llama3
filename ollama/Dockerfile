FROM ollama/ollama:latest


USER root
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

# Exponha a porta do serviço Ollama
EXPOSE 11434


ENTRYPOINT [ "/usr/bin/bash", "/entrypoint.sh" ]

