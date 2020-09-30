FROM node:14-slim AS builder

WORKDIR /build
COPY app ./app
COPY dev_packages ./dev_packages
ARG TOKEN

RUN cd /build/app && \
		rm -f .npmrc && \
    echo //npm.pkg.github.com/:_authToken=$TOKEN > .npmrc && \
    echo @excalibur-enterprise:registry=https://npm.pkg.github.com >> .npmrc && \
    npm ci && \
    rm -f .npmrc

FROM node:14-slim
WORKDIR /build
COPY --from=builder /build .

ENV NODE_TLS_REJECT_UNAUTHORIZED=0

CMD [ "node", "./app/index.js" ]