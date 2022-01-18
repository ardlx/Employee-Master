<template>
     <v-menu
          v-model="menuDialog"
          :close-on-content-click="false"
          :nudge-width="300"
          offset-y
          origin="center center"
          transition="scroll-y-transition"
     >
          <template v-slot:activator="{ on, attrs }">
               <v-btn 
                    v-bind="attrs"
                    v-on="on"
                    icon>    
                    <v-icon>mdi-bell</v-icon>
                    <v-badge
                         v-if="totalNotifs > 0"
                         color="error"
                         :content="totalNotifs"
                    ></v-badge>
               </v-btn>
          </template>
          <v-card>
               <v-toolbar :color="themeColor == '' ? 'primary' : themeColor" flat dark dense>
                    <v-toolbar-title>Notifications</v-toolbar-title>
               </v-toolbar>
               <v-list v-if="notificationList.length > 0" two-line dense>
                    <v-list-item-group
                         active-class="pink--text"
                         multiple
                    >
                         <v-list-item  v-for="(item, i) in notificationList" :key="i">
                              <v-list-item-avatar>
                                   <v-img
                                        :src="`${photo}/${item.EmployeeCode}.jpg`"
                                   ></v-img>
                              </v-list-item-avatar>
                              <v-list-item-content>
                                   <v-list-item-title class="font-weight-bold">{{item.EmployeeName}}</v-list-item-title>
                                   <v-list-item-subtitle>
                                        {{item.Details}}:
                                        <span>{{moment(item.CreatedDate).fromNow()}}</span>
                                   </v-list-item-subtitle>
                              </v-list-item-content>
                              <v-btn @click="removeNotif(item)" x-small icon>
                                   <v-icon>mdi-close</v-icon>
                              </v-btn>
                         </v-list-item>
                    </v-list-item-group>
               </v-list>
               <v-subheader v-else class="font-weight-thin font-italic">No new notifications</v-subheader>
          </v-card>
     </v-menu>
</template>

<script>
export default {
     data() {
          return {
               menuDialog: false,
               notificationList: [],
               totalNotifs: 0
          }
     },
     created() {    
          this.loadNotifications()
     },
     sockets: {
          // get all notifications
          showNotifications() {
               this.loadNotifications()
          }
     },
     methods: {
          loadNotifications() {
               this.axios.get(`${this.api}/notifications/${this.userInfo.ShortName}/${this.userInfo.EmployeeCode}`, { headers: this.axiosHeaders }).then(res => {
                    if(Array.isArray(res.data)) {
                         this.notificationList = res.data
                    }
               })
          },
          removeNotif(val) {
               let body = {
                    procedureName: 'ProcPushNotification',
                    values: [
                         val.SeqNo,
                         val.SocketId,
                         val.CompanyCode,
                         val.EmplCode,
                         val.Details,
                         0
                    ]
               }
               this.axios.post(`${this.api}/execute`, {data: JSON.stringify(body)}, { headers: this.axiosHeaders })
               let index = this.notificationList.findIndex(rec => rec.SeqNo == val.SeqNo)
               this.notificationList.splice(index, 1)
               this.$socket.emit('newNotifications', body.values)
               this.totalNotifs--
          }
     },
     watch: {
          notificationList(val) {
               this.totalNotifs = 0
               if(val != undefined) {                    
                    val.forEach(rec => {
                         if(rec.EmployeeCode != this.userInfo.EmployeeCode && rec.ShortName == this.userInfo.ShortName) {
                              if(!rec.Viewed) {
                                   this.totalNotifs++
                              }
                         }
                    })
               }
          }
     }
}
</script>

<style scoped> 
     .v-list{
          height: 230px;
          overflow-y:auto
     }
</style>