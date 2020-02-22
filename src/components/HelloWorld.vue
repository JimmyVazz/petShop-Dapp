<template>
    <div>
        <v-app-bar>
            <v-toolbar-title>
                Arca de Noe
            </v-toolbar-title>
            <v-spacer/>
            <v-btn icon @click="getWeb3">
                <v-icon color="purple">
                    mdi-login
                </v-icon>
            </v-btn>
            {{ this.cuentas ? this.cuentas[0] : "" }}
            <v-btn icon>
                <v-icon color="purple">
                    mdi-wallet
                </v-icon>
            </v-btn>
        </v-app-bar>
        <v-row class="text-center">
            <v-col cols="12">
                <div class="text-left">
                    <h1 class="text-left">Adopta un minino!</h1>
                    <v-btn @click="getGatitos" class="mt-5" color="primary">
                        Actualizar lista
                    </v-btn>
                    <br>
                    <div class="text-left">
                    </div>
                </div>
            </v-col>
            <v-row>
                <v-col cols="12">
                </v-col>
            </v-row>
            <br>
            <v-row>
                <v-col cols="12" class="text-center mb-5" md="4" v-for="item in gatitos" :key="item.image">
                    <v-card class="mx-auto" height="auto" width="auto" hover>
                        <v-card-title>
                            {{item.nombre}}
                        </v-card-title>
                        <v-card-subtitle class="text-left">
                            {{item.raza}}<br> Edad: {{item.edad}} <br> Sexo: {{item.sexo}}
                        </v-card-subtitle>
                        <v-card-text>
                            <v-img height="350" width="350" :src="item.foto_url">
                            </v-img>
                        </v-card-text>
                        <v-btn text :color="`${item.adoptado ? 'red' : 'green'}`" dark>
                            {{item.adoptado ? 'Adoptado' : 'En Adopción'}}
                        </v-btn>
                        <v-card-actions class="text-left">
                            <v-btn :disabled="item.adoptado" @click="adoptar(item.id)" class="text-left">
                                Adoptar!
                            </v-btn>
                        </v-card-actions>
                    </v-card>
                </v-col>
            </v-row>
            <v-col class="mb-4">
            </v-col>
        </v-row>
        <v-container>
        </v-container>
    </div>
</template>

<script>
import Web3 from 'web3';
import Arca from "../../build/contracts/Arca.json"

export default {
    name: 'HelloWorld',

    data: () => ({
        cuentas: "",
        balance: null,
        instance: null,
        contrato: null,
        nombre: '',
        url_foto: '',
        dialog: false,
        gatitos: []
    }),
    methods: {
        async getWeb3() {
            await ethereum.enable();
            const instance = new Web3(ethereum);
            this.instance = instance;
            this.cuentas = await instance.eth.getAccounts();
            ethereum.on('accountsChanged', function(accounts) {
                this.cuentas = accounts;
                alert("Recarga la ventana, para ver tu nueva cuenta")
            })
            // Crear instancia del contrato 
            const networkId = await instance.eth.net.getId();
            const deployedNetwork = Arca.networks[networkId];
            const contrato = new instance.eth.Contract(
                Arca.abi,
                deployedNetwork && deployedNetwork.address,
            );
            this.contrato = contrato;
        },
        async getGatitos() {
            this.gatitos = [];
            let res = await this.contrato.methods.c_gatitos().call();
            for (let i = 0; i < res; i++) {
                let nuevoCat = await this.contrato.methods.todosGatitos(i).call();
                let objeto_aux = {
                    color: nuevoCat.color,
                    raza: nuevoCat.raza,
                    edad: nuevoCat.edad,
                    nombre: nuevoCat.nombre,
                    sexo: nuevoCat.sexo,
                    foto_url: nuevoCat.foto_url,
                    id: nuevoCat.id,
                    adoptante: nuevoCat.adoptante,
                    adoptado: nuevoCat.adoptado,
                }
                this.gatitos.push(objeto_aux);
                console.log(nuevoCat);
            }
        },
        async adoptar(id) {
            let res = await this.contrato.methods.adoptarGatito(id).value({ from: this.cuentas[0] });
        }
    },
    computed: {
        currentAccount() {
            return this.cuentas;
        }
    }
}
</script>