FROM gcr.io/xander-the-harris-jenkins/agent:2019-06-29

RUN apk update
RUN apk add nodejs npm
RUN npm install -g gitbook
