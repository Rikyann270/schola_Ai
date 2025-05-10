FROM node:18-alpine@sha256:8d6421d663b4c28fd3ebc498332f249011d118945588d0a35cb9bc4b8ca09d9e

# Install dependencies
RUN apk add --update --no-cache graphicsmagick tzdata

# Install build dependencies, install n8n, and clean up
RUN apk add --update --virtual build-dependencies python3 build-base && \
    npm_config_user=root npm install --location=global n8n && \
    apk del build-dependencies

# Set working directory
WORKDIR /data

# Run as root (keeping your existing setup)
USER root
ENV N8N_USER_ID=root

# Environment variables for n8n production URLs
ENV NODE_ENV=production
ENV N8N_PORT=$PORT
ENV N8N_HOST=0.0.0.0
ENV N8N_PROTOCOL=https
ENV WEBHOOK_URL=https://schola-aiworkflow.up.railway.app/

# Expose port
EXPOSE $PORT

# Start n8n
CMD ["n8n", "start"]