<template>
  <form @submit.prevent="getFormValues">
    <input type="email" placeholder="Email" v-model="email">
    &nbsp;
    <input type="text" placeholder="New Source" v-model="source">
    &nbsp;
    <input type="text" placeholder="New Destination" v-model="destination">
    &nbsp;
    <input type="number" min="1" step="1" max="900" placeholder="Seats" v-model="seats">
    &nbsp;
    <input type="date" placeholder="New Date" v-model="date">
    &nbsp;
    <input type="button" value="Search" v-on:click="handleSearch">
    &nbsp;
    <input type="button" value="Post" :disabled="!post" v-on:click="postChange">
    &nbsp;
    <input
      type="button"
      value="Allocate"
      :disabled="!allocate"
      v-on:click="allocateChange"
    >
  </form>
</template>

<script>
import axios from "axios";
import Web3 from 'web3'
import { Promise, async } from 'q';
import { type } from 'os';
import { Web3EthereumProvider } from 'web3-providers';
import {Eth} from 'web3-eth';
import {address, ABI} from '../Util/constants/casinoContract'

export default {
  name: "handleChange",
  data() {
    return {
      source: "",
      destination: "",
      seats: "",
      date: "",
      email: "",
      post: false,
      allocate: false,
      reply: ""
    };
  },
  props: ["airline",
"web3Obj"
],
  methods: {
    handleSearch() {
      var query =
        "http://127.0.0.1:3000/request"+this.airline+"/" +
        this.source +
        "/" +
        this.destination +
        "/" +
        this.date +
        "/"+
        this.seats;
      axios
        .get(query)
        .then(response => {
          if (response.data.source === "Not Found") {
            alert("Flight Not Found");
            this.post = true;
            this.allocate = false;
          } else {
            this.allocate = true;
            this.post = false;
            this.reply = response.data;
          }
        })
        .catch(err => console.log(err));
    },
    postChange() {
      var query = {
        source: this.source,
        destination: this.destination,
        date: this.date,
        addedBy: this.email,
        decision: "0",
        numSeats: this.seats,
        postedBy: this.web3Obj.accounts[0],
        totalPrice: String(Math.round(Math.random() * 18))
      };
      var postAt = '';
      if(this.airline==="A") postAt ="B"
      if(this.airline==="B") postAt ="A"
      var endpoint = "http://127.0.0.1:3000/add" + postAt
      axios
        .post(endpoint, query)
        .then(response => {
          alert("Posted to Consortium");
          this.post = !this.post;
          this.allocate = false;
        })
        .then(response => {
          console.log("Handle request")
          const casinoContract = new this.web3Obj.web3().eth.Contract(ABI,address)
          casinoContract.methods.request(this.date,this.destination,this.source,"0",this.seats)
        .send({ from: this.web3Obj.accounts[0],
        value:"0"})
      })
        .catch(err => console.log(err));
    },
    allocateChange() {
      var query = {
        source: this.source,
        destination: this.destination,
        date: this.date,
        seatsAvail: String(Number(this.reply.seatsAvail) - this.seats),
        flightCapacity: this.reply.flightCapacity
      }
      var endpoint = "http://127.0.0.1:3000/updateFlight"+this.airline+"/m/"
      axios.put(endpoint + this.reply._id,query)
      .then(response => {
        alert("Allocated the Change");
        this.allocate = false;
        this.post = false;
      })
      .catch(err => console.log(err))

    }
  }
};
</script>
