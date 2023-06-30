FROM alpine:latest

ENV HOME_DIR /var/nodjs/

ENV USER node
 
ENV PORT 3000

WORKDIR $HOME_DIR

RUN apk update && apk add nodejs npm --no-cache
 
RUN npm install access-log
 
COPY ./code/ .
 
RUN adduser -h $HOME_DIR -D -s /bin/sh $USER
 
RUN chown -R $USER. $HOME_DIR
 
USER $USER
 
EXPOSE $PORT
 
ENTRYPOINT ["node"]
 
CMD ["app.js"]
