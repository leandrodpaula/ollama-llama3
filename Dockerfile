FROM ubuntu:latest

RUN curl -fsSL https://ollama.com/install.sh | sh
RUN ollama pull llama3.1

CMD [ "ollama", "run", "llama3.1" ]