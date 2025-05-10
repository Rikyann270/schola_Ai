FROM node:18-alpine@sha256:8d6421d663b4c28fd3ebc498332f249011d118945588d0a35cb9bc4b8ca09d9e

# Install dependencies
RUN apk add --update --no-cache graphicsmagick tzdata

# Install build dependencies, install n8n, and clean up
RUN apk add --update --virtual build-dependencies python3 build-base && \
    npm_config_user=root npm install --location=global n8n && \
    apk del build-dependencies

# Set working directory
WORKDIR /data

# Create n8n data directory and set permissions
RUN mkdir -p /home/node/.n8n && \
    chown -R node:node /home/node/.n8n && \
    chmod -R 755 /home/node/.n8n

# Run as non-root user
USER node
ENV N8N_USER_ID=node

# Expose port
EXPOSE $PORT

# Start n8n
CMD ["n8n", "start"]