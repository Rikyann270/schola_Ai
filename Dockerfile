# Use Ubuntu 22.04 as a lightweight base
FROM ubuntu:22.04

# Disable interactive frontend
ENV DEBIAN_FRONTEND=noninteractive

# Install minimal dependencies
RUN apt-get update && apt-get install -y \
    curl \
    sudo \
    ca-certificates \
    && rm -rf /var/lib/apt/lists/*

# Create a non-root user
RUN useradd -m -s /bin/bash ollama && echo "ollama ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers.d/ollama

# Switch to ollama user
USER ollama
WORKDIR /home/ollama

# Install Ollama CLI using the official install script
RUN curl -fsSL https://ollama.com/install.sh | sh && \
    [ -x /usr/local/bin/ollama ] || { echo "Ollama binary not installed"; exit 1; }

# Pull tinyllama model during build (faster, ~1.1B parameters)
RUN ollama serve & \
    sleep 10 && \
    ollama pull tinyllama || { echo "Failed to pull tinyllama model"; exit 1; } && \
    pkill ollama

# Set OLLAMA_HOST for Railway compatibility (binds to 0.0.0.0:11434)
ENV OLLAMA_HOST=0.0.0.0:11434
# Allow all origins to avoid 403 errors
ENV OLLAMA_ORIGINS=*

# Run Ollama server
CMD ["ollama", "serve"]