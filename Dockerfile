# Use Ubuntu 22.04 as base
FROM ubuntu:22.04

# Disable interactive frontend
ENV DEBIAN_FRONTEND=noninteractive

# Install system dependencies
RUN apt-get update && apt-get install -y \
    curl \
    unzip \
    sudo \
    ca-certificates \
    gnupg \
    && rm -rf /var/lib/apt/lists/*

# Create a non-root user for safety
RUN useradd -m -s /bin/bash ollama && echo "ollama ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers

# Switch to ollama user
USER ollama
WORKDIR /home/ollama

# Install Ollama CLI
RUN curl -fsSL https://ollama.com/download/Ollama-linux.zip -o ollama.zip && \
    unzip ollama.zip && \
    sudo mv ollama /usr/local/bin/ollama && \
    rm ollama.zip

# Start the Ollama server in background and pull model
RUN ollama serve & \
    sleep 10 && \
    ollama pull llama3 && \
    pkill ollama

# Expose default Ollama port
EXPOSE 11434

# Run Ollama server on container start
CMD ["ollama", "serve"]
