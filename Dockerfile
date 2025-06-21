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
RUN useradd -m -s /bin/bash ollama && echo "ollama ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers.d/ollama

# Switch to ollama user
USER ollama
WORKDIR /home/ollama

# Install Ollama CLI
RUN curl -fsSL https://ollama.com/download/ollama-linux-amd64.tgz -o ollama-linux-amd64.tgz && \
    tar -xzf ollama-linux-amd64.tgz -C /tmp && \
    sudo mv /tmp/ollama /usr/local/bin/ollama && \
    rm ollama-linux-amd64.tgz

# Start the Ollama server in background, pull model, and handle errors
RUN ollama serve & \
    sleep 10 && \
    ollama pull llama3 || { echo "Failed to pull llama3 model"; exit 1; } && \
    pkill ollama

# Expose default Ollama port
EXPOSE 11434

# Run Ollama server on container start
CMD ["ollama", "serve"]