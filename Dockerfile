FROM node:7.4-alpine
MAINTAINER devops@demandbase.com

# Add bash. By default, alpine only has /bin/sh
RUN apk add --no-cache bash

RUN mkdir -p /app

WORKDIR /app/
COPY . /app/

RUN apk --no-cache add \
         curl && \
    npm install -g node-json2html

EXPOSE 8889

ENTRYPOINT ["node"]
CMD ["app.js"]
