FROM node:18-alpine@sha256:8d6421d663b4c28fd3ebc498332f249011d118945588d0a35cb9bc4b8ca09d9e

# Install dependencies
RUN apk add --no-cache graphicsmagick tzdata \
 && apk add --no-cache --virtual .build-deps python3 build-base \
 && npm_config_user=root npm install --location=global n8n \
 && apk del .build-deps

# Set working directory
WORKDIR /data

# Create .n8n directory and give permissions AFTER switching to node user
USER node
RUN mkdir -p /home/node/.n8n

# Environment
ENV N8N_USER_ID=node

# Expose the correct port (Railway will inject PORT env var)
EXPOSE 5678

# Start n8n
CMD ["n8n", "start"]
