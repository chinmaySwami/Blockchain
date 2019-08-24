var express = require('express');
var path = require('path');
var favicon = require('serve-favicon');
var logger = require('morgan');
var bodyParser = require('body-parser');
const MongoClient = require('mongodb');
var cors = require('cors')

const CONNECTION_URL = "mongodb+srv://airlineA:br1ngM3Than0s@blockchain-qzolf.mongodb.net/flights?retryWrites=true";
const AIRLINEA = "airlineA";
const AIRLINEB = "airlineB";

MongoClient.connect(CONNECTION_URL, { useNewUrlParser:true },(error,client)=>{
    if(error) {
        throw error;
    }
    databaseA = client.db(AIRLINEA);
    databaseB = client.db(AIRLINEB);
    flightsA = databaseA.collection("flights");
    flightsB = databaseB.collection("flights");
    usersA = databaseA.collection("users");
    usersB = databaseB.collection("users");
    flightReqA = databaseA.collection("flight_requests");
    flightReqB = databaseB.collection("flight_requests");
    console.log("Connected to the database");
})

var requestA = require('./routes/requestA');
var requestB = require('./routes/requestB');
var app = express();

app.use(logger('dev'));
app.use(cors())
app.use(bodyParser.json());
app.use(bodyParser.urlencoded({'extended':'false'}));
app.use(express.static(path.join(__dirname, 'dist')));
app.use('/requestA', express.static(path.join(__dirname, 'dist')));
app.use('/requesta', requestA);
app.use('/addA', requestA);
app.use('/userA',requestA);
app.use('/updateFlightA',requestA);

// Endpoints for B
app.use('/requestB', requestB);
app.use('/addB', requestB);
app.use('/userB',requestB);
app.use('/updateFlightB',requestB);


// catch 404 and forward to error handler
app.use(function(req, res, next) {
  var err = new Error('Not Found');
  err.status = 404;
  next(err);
});

// error handler
app.use(function(err, req, res, next) {
  // set locals, only providing error in development
  res.locals.message = err.message;
  res.locals.error = req.app.get('env') === 'development' ? err : {};

  // render the error page
  res.status(err.status || 500);
  res.render('error');
});
;

module.exports = app;