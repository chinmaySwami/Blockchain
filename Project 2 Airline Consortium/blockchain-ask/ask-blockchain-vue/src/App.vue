<template>
  <div id="app">
    <div id="nav">
      <router-link v-if="authenticated" to="login" v-on:click.native="logout()" replace>Logout</router-link>
    </div>
    <router-view @authenticated="setAuth"/>
  </div>
</template>

<script>
export default {
  name: "App",
  data() {
    return{
      authenticated: false,
      superUser: false,
      airline: ''
    }
  },
  mounted(){
    if(this.authenticated & this.airline === 'A'){
      this.$router.replace({ name:"secureA"})
    }
    if(this.authenticated & this.airline === 'B'){
      console.log("Load SecureB")
    }
    if(this.superUser & this.airline === 'A'){
      this.$router.replace({name: "airlineA"})
    }
    if(this.superUser & this.airline === 'B'){
      this.$router.replace({name: "airlineB"})
    }
  },
  methods: {
    setAuth(status){
      this.authenticated = status
    },
    logout(){
      this.authenticated = false;
    },
    logoutSuper(){
      this.superUser = false
    }
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
