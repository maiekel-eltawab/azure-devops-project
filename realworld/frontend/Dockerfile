# Stage 1: Build React
FROM node:20-bookworm AS build

WORKDIR /app

COPY package.json yarn.lock ./

RUN corepack enable && yarn install --frozen-lockfile

COPY . .

ENV REACT_APP_BACKEND_URL=/api

RUN yarn build

# Stage 2: Serve React with Nginx
FROM nginx:stable-alpine

COPY nginx.conf /etc/nginx/conf.d/default.conf

COPY --from=build /app/build /usr/share/nginx/html

EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]
