# ===========================================
# DOCKER MULTISTAGE BUILD FOR ANIMATED CHATBOT
# ===========================================

# Stage 1: Development Stage
# This stage includes all development dependencies and tools
FROM node:18-alpine AS development

# Set working directory
WORKDIR /app

# Install development dependencies
RUN apk add --no-cache git curl

# Copy package files
COPY package*.json ./

# Install all dependencies (including dev dependencies)
RUN npm ci

# Copy source code
COPY . .

# Expose development port
EXPOSE 3000

# Development command with nodemon for hot reloading
CMD ["npm", "run", "dev"]

# Stage 2: Build Stage
# This stage is used for building and testing the application
FROM node:18-alpine AS build

# Set working directory
WORKDIR /app

# Install build dependencies
RUN apk add --no-cache python3 make g++

# Copy package files
COPY package*.json ./

# Install all dependencies
RUN npm ci

# Copy source code
COPY . .

# Run tests (if any)
RUN npm test || true

# Build the application (if needed)
RUN npm run build

# Stage 3: Production Stage
# This stage creates the final optimized production image
FROM node:18-alpine AS production

# Create non-root user for security
RUN addgroup -g 1001 -S nodejs
RUN adduser -S chatbot -u 1001

# Set working directory
WORKDIR /app

# Install production dependencies only
COPY package*.json ./
RUN npm ci --only=production && npm cache clean --force

# Copy built application from build stage
COPY --from=build /app/server.js ./
COPY --from=build /app/public ./public

# Change ownership to non-root user
RUN chown -R chatbot:nodejs /app
USER chatbot

# Expose production port
EXPOSE 3000

# Health check
HEALTHCHECK --interval=30s --timeout=3s --start-period=5s --retries=3 \
    CMD curl -f http://localhost:3000/health || exit 1

# Production command
CMD ["npm", "start"]

# Stage 4: Optimized Production Stage (Alternative)
# This stage uses a minimal base image for even smaller size
FROM node:18-alpine AS production-optimized

# Install only necessary packages
RUN apk add --no-cache dumb-init

# Create non-root user
RUN addgroup -g 1001 -S nodejs
RUN adduser -S chatbot -u 1001

# Set working directory
WORKDIR /app

# Copy production dependencies from build stage
COPY --from=build /app/node_modules ./node_modules
COPY --from=build /app/package*.json ./

# Copy application files
COPY --from=build /app/server.js ./
COPY --from=build /app/public ./public

# Change ownership
RUN chown -R chatbot:nodejs /app
USER chatbot

# Expose port
EXPOSE 3000

# Use dumb-init for proper signal handling
ENTRYPOINT ["dumb-init", "--"]

# Production command
CMD ["node", "server.js"]

# Stage 5: Multi-architecture Build Stage
# This stage supports multiple CPU architectures
FROM --platform=$BUILDPLATFORM node:18-alpine AS multiarch

# Set working directory
WORKDIR /app

# Copy package files
COPY package*.json ./

# Install dependencies
RUN npm ci --only=production

# Copy application files
COPY server.js ./
COPY public ./public

# Expose port
EXPOSE 3000

# Production command
CMD ["node", "server.js"]
