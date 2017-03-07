// This just scans metadata in rancher API, and
// makes a shiny new table

const spawn = require('child_process').spawn;
var fs = require("fs");

var http = require('http'),
    fs   = require('fs');

// Use sleep module
var sleep = require('sleep');

html     = "";


http.createServer(function(request, response) {
     // sleep for 30 seconds before re-creating page
     sleep.sleep(30)
     fs.open('index.html', 'w', (err, fd) => {
       // => [Error: EISDIR: illegal operation on a directory, open <directory>]

       const script_call = spawn('sh', ['data.sh']);

       script_call.stdout.on('data', (data) => {
         fs.appendFile(fd, data, function(error) {
            if (error) {
              console.error("write error:  " + error.message);
            }
         });
       });

       script_call.stderr.on('data', (data) => {
         console.log(`${data}`);
       });

       script_call.on('close', (code) => {
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
