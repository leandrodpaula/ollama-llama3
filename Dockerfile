FROM ubuntu:latest

COPY ollama . 

RUN ./install.sh
RUN ollama pull llama3.1

CMD [ "ollama", "run", "llama3.1" ]