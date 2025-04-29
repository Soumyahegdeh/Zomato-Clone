# ---- Build Stage ----
FROM node:18-alpine AS builder

# Set working directory
WORKDIR /app

# Copy dependency definitions
COPY package*.json ./

# Install ALL dependencies (including devDependencies, needed for build)
RUN npm ci

# Copy the rest of the source code
COPY . .

# Build the React app
RUN npm run build

# ---- Production Stage ----
FROM node:18-alpine

# Set working directory
WORKDIR /app

# Copy package.json and lock file
COPY package*.json ./

# Install only production dependencies
RUN npm ci --only=production

# Copy built React app from builder
COPY --from=builder /app/build ./build

# Expose the app port (adjust if needed)
EXPOSE 3005

# Optional: install `serve` to serve static files (you can use your own Express server if you prefer)
RUN npm install -g serve

# Serve the production build
CMD ["serve", "-s", "build", "-l", "3005"]

