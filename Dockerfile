FROM node:22-bookworm-slim AS builder

WORKDIR /app

COPY package.json package-lock.json ./
RUN npm ci

COPY . .
RUN npm run build


FROM node:22-bookworm-slim AS final

RUN apt-get update && \
    apt-get install -y --no-install-recommends \
      cups \
      cups-client \
      cups-bsd \
      poppler-utils \
      libcups2 \
      ca-certificates \
      && rm -rf /var/lib/apt/lists/*

WORKDIR /app

COPY --from=builder /app .

EXPOSE 3000

ENV NODE_ENV=production

CMD ["npm", "run", "start"]
