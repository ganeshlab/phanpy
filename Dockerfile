FROM node:alpine AS build

WORKDIR /build
ADD . /build

RUN apk add --no-cache git buildkit
RUN npm install
RUN npm run build

FROM alpine:3

LABEL maintainer="ganeshlab"

RUN apk add --update --no-cache lighttpd

ADD lighttpd.conf /etc/lighttpd/lighttpd.conf
COPY --from=build /build/dist /app

EXPOSE 80

ENTRYPOINT ["lighttpd", "-D"]
CMD ["-f", "/etc/lighttpd/lighttpd.conf"]
