<template>
<div>
    <form>
        <input type="button" value="Register" v-on:click="handleReg">
        &nbsp;
        <input type="button" value="Un Register" v-on:click="handleUnreg">
        &nbsp;
        <input type="button" value="Get Balance" v-on:click="getBal">
        <h5>Account is: {{ web3Obj.accounts[0] }}</h5>
        <h5>Balance is: {{ balance }}</h5>
    </form>
</div>
</template>

<script>
import Web3 from 'web3'
import { Promise, async } from 'q';
import { type } from 'os';
import { Web3EthereumProvider } from 'web3-providers';
import {Eth} from 'web3-eth';
import {address, ABI} from '../Util/constants/casinoContract'

export default {
    name: "RegisterAirline",
    props: [
        "web3Obj"
    ],
    data(){
        return {
            balance:0
        }
    },
    methods: {
        handleReg(){
          console.log("Handle Reg with contract")
          const casinoContract = new this.web3Obj.web3().eth.Contract(ABI,address)
          console.log(casinoContract.address)
          console.log(this.web3Obj.accounts[0]);
          casinoContract.methods.registerMember()
          .send({ from: this.web3Obj.accounts[0],
          value:"40000000000000000000"})
          .then(console.log("success"))
        },
        handleUnreg(){

        },
        async getBal(){
            var balance = await this.web3Obj.web3().eth.getBalance(this.web3Obj.accounts[0])
            this.balance = this.web3Obj.web3().utils.fromWei(balance,'ether');
        }
    }
}
</script>
