<template>
  <div>
    <h3>
      Requests {{ airline }}
      <b-button size="sm" type="submit" variant="primary" v-on:click="refresh">Refresh</b-button>
    </h3>
    <b-row>
      <b-col cols="12">
        <b-table striped hover :items="flights[0]" :fields="fields">
          <template slot="decision" scope="row">
            <b-btn size="sm" variant="success" v-on:click="acceptRequest(row.item)">Accept</b-btn>&nbsp;
            <b-btn size="sm" variant="danger" v-on:click="rejectRequest(row.item)">Reject</b-btn>
          </template>
        </b-table>
      </b-col>
    </b-row>
  </div>
</template>

<script>
import axios from "axios";
import "bootstrap/dist/css/bootstrap.css";
import "bootstrap-vue/dist/bootstrap-vue.css";
import BootstrapVue from "bootstrap-vue";
import {address, ABI} from '../Util/constants/casinoContract'

export default {
  name: "handleIncomingRequests",
  data() {
    return {
      fields: {
        source: { label: "Source", sortable: true, class: "text-center" },
        destination: { label: "Destination", sortable: true },
        date: { label: "Date", class: "text-center" },
        numSeats: { label: "Seats Requested", class: "text-center" },
        totalPrice: { label: "Total Price of the Req", class: "text-center"},
        addedBy: { label: "Added By", class: "text-center" },
        postedBy: {label: "Airline Address",class: "text-center"},
        decision: { label: "Decision", class: "text-center" }
      },
      flights: []
    };
  },
  props: ["airline",
"web3Obj"
],
  created() {
    var endpoint = "http://127.0.0.1:3000/request" + this.airline + "/";
    axios
      .get(endpoint)
      .then(response => {
        this.flights = [...this.flights, response.data];
      })
      .catch(err => console.log(err));
  },
  methods: {
    details(book) {
      this.$router.push({
        name: "ShowBook",
        params: { id: book._id }
      });
    },
    refresh() {
      var endpoint = "http://127.0.0.1:3000/request" + this.airline + "/";
      axios
        .get(endpoint)
        .then(response => {
          this.flights = [];
          this.flights = [...this.flights, response.data];
        })
        .catch(err => console.log(err));
    },
    acceptRequest(item) {
      var query = {
        source: item.source,
        destination: item.destination,
        date: item.date,
        numSeats: item.numSeats,
        addedBy: item.addedBy,
        totalPrice: item.totalPrice,
        postedBy: item.postedBy,
        decision: "1"
      };
      var query =
        "http://127.0.0.1:3000/request" +
        this.airline +
        "/" +
        item.source +
        "/" +
        item.destination +
        "/" +
        item.date +
        "/" +
        item.numSeats;
      axios.get(query)
      .then(response => {
        if (response.data.source === "Not Found") {
          alert("Flight Not Found");
          } else {
            var query = {
              source: item.source,
              destination: item.destination,
              date: item.date,
              seatsAvail: String(Number(response.data.seatsAvail) - Number(item.numSeats)),
              flightCapacity: response.data.flightCapacity
              };
            var endpoint = "http://127.0.0.1:3000/updateFlight"+this.airline+"/m/"
            axios.put(endpoint + response.data._id,query)
            .then(response => {
              alert("Allocated the Change");
              var query = {
                source: item.source,
                destination: item.destination,
                numSeats: item.numSeats,
                date: item.date,
                addedBy: item.addedBy,
                totalPrice: item.totalPrice,
                postedBy: item.postedBy,
                decision: "1"
                };
               var endpoint ="http://127.0.0.1:3000/updateFlight" + this.airline + "/r/";
              axios.put(endpoint+item._id,query)
              .then(response => {
                var updatedFlights = this.flights[0].filter(function(flight) {
                  return flight._id !== item._id;
                  });
                  this.flights = [...[], updatedFlights];
                  })
              .catch(err => console.log(err));
            })
            .then(response =>{
              console.log("Sent Ethers to "+item.postedBy)
              console.log("Handle accept")
              const casinoContract = new this.web3Obj.web3().eth.Contract(ABI,address)
              console.log(casinoContract.address)
              const price = this.web3Obj.web3().utils.toWei(item.totalPrice,'ether');
              console.log("price"+price)
              casinoContract.methods.response(item.postedBy,"1")
              .send({ from:this.web3Obj.accounts[0] ,
              value:price})
              .then(console.log("success"))
              // this.web3Obj.web3().eth.sendTransaction({from:item.postedBy ,
              //   to:this.web3Obj.accounts[0],
              //   value:price})
              //   .on('error', console.error);
              })
              .catch(err => console.log(err))
            }
        })
        .catch(err => console.log(err));
    },
    rejectRequest(item) {
      var query = {
        source: item.source,
        destination: item.destination,
        date: item.date,
        addedBy: item.addedBy,
        numSeats: item.numSeats,
        totalPrice: item.totalPrice,
        postedBy: item.postedBy,
        decision: "2"
      };
      var endpoint =
        "http://127.0.0.1:3000/updateFlight" + this.airline + "/r/";
      axios
        .put(endpoint + item._id, query)
        .then(response => {
          var updatedFlights = this.flights[0].filter(function(flight) {
            return flight._id !== item._id;
          });
          this.flights = [...[], updatedFlights];
        })
        .catch(err => console.log(err));
    }
  }
};
</script>
