# Use a slim Node.js image with Alpine Linux
FROM node:18-alpine AS builder

# Set working directory
WORKDIR /app

# Copy package.json
COPY package*.json ./

# Install dependencies
RUN npm ci

# Copy the entire project directory (excluding package-lock.json)
COPY . .

# Build for production (adjust command if needed)
RUN npm run build

# Switch to a smaller runtime image without Node.js and NPM
FROM nginx:alpine

# Set working directory
WORKDIR /app

# Copy only the production-ready build files
COPY --from=builder /app/dist .

# Expose the default web server port (can be overridden)
EXPOSE 8080

# Configure Nginx to serve static content
COPY nginx.conf /etc/nginx/conf.d/default.conf

# Start Nginx
CMD [ "nginx", "-g", "daemon off;" ]
