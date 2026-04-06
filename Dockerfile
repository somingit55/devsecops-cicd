# Base image for frontend
FROM node:21

# Set working directory
WORKDIR /frontend

# Copy package.json and package-lock.json first
COPY package*.json ./

# Install dependencies
RUN npm install

# Copy rest of the frontend code
COPY . .

# Copy environment file
COPY .env.sample .env.local

# Expose frontend port
EXPOSE 3000

# Use non-root user to avoid permission issues
USER node

# Start frontend in dev mode with host binding
CMD ["npm", "run", "dev", "--", "--host"]
