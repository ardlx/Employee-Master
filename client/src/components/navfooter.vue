<template>
     <v-footer
          class="font-weight-medium"
          padless
          inset
          dense
          app
     >
          <v-card width="100%" flat tile>
               <v-card-text class="text-center">
                    {{ new Date().getFullYear() }} — <strong>Employee Master</strong> {{appVersion}}
               </v-card-text>
          </v-card>
     </v-footer>
</template>    