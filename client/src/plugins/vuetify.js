import Vue from 'vue';
import Vuetify from 'vuetify/lib';
import '@mdi/font/css/materialdesignicons.css';

Vue.use(Vuetify);

export default new Vuetify({
     icons: {
       iconfont: "mdi", // default - only for display purposes
     },
     theme: {
       dark: false,
       themes: {
         light: {
           primary: "#1976D2",
           secondary: "#455A64",
           accent: "#8c9eff",
           error: "#b71c1c",
           info: "#2196F3",
           success: "#4CAF50",
           warning: "#FFC107",
           highlightcolor: "#42A5F5",
           icon_color: "#212121",
           table_header_color: "#213c57",
         },
       },
     },
   });