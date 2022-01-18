<template>
     <v-app id="inspire">
          <navdrawer v-if="(userInfo.EmployeeCode != undefined || userInfo.id != undefined) && isConnect" />
          <router-view/>
          <navfooter v-if="(userInfo.EmployeeCode != undefined || userInfo.id != undefined)" />
     </v-app>
</template>

<script>
import navdrawer from './components/navdrawer'
import navfooter from './components/navfooter'
export default {
     data() {
          return {
               
          }
     },
     mounted() {
          setInterval(() => {
               this.checkAppVersion()
          }, 1000);
     },
     methods: {

     },
     components: {
          navdrawer,
          navfooter
     }
}
</script> 

<style>

    /* Scrollbar styles */
    ::-webkit-scrollbar {
        width: 6px;
        height: 12px;
    }

    ::-webkit-scrollbar-track {
        background: #f5f5f5;
        border-radius: 10px;
    }

    ::-webkit-scrollbar-thumb {
        border-radius: 10px;
        background: #ccc;  
    }

    ::-webkit-scrollbar-thumb:hover {
        background: #999;  
    }

</style>