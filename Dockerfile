FROM node:7.4-alpine
MAINTAINER devops@demandbase.com

RUN mkdir -p /app

WORKDIR /app/
COPY . /app/

RUN apk --no-cache add \
    curl bash && \
    npm install -g node-json2html sleep

EXPOSE 8889

ENTRYPOINT ["node"]
CMD ["app.js"]
