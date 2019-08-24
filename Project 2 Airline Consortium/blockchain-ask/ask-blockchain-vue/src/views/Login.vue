<template>
  <div id="login">
    <h1>Login</h1>
    <input type="text" name="username" v-model="username" placeholder="Username" required>
    <input type="password" name="password" v-model="password" placeholder="Password" required>
    <select v-model="dropdown" placeholder="A">
      <option value selected disabled hidden>Select Airline</option>
      <option value="airlineA">Airline A</option>
      <option value="airlineB">Airline B</option>
    </select>
    <input type="button" value="Login" v-on:click="loginUser">
  </div>
</template>

<script>
import axios from "axios";
export default {
  name: "Login",
  data() {
    return {
      username: "",
      password: "",
      dropdown: "",
      airline: ""
    };
  },
  methods: {
    loginUser() {
      if (this.dropdown !== "") {
        if (this.dropdown === "airlineA") {
          this.airline = "A";
        } else {
          this.airline = "B";
        }
        if ((this.username !== "") & (this.password !== "")) {
          if ((this.username === "airline")) {
            this.$emit("superUser", true);
            this.$emit("airline",this.airline);
            if(this.dropdown === "airlineA"){
                this.$router.replace({ name: "airlineA" });
            }else{
                this.$router.replace({ name: "airlineB" });
            }
          }else if(this.username === "su" | this.username === "superuser"){
            this.$router.replace({name: "admin"})
          } else {
            if (this.dropdown === "airlineA") {
              var query =
                "http://127.0.0.1:3000/requesta/" +
                this.username +
                "/" +
                this.password;
            } else {
              var query =
                "http://127.0.0.1:3000/requestb/" +
                this.username +
                "/" +
                this.password;
            }
            axios.get(query).then(response => {
              if (response.data.username === "Not Found") {
                alert("Username and/or Password Incorrect");
              } else {
                this.$emit("authenticated", true);
                this.$emit("airline", this.dropdown);
                this.$emit("_id", response.data._id);
                this.$router.replace({ name: "secure"+this.airline });
              }
            });
          }
        } else alert("Username and/or Password Missing");
      } else {
        alert("Select the Airline which you are registered with");
      }
    }
  }
};
</script>
