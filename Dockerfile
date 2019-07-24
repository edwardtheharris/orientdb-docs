FROM jenkins/jnlp-slave:alpine

RUN apk update
RUN apk add gitbook
