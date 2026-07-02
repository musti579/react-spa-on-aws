FROM node:20-alpine@sha256:fb4cd12c85ee03686f6af5362a0b0d56d50c58a04632e6c0fb8363f609372293 AS build 

# Base Image for node app 

WORKDIR /app

# Current Working directory 

COPY package.json yarn.lock ./

RUN yarn install --frozen-lockfile --network-timeout 600000

COPY . .

RUN yarn build


FROM node:20-alpine@sha256:fb4cd12c85ee03686f6af5362a0b0d56d50c58a04632e6c0fb8363f609372293

WORKDIR /app

COPY --from=build /app/build ./build 

RUN addgroup -S appgroup && adduser -S appuser -G appgroup

USER appuser

EXPOSE 3000

CMD [ "yarn", "start" ]
