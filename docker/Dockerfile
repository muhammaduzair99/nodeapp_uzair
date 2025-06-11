FROM node:18

# Set working directory
WORKDIR /usr/src/app

# Copy dependency files and install
COPY package*.json ./
RUN npm install

# Copy app source code (including .env)
COPY . .

# Expose port and run app
EXPOSE 3000
CMD ["node", "index.js"]
