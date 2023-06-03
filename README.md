# Simple Nodejs Hello world Docker image and container build
<br />

Hi there, Today I'm going to showing how we can dockerise a simple node js Hello World application

## Table of Contents
* [A simple hello world node js based application](#a-simple-hello-world-node-js-based-application)
* [Build a Docker image for the node js application](#build-a-docker-image-for-the-node-js-application)


### A simple hello world node js based application
***
Here is a simple hello word code running in node js in which the aplication listens to the port 3000. I've also enabled access-log for the application as well
<br />

Before we begin, let's create a project directory 

```sh
mkdir node-js
mkdir -p node-js/code
touch node-js/code/app.js
```
<br />

Time to paste the below node js code to our **app.js** file

<br />

```java
const http = require('http');
var accesslog = require('access-log');
const hostname = '0.0.0.0';
const port = 3000;
 
const server = http.createServer((req, res) => {
  res.statusCode = 200;
  res.setHeader('Content-Type', 'text/html');
  accesslog(req, res);
  res.end('<h1><center>Hello World! this is a simple nodejs app running in a Docker container</h1></center>');
});
 
server.listen(port, hostname, () => {
  console.log(`Server running at http://${hostname}:${port}/`);
});
```

### Build a Docker image for the node js application
***

Let's build a docker image for the nodejs application from the code we made so that we can build a container from the custom image that we build.

Before beginning lets' make a **Dockerfile** in our project directory **node.js**

```sh
cd node-js
touch Dockerfile
```
<br />

Time to build the docker image make sure to copy the below content in **Dockerfile**

```sh
FROM alpine:latest
 
ENV HOME_DIR /var/nodjs/
 
ENV USER node
 
ENV PORT 3000
 
WORKDIR $HOME_DIR
 
RUN apk update && apk add nodejs npm
 
RUN npm install access-log
 
COPY ./code/ .
 
RUN adduser -h $HOME_DIR -D -s /bin/sh $USER
 
RUN chown -R $USER. $HOME_DIR
 
USER $USER
 
EXPOSE $PORT
 
ENTRYPOINT ["node"]
 
CMD ["app.js"]
```

