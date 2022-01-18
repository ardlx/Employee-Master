<template>
     <div>
          <v-navigation-drawer 
               v-model="navDrawerVal"
               :color="themeColor == '' ? 'primary' : themeColor"
               expand-on-hover
               permanent
               dark
               app
          >   
               <v-list>
                    <!-- For Japanese -->
                    <v-list-item v-if="user.UserLevel == 5" class="px-2">
                         <v-list-item-avatar>                                        
                              <img :src="`${photo_jap}/${user.id}.jpg`" alt="nopic.jpg">
                         </v-list-item-avatar>
                         <v-list-item-content>
                              <v-list-item-title>{{ user.id }}</v-list-item-title>
                              <v-list-item-subtitle class="caption">{{ user.LastNameEng }} {{user.FirstNameEng}}</v-list-item-subtitle>
                              <v-list-item-subtitle class="caption">( {{ user.LastName}} {{ user.FirstName }} )</v-list-item-subtitle>
                         </v-list-item-content>
                    </v-list-item>
                    
                    <!-- For Non-Japanese -->
                    <v-list-item v-else class="px-2">
                         <v-list-item-avatar>                                       
                              <img :src="`${photo}/${user.EmployeeCode}.jpg`" alt="nopic.jpg">
                         </v-list-item-avatar>
                         <v-list-item-content>
                              <v-list-item-title>{{user.EmployeeCode}}</v-list-item-title>
                              <v-list-item-subtitle class="caption">{{user.EmployeeName}}</v-list-item-subtitle>
                              <v-list-item-subtitle class="caption">{{ user.DesignationName }}</v-list-item-subtitle>
                         </v-list-item-content>
                    </v-list-item>
               </v-list>
               <v-divider></v-divider>
               <v-list shaped dense>
                    <v-list-group
                         v-for="(item, i) in navDrawerList" :key="i"
                         v-model="item.active"    
                         :prepend-icon="item.icon"
                         color="white"
                         no-action
                    >
                         <template v-slot:activator>
                              <v-list-item-content>
                                   <v-list-item-title>{{item.title}}</v-list-item-title>
                              </v-list-item-content>
                         </template>
                         <v-list-item
                              v-for="child in item.items"
                              @click="gotoPage(child.to, child.id)"
                              :key="child.text"
                              link 
                         >
                              <v-list-item-content>
                                   <v-list-item-subtitle>{{child.text}}</v-list-item-subtitle>
                              </v-list-item-content>
                         </v-list-item>
                         <div v-if="i == 1">
                              <v-list-group
                                   v-for="(subGroup, i) in navDrawerSubGroup" :key="i"
                                   color="white"
                                   no-action
                                   sub-group
                              >
                                   <template v-slot:activator>
                                        <v-list-item-content>
                                             <v-list-item-subtitle class="ml-2">{{subGroup.text}}</v-list-item-subtitle>
                                        </v-list-item-content>
                                   </template>
                                   <v-list-item
                                        v-for="subGroupChild in subGroup.items"
                                        @click="gotoPage(subGroupChild.to, subGroupChild.id)"
                                        :key="subGroupChild.text"
                                        link 
                                   >
                                        <v-list-item-content>
                                             <v-list-item-subtitle>{{subGroupChild.text}}</v-list-item-subtitle>
                                        </v-list-item-content>
                                        <v-list-item-icon>
                                             <v-icon>{{subGroupChild.icon}}</v-icon>
                                        </v-list-item-icon>
                                   </v-list-item>
                              </v-list-group>
                         </div>
                    </v-list-group>
               </v-list>    
          </v-navigation-drawer>
          <v-app-bar
               app
          >
               <div v-if="userInfo.UserLevel == 5">
                    <v-toolbar-title>{{ user.LocalDepartments }}</v-toolbar-title>
               </div>
               <div v-else>
                    <v-toolbar-title class="font-weight-bold text-h5" v-if="userInfo.UserLevel < 9">{{ user.DepartmentName }} Department</v-toolbar-title>
                    <v-toolbar-title v-else>ASD Team</v-toolbar-title>
               </div>
               <v-spacer></v-spacer>
               <notifications v-if="userInfo.UserLevel != 0" />  
               <v-btn @click="sideDrawer = !sideDrawer" icon>
                    <v-icon>mdi-cog-outline</v-icon>
               </v-btn>  
               <v-tooltip bottom>
                    <template v-slot:activator="{ on, attrs }">
                         <v-btn @click="logout()" v-bind="attrs" v-on="on" icon>
                              <v-icon >mdi-logout</v-icon>
                         </v-btn> 
                    </template>
                    <span>Logout</span>
               </v-tooltip>
          </v-app-bar>
          <v-navigation-drawer
               v-model="sideDrawer"
               :disable-resize-watcher="true"
               hide-overlay
               temporary
               right
               app         
          >
               <v-list dense>
                    <v-list-item>
                         <v-list-item-content>
                              <v-list-item-title>Settings</v-list-item-title>
                         </v-list-item-content>
                         <v-list-item-action>
                              <v-tooltip bottom>
                                   <template v-slot:activator="{ on, attrs }">
                                        <v-btn @click="gotoHelp()" v-on="on" v-bind="attrs" icon>
                                             <v-icon >mdi-help-circle-outline</v-icon>
                                        </v-btn>
                                   </template>
                                   <span>Help</span>
                              </v-tooltip>
                         </v-list-item-action>
                    </v-list-item>
                    <v-divider></v-divider>
                    <v-list-item>
                         <v-list-item-content>
                              <v-subheader>Theme Color</v-subheader>
                              <v-color-picker 
                                   v-model="themeColorVal"
                                   mode="hexa" 
                                   hide-mode-switch 
                                   hide-canvas
                                   :show-swatches="swatches"
                                   :update:color="changeThemeColor(themeColorVal)"
                              ></v-color-picker>
                         </v-list-item-content>
                    </v-list-item>
                    <v-list-item>
                         <v-list-item-content>
                         <v-btn x-small block text @click="swatches = !swatches" :color="themeColor == '' ? 'primary' : themeColor">
                              {{swatches == false ? "Show more" : "Hide"}}
                         </v-btn>
                         </v-list-item-content>
                    </v-list-item>
                    <v-divider class="mx-3"></v-divider>
                    <v-list-item>
                         <v-list-item-content>
                              <v-subheader>Profile Background</v-subheader>
                              <v-item-group mandatory>
                                   <v-row>
                                        <v-col v-for="(item, i) in profileImage" :key="i" cols="12" md="4">
                                             <v-item v-slot="{ toggle }">
                                                  <v-card 
                                                       elevation="7"
                                                       :style="item.value == profileBackground ? `border: 2px solid ${themeColor} !important;` : ''"
                                                       @click="toggle" 
                                                  >
                                                       <v-img @click="changeProfileBackground(item.value)" :src="item.value"></v-img>
                                                  </v-card>
                                             </v-item>
                                        </v-col>
                                   </v-row>
                              </v-item-group>
                         </v-list-item-content>
                    </v-list-item>
                    <v-divider class="mx-3"></v-divider>
                    <v-list-item>
                         <v-list-item-content>
                              <v-list-item-subtitle>Dark Mode</v-list-item-subtitle>
                         </v-list-item-content>
                         <v-list-item-action>
                              <v-switch
                                   v-model="dark"        
                                   @change="changeTheme()"
                                   inset
                              ></v-switch>
                         </v-list-item-action>
                    </v-list-item>
               </v-list>
          </v-navigation-drawer>
     </div>       
