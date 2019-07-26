FROM jenkins/jnlp-slave:alpine

RUN apk update
RUN apk add nodejs npm
RUN npm install -g gitbook

ENTRYPOINT ["gitbook"]
