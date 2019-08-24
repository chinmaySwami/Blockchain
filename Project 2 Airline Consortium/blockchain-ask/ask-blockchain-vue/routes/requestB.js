
var express = require('express');
var mongo = require('mongodb');
var router = express.Router();

/* GET home page. */
router.get("/", (request, response) => {
    flightReqB.find({"decision": "0"}).toArray(function(err,items){
        if(err){
            throw err
        } else{
            response.send(items)
        }
    })
});
// Need to fine tune this
router.get("/:source/:destination/:date/:seats", (request, response) => {
    flightsB.findOne({ "source": request.params.source, "destination": request.params.destination, "date": request.params.date, "seatsAvail": {$gte: request.params.seats} }, (error, result) => {
        if(error) {
            return response.status(500).send(error);
        }
        if(result === null) {
            result = {"source": "Not Found", "destination": "Not Found", "date": "Not Found"}
        }
        response.send(result);
    });
});

router.post("/",(request,response) => {
    flightReqB.insertOne(request.body, function(err,post){
        if(err) {
            throw err;
        }
        response.send(post);
    })
})

router.get("/:username/:password",(request,response) => {
    usersB.findOne({"username":request.params.username, "password": request.params.password}, (error, result) => {
        if(error) {
            return response.status(500).send(error);
        }
        if(result === null) {
            result = {"username": "Not Found", "password": "Not Found"}
        }
        response.send(result);
    });
});

router.put('/:r/:id', (request,response,next) => {
    var o_id = new mongo.ObjectID(request.params.id)
    if(request.params.r === 'r'){
        flightReqB.updateOne({'_id':o_id},{$set:request.body},function(err,post){
            if(err){
                return next(err);
            }
            response.send(post)
        })
    }
    if(request.params.r === 'm'){
        flightsB.updateOne({'_id':o_id},{$set:request.body},function(err,post){
            if(err){
                return next(err);
            }
            response.send(post)
        })
    }
})
module.exports = router;
