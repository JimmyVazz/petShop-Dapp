<template>
<div>
  <v-app-bar> 
    <v-toolbar-title>
      Arca de Noe
    </v-toolbar-title>
    <v-spacer/>
  <v-btn
  icon
  @click="getWeb3"
  >
  <v-icon color="purple">
    mdi-account
    </v-icon>
  </v-btn>
    {{this.cuentas ? this.cuentas[0] : ""}}
    <v-btn
  icon
  >
  <v-icon color="purple">
    mdi-wallet
    </v-icon>
    </v-btn>

  </v-app-bar> 
  
  </div>
</template>

<script>
import Web3 from 'web3';
  export default {
    name: 'HelloWorld',

    data: () => ({
      cuentas: null,
      balance: null,
    }),
      methods: {
        async getWeb3(){
          await window.ethereum.enable();
          const instance = new Web3(window.ethereum);
          this.cuentas = await instance.eth.getAccounts();
          window.ethereum.on('accountsChanged', (nuevas_cuentas) => {
            this.cuentas = nuevas_cuentas
            console.log(this.cuentas)
          })
          
        },
        mounted(){
          
        }
        


      }
  }
</script>
