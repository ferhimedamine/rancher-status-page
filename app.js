// This just scans metadata in rancher API, and
// makes a shiny new table

const spawn = require('child_process').spawn;
var fs = require("fs");

var http = require('http'),
    fs   = require('fs');

html     = "";


http.createServer(function(request, response) {  
     fs.open('index.html', 'w', (err, fd) => {
       // => [Error: EISDIR: illegal operation on a directory, open <directory>]
     
       console.log("listening on port 8889");
     
       const curl = spawn('sh', ['data.sh']);
     
       curl.stdout.on('data', (data) => {
         console.log(`${data}`);
         fs.appendFile(fd, data, function(error) {
            if (error) {
              console.error("write error:  " + error.message);
            } else {
              console.log("Successful Write to index.html");
            }
         });
       });
     
       curl.stderr.on('data', (data) => {
         console.log(`${data}`);
       });
     
       curl.on('close', (code) => {
         console.log(`child process exited with code ${code}`);
           fs.readFile('index.html', function (err, html) {
             if (err) {
               throw err; 
             }       
 
             response.writeHeader(200, {"Content-Type": "text/html"});  
             response.write(html);  
             response.end();  
           });
       });
       
     });

}).listen(8889);
          
