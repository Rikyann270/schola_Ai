# Set working directory
WORKDIR /data

# Switch to node user early
USER node

# Create and initialize n8n data directory with proper permissions
RUN mkdir -p /home/node/.n8n && \
    touch /home/node/.n8n/config && \
    touch /home/node/.n8n/n8n.sqlite

# Environment
ENV N8N_USER_ID=node

# Expose port
EXPOSE $PORT

# Start n8n
CMD ["n8n", "start"]
