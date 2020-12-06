FROM node:15.3.0-alpine3.10 as build

WORKDIR /app

COPY package*.json ./
RUN npm ci --also=dev 

# build
COPY . .
RUN npm run build

#2
FROM node:15.3.0-alpine3.10 

ARG NODE_ENV=production
ENV NODE_ENV $NODE_ENV

COPY --from=build /app/package*.json ./
RUN npm ci --only production && npm install pm2 -g

COPY --from=build ./app/dist /dist/

USER node
ENV PORT=8080
EXPOSE 8080

CMD ["pm2-runtime", "./dist/main.js"] 
