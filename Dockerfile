# Prepearing production build
FROM node:14-alpine as build

LABEL name="Cart API Build"
LABEL version="1.0.0"

WORKDIR /app

COPY package*.json ./
RUN npm ci && npm cach clean --force

COPY nest-cli.json tsconfig*.json ./

COPY src ./src
RUN npm run build && npm cach clean --force

# Creating production image using prepared build
FROM node:14-alpine as release

LABEL name="Cart API"
LABEL version="1.0.0"

WORKDIR /app

COPY package*.json ./
RUN npm ci --only=production

COPY --from=build app/dist ./

ENV PORT=80
EXPOSE 80
CMD ["node", "main"]
