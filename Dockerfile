FROM node:7-alpine
MAINTAINER devops@demandbase.com

RUN mkdir -p /app

WORKDIR /app/

RUN set -ex && \
        buildDeps=' \
        ' && \
        runDeps=' \
                curl \
                bash \
        ' && \
        apk --no-cache add $buildDeps $runDeps && \
        npm install node-json2html && \
        apk del $buildDeps

COPY . /app/

EXPOSE 8889

ENTRYPOINT ["node"]
CMD ["app.js"]
