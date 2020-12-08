# preparing
FROM node:15.3.0-alpine3.10 as build

WORKDIR /app

COPY src \
     package*.json \
     nest-cli.json \
     tsconfig*.json ./

RUN npm ci --also=dev
RUN npm run build 
RUN npm prune --production

# go
FROM node:15.3.0-alpine3.10 

ARG NODE_ENV=production
ENV NODE_ENV $NODE_ENV

RUN npm install pm2 -g

COPY --from=build ./app .

USER node
ENV PORT=8080
EXPOSE 8080

CMD ["pm2-runtime", "./dist/main.js"] 
