const http = require('http');
const accesslog = require('access-log');
const hostname = '0.0.0.0';
const port = 3000;
 
const server = http.createServer((req, res) => {
  res.statusCode = 200;
  res.setHeader('Content-Type', 'text/html');
  accesslog(req, res);
  res.end('<h1><center>Hello World! this is a simple nodejs app running in a Docker container version 3</h1></center>');
});
 
server.listen(port, hostname, () => {
  console.log(`Server running at http://${hostname}:${port}/`);
});
