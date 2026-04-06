# Base image for backend
FROM node:21

# Set the working directory inside the container
WORKDIR /app

# Copy package.json and package-lock.json first
COPY package*.json ./

# Install dependencies
RUN npm install

# Copy rest of the application code
COPY . .

# Copy environment file (use .env or .env.sample)
COPY .env.sample .env

# Expose backend port
EXPOSE 5000

# Ensure Node runs with a stable user (avoid permission issues)
USER node

# Start the backend server
CMD ["npm", "start"]
