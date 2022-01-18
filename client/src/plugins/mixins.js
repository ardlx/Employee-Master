import { mapState, mapMutations } from 'vuex'
import store from '../store'

const plugins = {
     install(Vue) {
          Vue.mixin({
               data: () => ({
                    api: null,
                    server: process.env.VUE_APP_SERVER,
                    api_jap: process.env.VUE_APP_JAP_URL,
                    asd_sql: process.env.VUE_APP_ASD_SQL,
                    photo: process.env.VUE_APP_PHOTO,
                    photo_jap: process.env.VUE_APP_PHOTO_JAP,
                    axiosHeaders: { 'master-api' : `db588403f0a1d3b897442a28724166b4` },
                    axiosAWSHeaders: { 'x-api-key' : 'JUe7mHXOhR6ziaSDHXUDJ310nTfdsH8s1ph44z2q' }
               }),
               created() {
                    this.api = process.env.NODE_ENV == 'production' ? process.env.VUE_APP_URL : process.env.VUE_APP_LOCAL_URL
                    // this.setHeaders()
               },
               computed: {
                    ...mapState([
                         'userInfo', 
                         'isLoggedIn', 
                         'darkMode', 
                         'isEmpEdit',
                         'isConnect',
                         'isEnableTour',
                         'themeColor',
                         'appVersion',
                         'profileBackground'
                    ])
               },
               methods: {
                    ...mapMutations([
                         'CHANGE_USER_INFO', 
                         'CHANGE_USER_LOGGING', 
                         'CHANGE_THEME', 
                         'CHANGE_EMP_EDIT',
                         'CHANGE_CONNECTION',
                         'CHANGE_THEMECOLOR',
                         'CHANGE_PROFILE_BACKGROUND',
                         'CHANGE_APP_VERSION',
                         'CHANGE_TOUR_VALUE'
                    ]),
                    setNotifications(code, message) {
                         let body = {
                              procedureName: 'ProcPushNotification',
                              values: [
                                   0,
                                   this.$socket.id,
                                   this.userInfo.CompanyCode,
                                   code,
                                   message,
                                   1
                              ]
                         }
                         this.axios.post(`${this.api}/execute`, {data: JSON.stringify(body)})
                         this.$socket.emit('newNotifications', body.values)
                    },
                    clearHeaders(reset) {
                         if(reset == 1) {
                              delete this.axios.defaults.headers.common['x-api-key']
                              this.axios.defaults.headers.common['master-api'] = process.env.VUE_APP_URL_KEY
                         } else {
                              delete this.axios.defaults.headers.common['master-api']
                              this.axios.defaults.headers.common['x-api-key'] = process.env.VUE_APP_AWS_KEY
                         }
                    },
                    sentenceCase(str) {
                         if ((str === null) || (str === '')) {
                              return false;
                         } else {
                              str = str.toString();
                         }
                         return str.replace(/\w\S*/g, function(txt){return txt.charAt(0).toUpperCase() + txt.substr(1).toLowerCase();});
                    },
                    gotoHelp() {
                         window.open('http://10.169.141.8:5050/JaeAnn/employeemaster/-/wikis/Manual', '_blank')
                    },
                    setHeaders() {
                         this.axios.defaults.headers.common['master-api'] = process.env.VUE_APP_URL_KEY
                         // if(store.state.userInfo.EmployeeCode == undefined) {
                         //      this.axios.defaults.headers.common['x-api-key'] = process.env.VUE_APP_AWS_KEY
                         // } else {
                         //      this.axios.defaults.headers.common['master-api'] = process.env.VUE_APP_URL_KEY
                         // }
                    },
                    checkAppVersion() {
                         let version = null
                         this.axios.get(`${this.server}/appversion`).then(res => {
                              version = res.data
                              if(version != this.appVersion) {
                                   store.commit('CHANGE_APP_VERSION', version)
                                   store.commit('CHANGE_CONNECTION', true)
                                   store.commit('CHANGE_TOUR_VALUE', true)
                                   store.commit('CHANGE_USER_LOGGING', false)
                                   store.commit('CHANGE_USER_INFO', {})
                                   if(this.$route.name != 'login') {
                                        this.$router.push('/')
                                   }
                              }
                         })
                    },
               }
          })
     }
}

export default plugins