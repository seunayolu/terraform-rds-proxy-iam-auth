FROM node:23-alpine

WORKDIR /app

RUN apk add --no-cache ca-certificates && \
    update-ca-certificates

COPY package*.json ./
RUN npm install --omit=dev

COPY src ./src

EXPOSE 3000
CMD ["node", "src/server.js"]