FROM demandbase/db-alpine-node:v5.10.1

RUN mkdir /app

COPY . /app/

WORKDIR /app/

RUN ls /app/*

RUN apk update && \
    apk add curl && \
    npm install -g node-json2html

EXPOSE 8889

ENTRYPOINT ["node"]
CMD ["app.js"]

