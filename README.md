# Simple Nodejs Hello world Docker image and container build
<br />

Hi there, Today I'm going to showing how we can dockerise a simple node js Hello World application

## Table of Contents
* [A simple hello world node js based application](#a-simple-hello-world-node-js-based-application)
* [Build a Docker image for the node js application](#build-a-docker-image-for-the-node-js-application)
* [Building a Container from our mynodeimage](#building-a-container-from-our-mynodeimage )


### A simple hello world node js based application
***
Here is a simple hello word code running in node js in which the aplication listens to the port 3000. I've also enabled access-log for the application as well
<br />

Before we begin, let's clone
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

# building from the alpine image which will consume less space in our host machine
FROM alpine:latest

# This is an Enviornment variable where I defined my working directory of application
ENV HOME_DIR /var/nodjs/

# This is an Enviornment variable where I defined the user which will run on the appliaction
ENV USER node
 
# This is an Enviornment variable where I defined which port should I run in the application
ENV PORT 3000

WORKDIR $HOME_DIR

# Installing necessary packages for the node js application to run
RUN apk update && apk add nodejs npm --no-cache
 
# Installing an addition package in order to show the access logs for the applicatiom
RUN npm install access-log
 
# Copying the code to the default home directory 
COPY ./code/ .
 
# Adding a new user with shell access 
RUN adduser -h $HOME_DIR -D -s /bin/sh $USER
 
 # User should have full privilege to home directory
RUN chown -R $USER. $HOME_DIR
 
# Once a container is build from image, the container should run as node user, this is for security purpose
USER $USER
 
# The port where my application should run 
EXPOSE $PORT
 
ENTRYPOINT ["node"]
 
CMD ["app.js"]
```
<br />

I've set some Enviornment variables where I defined home directory, user and port of the application, you can change as per your needs
<br />

Building a docker image. Make you're in the node-js directory before executing the command
```
docker image build -t mynodeimage:1 .
```
<br />

After executing the above command, you can see your custom docker image by executing ```docker image ls ``` with the name as mynodeimage


### Building a Container from our mynodeimage 
***

It's time to build the container from our custom image 
```sh
docker container run --name nodeapp -d -p 80:3000 mynodeimage:1
```

You can see your container running with a port mapping
```sh
]$ docker container ls -a
CONTAINER ID   IMAGE           COMMAND         CREATED         STATUS         PORTS                                   NAMES
21ecde87b960   mynodeimage:1   "node app.js"   5 seconds ago   Up 4 seconds   0.0.0.0:80->3000/tcp, :::80->3000/tcp   nodeapp

```

Once everything is donce you can call the IP address of the server either ```http://<Ip address of the server>``` to see the result.
 <br />
 <br />
![image](https://github.com/Chris-luiz-16/Simple-Nodejs-Hello-world-Docker-image-and-container-build/assets/128575317/b6056311-0add-4b06-b99d-80b820cbcff1)
