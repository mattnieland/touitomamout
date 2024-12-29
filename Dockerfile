FROM node:lts-alpine

WORKDIR /app

COPY src/ /app/src
COPY scripts/ /app/scripts
COPY package.json package-lock.json tsconfig.json .eslintrc.json vite.config.ts /app/

RUN npm ci --ignore-scripts && npm rebuild --platform=linux --libc=musl sharp && npm run build --ignore-scripts

# Add read and write privileges to the /data directory
RUN mkdir -p /data && chown -R node:node /data

# Declare the /data directory as a volume
VOLUME ["/data"]

USER node

# Ensure the /data directory is writable by the node user
RUN chmod -R u+rw /data

CMD node /app/dist/index.js