# Step 1: Use a Node image to build the React app
FROM node:18 AS build

# Set the working directory inside the container
WORKDIR /app

# Copy the package.json and package-lock.json to install dependencies
COPY package.json package-lock.json ./

# Install all dependencies
RUN npm install

# Copy the entire React app source code to the container
COPY . ./

# Build the React app for production
RUN npm run build

# Step 2: Serve the React app with a lightweight web server (Nginx)
FROM nginx:alpine

# Copy the build files from the build stage to the Nginx container
COPY --from=build /app/build /usr/share/nginx/html

# Expose port 80 to access the React app in the browser
EXPOSE 80

# Start Nginx to serve the React app
CMD ["nginx", "-g", "daemon off;"]
