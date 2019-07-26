FROM billryan/gitbook

RUN apk update
RUN apk add nodejs npm
RUN npm install -g gitbook
