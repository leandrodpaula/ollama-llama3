FROM ollama/ollama:latest

RUN ollama pull llama3.1

CMD [ "ollama", "run", "llama3.1" ]