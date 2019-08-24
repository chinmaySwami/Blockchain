<template>
  <div id="AirlineB">
    <Header :airline="airline"/>
    <hr>
    <RegisterAirline :web3Obj="web3Obj"/>
    <hr>
    <handleIncomingRequests :airline="airline"/>
  </div>
</template>

<script>
//import HelloWorld from '@/components/HelloWorld.vue'
import Header from '@/components/Header'
import RegisterAirline from '@/components/RegisterAirline'
import handleChange from '@/components/handleChange'
import handleIncomingRequests from '@/components/handleIncomingRequests'
import Web3 from 'web3'
import { Promise, async } from 'q';
import { type } from 'os';
import { Web3EthereumProvider } from 'web3-providers';
import {Eth} from 'web3-eth';

export default {
  name: 'AirlineB',
  components: {
    Header,
    RegisterAirline,
    handleChange,
    handleIncomingRequests
  },
  data(){
    return{
      airline:"B",
      web3Obj: ''
    }
  },
  created() {
    window.addEventListener('load',async () => {
            if(window.ethereum){
                window.web3 = new Web3(ethereum);
                try {
                    await ethereum.enable();
                } catch(err){
                    alert("User Denied Account Access")
                }
            } else if(window.web3) {
                window.web3 = new Web3(web3.currentProvider);
            }
        })
        let getWeb3 = new Promise(function(resolve,reject){
            var web3js = window.web3
            if(typeof web3js !== 'undefined'){
                var web3 = new Web3(web3js.currentProvider);
                resolve({
                injectedWeb3: web3.eth.net.isListening(),
                web3(){
                    console.log("Web3 Connected")
                    return web3
                }
            })
            } else{
                console.log("Web3 Load Failed")
                reject(new Error('Unable to connect to Metamask'))
            }
        })
        .then(result=>{
            return new Promise(function(resolve,reject) {
                result.web3().eth.net.getId((err,networkId) =>{
                    if(err){
                        throw err
                    } else {
                        result = Object.assign({},result,{networkId})
                        resolve(result)
                        console.log("Network Id: "+networkId)
                    }
                })
            })
        })
        .then(result => {
            return new Promise(function(resolve,reject){
                result.web3().eth.getAccounts((err,accounts)=>{
                    if(err){
                        throw err
                    }else {
                        result = Object.assign({},result,{accounts})
                        resolve(result)
                        console.log("Account: "+accounts);
                    }
                })
            })
        })
        .then(result => this.web3Obj = result)
        // Register here
        .catch(err => console.log(err));
  }
}
</script>

<style>
#app {
  font-family: 'Avenir', Helvetica, Arial, sans-serif;
  -webkit-font-smoothing: antialiased;
  -moz-osx-font-smoothing: grayscale;
  text-align: center;
  color: #2c3e50;
  margin-top: 60px;
}
</style>
