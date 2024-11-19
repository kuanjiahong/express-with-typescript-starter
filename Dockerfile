FROM node:20.18.0-bookworm-slim AS base

FROM base AS deps
WORKDIR /app
COPY package.json .
RUN npm install

FROM base AS builder
WORKDIR /app
COPY --from=deps /app/node_modules ./node_modules
COPY . .
RUN npm run build

# Production image
FROM base AS runner
WORKDIR /app
ENV NODE_ENV=production
ENV PORT=8080

COPY --from=builder --chown=node:node /app/dist ./dist
COPY --from=builder --chown=node:node /app/node_modules ./node_modules

EXPOSE 3000
USER node
CMD [ "node", "dist/index.js"]