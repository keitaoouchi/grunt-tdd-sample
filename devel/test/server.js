var express = require('express');
var http = require('http');

var app = express();

app.configure(function(){
  app.set('port', process.env.PORT || 8080);
  app.set('view engine', 'jade');
  app.use(express.static('./../'));
});


app.get(/(.+)(\/.+)?/, function(req, res){
  var path = req.params[0].replace('/', '');
  res.render(__dirname + '/template', {target: path});
});

http.createServer(app).listen(app.get('port'), function(){
  console.log("Express server listening on port " + app.get('port'));
});