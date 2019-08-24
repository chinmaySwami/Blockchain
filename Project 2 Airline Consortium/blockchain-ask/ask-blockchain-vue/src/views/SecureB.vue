<template>
    <div id="secureB">
        <h1>Airline {{airline}} Flight Change Screen</h1>
        <hr>
        <handleChange :airline='airline' :web3Obj='web3Obj'/>
    </div>
</template>

<script>
import handleChange from '@/components/handleChange'
import Web3 from 'web3'
import { Promise, async } from 'q';
import { type } from 'os';
import { Web3EthereumProvider } from 'web3-providers';
import {Eth} from 'web3-eth';
import {address, ABI} from '../Util/constants/casinoContract'
export default {
    name: "SecureA",
    data(){
        return {
            airline: "B",
            web3Obj: ''
        }
    },
    components: {
        handleChange
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
          .then(console.log(getWeb3))
          .catch(err => console.log(err));
    }
}
</script>
