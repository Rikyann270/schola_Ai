# Use Ubuntu 22.04 as a lightweight base
FROM ubuntu:22.04

# Disable interactive frontend
ENV DEBIAN_FRONTEND=noninteractive

# Install minimal dependencies
RUN apt-get update && apt-get install -y \
    curl \
    tar \
    sudo \
    ca-certificates \
    && rm -rf /var/lib/apt/lists/*

# Create a non-root user
RUN useradd -m -s /bin/bash ollama && echo "ollama ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers.d/ollama

# Switch to ollama user
USER ollama
WORKDIR /home/ollama

# Install Ollama CLI
RUN curl -fsSL https://ollama.com/download/ollama-linux-amd64.tgz -o ollama-linux-amd64.tgz && \
    tar -xzf ollama-linux-amd64.tgz && \
    [ -f ollama ] || { echo "Ollama binary not found"; exit 1; } && \
    sudo mv ollama /usr/local/bin/ollama && \
    chmod +x /usr/local/bin/ollama && \
    rm ollama-linux-amd64.tgz

# Pull llama3 model during build
RUN ollama serve & \
    sleep 10 && \
    ollama pull llama3 || { echo "Failed to pull llama3 model"; exit 1; } && \
    pkill ollama

# Set environment variable for Railway port (defaults to 11434 if not set)
ENV PORT=11434

# Run Ollama server, binding to 0.0.0.0 for Railway
CMD ["/bin/sh", "-c", "ollama serve --host 0.0.0.0 --port ${PORT}"]