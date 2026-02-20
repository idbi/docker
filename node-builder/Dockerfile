# Use latest Node.js LTS base image
FROM node:lts

# Install OpenJDK 17 and rsync
RUN apt-get update && \
    apt-get install -y openjdk-17-jre rsync && \
    apt-get clean && \
    java -version && \
    node -v && \
    npm -v

# Set Docker working directory
WORKDIR /app

# Optionally: copy sources and install dependencies here, if needed
# COPY package*.json ./
# RUN npm install

# Default command is a bash shell for development or further commands
CMD ["bash"]