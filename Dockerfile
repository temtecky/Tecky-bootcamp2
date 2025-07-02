# Use official Node.js runtime as base image
FROM node:18-alpine

# Build arguments for CI/CD metadata
ARG NODE_ENV=production
ARG APP_VERSION=1.0.0
ARG BUILD_TIME
ARG GIT_COMMIT

# Set environment variables
ENV NODE_ENV=${NODE_ENV}
ENV APP_VERSION=${APP_VERSION}
ENV BUILD_TIME=${BUILD_TIME}
ENV GIT_COMMIT=${GIT_COMMIT}
ENV PORT=3000

# Set working directory in container
WORKDIR /app

# Copy package files first for better caching
COPY package*.json ./

# Install dependencies
RUN npm ci --only=production && npm cache clean --force

# Copy application files
COPY server.js ./
COPY public/ ./public/
COPY .env ./

# Create non-root user for security
RUN addgroup -g 1001 -S appuser && \
    adduser -S appuser -u 1001 -G appuser

# Change ownership and switch to non-root user
RUN chown -R appuser:appuser /app
USER appuser

# Expose port
EXPOSE 3000

# Health check
HEALTHCHECK --interval=30s --timeout=3s --start-period=5s --retries=3 \
  CMD node -e "require('http').get('http://localhost:3000/health', (res) => { process.exit(res.statusCode === 200 ? 0 : 1) })"

# Start application
CMD ["npm", "start"]