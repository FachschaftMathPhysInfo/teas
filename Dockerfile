FROM node:26-bookworm-slim AS builder

WORKDIR /app

COPY package.json package-lock.json ./
RUN npm ci

COPY . .

RUN npm run build


FROM node:26-bookworm-slim AS final

RUN apt-get update && \
    apt-get install -y --no-install-recommends \
      cups \
      cups-client \
      cups-bsd \
      poppler-utils \
      ca-certificates \
      && rm -rf /var/lib/apt/lists/*

WORKDIR /app

ENV NODE_ENV=production
ENV PORT=3000

COPY --from=builder /app/.next/standalone ./
COPY --from=builder /app/.next/static ./.next/static
COPY --from=builder /app/public ./public

EXPOSE 3000

CMD ["node", "server.js"]
