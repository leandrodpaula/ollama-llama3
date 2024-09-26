FROM ollama/ollama:0.3.12


USER root
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh
RUN mkdir -p /var/lib/ollama
# Exponha a porta do serviço Ollama
EXPOSE 11434


ENTRYPOINT [ "/usr/bin/bash", "/entrypoint.sh" ]

