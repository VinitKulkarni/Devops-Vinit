# Stage 1: Build the React application
FROM node:18 AS build

# Set the working directory for the React app
WORKDIR /app

# Install dependencies
COPY package.json package-lock.json ./
RUN npm install

# Copy the source code of the React app
COPY . ./

# Build the React application for production
RUN npm run build

# Stage 2: Set up Express server
FROM node:18 AS production

# Set the working directory for the Express server
WORKDIR /app

# Install dependencies for Express (backend)
COPY package.json package-lock.json ./
RUN npm install --production

# Copy the built React app and server code from the build stage
COPY --from=build /app/build /app/build

# Copy the Express server files
COPY server.js ./  # Assume server.js is in the root directory of your project

# Expose the port the app runs on
EXPOSE 5000

# Set the environment variable to production
ENV NODE_ENV=production

# Start the Express server that serves the React app
CMD ["node", "server.js"]
