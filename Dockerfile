FROM node:18-alpine@sha256:8d6421d663b4c28fd3ebc498332f249011d118945588d0a35cb9bc4b8ca09d9e

# Install dependencies
RUN apk add --no-cache graphicsmagick tzdata \
 && apk add --no-cache --virtual .build-deps python3 build-base

# Set working directory
WORKDIR /data

# Switch to node user
USER node

# Install n8n locally in /home/node
RUN npm install --prefix /home/node n8n

# Create .n8n directory
RUN mkdir -p /home/node/.n8n

# Environment
ENV N8N_USER_ID=node
ENV PATH=/home/node/node_modules/.bin:$PATH

# Expose the correct port
EXPOSE 5678

# Start n8n
CMD ["n8n", "start"]