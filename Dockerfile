FROM node:lts-alpine3.21 AS base

FROM base AS deps
WORKDIR /app
COPY package.json .
RUN npm install

FROM base AS builder
WORKDIR /app
COPY --from=deps /app/node_modules ./node_modules
COPY --from=deps /app/package.json ./package.json
COPY ./src ./src
COPY ./tsconfig.json ./
RUN npm run build

# Production image
FROM base AS runner
WORKDIR /app
ENV NODE_ENV=production
ENV PORT=8080

COPY --from=builder --chown=root:root --chmod=755 /app/dist ./dist
COPY --from=builder --chown=root:root --chmod=755 /app/node_modules ./node_modules

EXPOSE 8080
USER node
CMD [ "node", "dist/index.js"]