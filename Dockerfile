# Use an official Node.js runtime as base image
FROM node:18-slim

# Set working directory inside the container
WORKDIR /app

# Copy only package files first for better caching
COPY package*.json ./

# Install dependencies
RUN npm install --production

# Copy remaining application files
COPY . .

# Set environment variables (optional defaults)
ENV PORT=3000
ENV NODE_ENV=production

# Expose the port
EXPOSE 3000

# Run the application
CMD ["node", "server.js"]