</template>

<script>
import notifications from '@/components/notifications'

export default {
     data() {
          return {
               user: '',
               navDrawerVal: false,
               dark: false,
               overlay: false,
               sideDrawer: false,
               isConnected: false,
               swatches: true,
               icon: 'mdi-weather-night',
               search: '',
               socketId: '',
               themeColorVal: '',
               navDrawerList: [],
               navDrawerSubGroup: [],
               profileImage: [
                    {value: require('../assets/16251.jpg')},
                    {value: require('../assets/2076.jpg')},
                    {value: require('../assets/3594.jpg')}
               ]
          }
     },
     created() {
          this.dark = this.darkMode
          this.user = this.userInfo
          this.themeColorVal = this.themeColor
          this.navDrawerVal = this.$vuetify.breakpoint.smAndDown ? false : true
          this.getUserLevel()
     },
     sockets: {
          showNotifications() {
               this.getUserLevel() 
          }
     },
     methods: {
          gotoPage(page, id) {
               let query = this.$route.name
               if (page == `/${query}`) return
               if(this.userInfo.UserLevel == 9) {
                    this.$router.push({path: page})
               } else {
                    this.$router.push({path: page, query: {id: id}})
               }
          },
          changeTheme() {
               this.$vuetify.theme.dark = this.dark
               this.icon = this.dark ? 'mdi-weather-sunny' : 'mdi-weather-night'
               this.$store.commit('CHANGE_THEME', this.dark)
          },
          changeThemeColor(val) {
               this.$store.commit('CHANGE_THEMECOLOR', val)
          },
          changeProfileBackground(val) {
               this.$store.commit('CHANGE_PROFILE_BACKGROUND', val)
          },
          logout() {
               this.$store.commit('CHANGE_USER_INFO', {})
               this.$store.commit('CHANGE_USER_LOGGING', false)
               this.$store.commit('CHANGE_THEME', false)
               this.$router.push('/')
          },
          getUserLevel() {
               switch (this.userInfo.UserLevel) {
                    case 0:
                         this.navDrawerList = [
                              {
                                   title: 'Employee',
                                   icon: 'mdi-account',
                                   items: [{text: 'Profile', to: '/profile'}],
                                   active: true   
                              }
                         ]
                         break;
                    case 1: // Department Head
                    case 2: // Section Head
                    case 3: // Team Leader
                    case 4: // QA Staff
                         this.loadNavDrawer()
                         break;
                    case 5: // Japanese
                    case 8: // Administration
                         this.navDrawerList = [
                              {
                                   title: 'Dashboard',
                                   icon: 'mdi-view-dashboard',
                                   items: [
                                        {text: 'Home', to: '/dashboard'}
                                   ],
                                   active: true   
                              },
                              {
                                   title: 'Main Data',
                                   icon: 'mdi-account',
                                   items: [
                                        {text: 'Employees', to: '/employees'},
                                        {text: 'Departments', to: '/department'},
                                        {text: 'Sections', to: '/section'},
                                        {text: 'Team', to: '/team'},
                                        {text: 'Department - Section', to: '/divsec'},
                                        {text: 'Employee Status', to: '/employeestatus'},
                                        {text: 'Query Builder', to: '/querybuilder'}
                                   ],
                                   active: false   
                              }
                         ]
                         break;
                    default: // Developer
                         this.navDrawerList = [
                         {
                              title: 'Dashboard',
                              icon: 'mdi-view-dashboard',
                              items: [{text: 'Home', to: '/dashboard'}],
                              active: true    
                         },
                         {
                              title: 'Main Data',
                              icon: 'mdi-account',
                              items: [
                                   {text: 'Employees', to: '/employees'},
                                   {text: 'Departments', to: '/department'},
                                   {text: 'Sections', to: '/section'},
                                   {text: 'Team', to: '/team'},
                                   {text: 'Department - Section', to: '/divsec'},
                                   {text: 'Employee Status', to: '/employeestatus'},
                                   {text: 'Query Builder', to: '/querybuilder'}
                              ],
                              active: false ,
                              hasGrandChild: true  
                         },
                         {
                              title: 'Maintenance',
                              icon: 'mdi-tools',
                              items: [
                                   {text: 'User Accounts', to: '/accounts'},
                                   {text: 'System List', to: '/systemlist'},
                                   {text: 'Profile', to: '/profile'}
                              ],
                              active: false  
                         }
                    ]
                    // Transfer Employees
                    this.navDrawerSubGroup = [
                         {
                              text: 'Transfer Employees',
                              items: [
                                   {text: 'Transfer', icon: 'mdi-transfer', to: '/transferemployees'},
                                   {text: 'History', icon: 'mdi-history', to: '/transferhistory'},
                                   {text: 'Pending', icon: 'mdi-timer-sand', to: '/pendingemployees'}
                              ]
                         }
                    ]
                    break;
               }
          },
          loadNavDrawer() {
               this.axios.get(`${this.api}/processrights/${this.userInfo.EmployeeCode}/EM01/0`, { headers: this.axiosHeaders }).then(res => {
                    if(Array.isArray(res.data)) {
                         this.navDrawerList = [
                              {
                                   title: 'Dashboard',
                                   icon: 'mdi-view-dashboard',
                                   items: [
                                        {text: 'Home', to: '/dashboard'},
                                        {text: 'Profile', to: '/profile'}
                                   ],
                                   active: true   
                              },
                              {
                                   title: 'Main Data',
                                   icon: 'mdi-account',
                                   items: [],
                                   active: false   
                              }
                         ]
                         res.data.forEach(rec => {
                              if(rec.ProcessId != 'EM01-09') {
                                   this.navDrawerList[1].items.push(
                                        {text: rec.ProcessName, to: `/${rec.ProcessPath}`, id: rec.ProcessId}
                                   )
                              }
                         })
                    } else {
                         this.navDrawerList = [
                              {
                                   title: 'Dashboard',
                                   icon: 'mdi-view-dashboard',
                                   items: [
                                        {text: 'Home', to: '/dashboard'},
                                        {text: 'Profile', to: '/profile'}
                                   ],
                                   active: true   
                              }
                         ]
                    }
                    this.loadTransferEmployees()
               })
          },
          loadTransferEmployees() {
               this.axios.get(`${this.api}/processrights/${this.userInfo.EmployeeCode}/EM01/EM01-09`, { headers: this.axiosHeaders }).then(res => {
                    if(res.data.length > 0 && res.data[0].DeletedDate == null) {
                         this.navDrawerSubGroup = [
                              {
                                   text: 'Transfer Employees',
                                   items: [
                                        {text: 'Transfer', icon: 'mdi-transfer', to: '/transferemployees', id: 'EM01-09'},
                                        {text: 'History', icon: 'mdi-history', to: '/transferhistory', id: 'EM01-09'},
                                        {text: 'Pending', icon: 'mdi-timer-sand', to: '/pendingemployees', id: 'EM01-09'}
                                   ]
                              }
                         ]
                    }
               })
          }
     },
     watch: {
          dark() {
               this.changeTheme()
          },
          searchData(val) {
               this.search = val
          }
          // themeColorVal(val) {
          //      this.$store.commit('CHANGE_THEMECOLOR', val)
          // }
          // <style scoped>
          //      .v-navigation-drawer--mini-variant, .v-navigation-drawer {
          //           overflow: visible !important;
          //      }
          // </style>
     },
     components: {
          notifications
     }
}
</script>