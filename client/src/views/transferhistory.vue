<template>
     <v-main>
          <v-breadcrumbs :items="breadCrumbsItems" divider="/"></v-breadcrumbs>
          <v-lazy transition="scroll-y-transition" :options="{ threshold: 0.8 }">
               <v-container fluid>
                    <v-card>
                         <v-card-title>
                              <v-row dense>
                                   <v-col>
                                        <v-card-text class="pa-0 headline">Transferred History</v-card-text>
                                   </v-col>
                              </v-row>
                         </v-card-title>
                         <v-divider></v-divider>
                         <v-card-title>
                              <v-row dense>
                                   <v-col cols="12" md="3">
                                        <datePicker
                                             :menu="dateDialog"
                                             dateLabel="Transferred Date"
                                             :dateValue.sync="transferredDate"
                                        ></datePicker>
                                   </v-col>
                                   <v-col v-if="userInfo.UserLevel == 4 || userInfo.UserLevel == 5 || userInfo.UserLevel == 9" cols="12" md="3">
                                        <v-autocomplete
                                             v-model="department"
                                             :items="loadDepartmentList"
                                             :color="themeColor == '' ? 'primary' : themeColor"
                                             placeholder="Department"
                                             hide-details
                                             clearable
                                             outlined
                                             dense
                                        ></v-autocomplete>
                                   </v-col>
                                   <v-col cols="12" md="3">
                                        <v-autocomplete
                                             v-model="section"
                                             :items="loadSectionList"
                                             :color="themeColor == '' ? 'primary' : themeColor"
                                             placeholder="Section"
                                             hide-details
                                             clearable
                                             outlined
                                             dense
                                        ></v-autocomplete>
                                   </v-col>
                                   <v-col cols="12" md="3">
                                        <v-autocomplete
                                             v-model="team"
                                             :items="loadTeamList"
                                             :color="themeColor == '' ? 'primary' : themeColor"
                                             placeholder="Team"
                                             hide-details
                                             clearable
                                             outlined
                                             dense
                                        ></v-autocomplete>
                                   </v-col>
                                   <v-col cols="12" md="12">
                                        <v-text-field
                                             v-model="searchTable"
                                             placeholder="Search Name, Code, etc..."
                                             append-icon="mdi-magnify"
                                             :color="themeColor == '' ? 'primary' : themeColor"
                                             hide-details
                                             clearable
                                             outlined  
                                             dense
                                        ></v-text-field>
                                   </v-col>
                              </v-row>
                         </v-card-title>
                         <v-divider></v-divider>
                         <v-data-table
                              :headers="headers"
                              :items="filterData"
                              :loading="loading"
                              :search="searchTable"
                              :items-per-page="8"
                              :page.sync="page"
                              loading-text="Loading Data. . .Please Wait"
                              @page-count="pageCount = $event"
                              hide-default-footer>
                              
                                   <v-progress-linear v-show="loading" slot="progress" :color="themeColor == '' ? 'primary' : themeColor" indeterminate></v-progress-linear>
                         </v-data-table>
                         <v-pagination
                              v-model="page"
                              :length="pageCount"
                              :total-visible="10"
                              :color="themeColor == '' ? 'primary' : themeColor"
                         ></v-pagination>
                         <v-card-text class="caption">Total Record(s): {{filterData.length}}</v-card-text>
                    </v-card>
               </v-container>
          </v-lazy>
     </v-main>
</template>

<script>
import datePicker from '@/components/datepicker'

export default {
     data() {
          return {
               history: [],
               dateDialog: false,
               transferredDate: this.moment().format('YYYY-MM-DD'),
               department: '',
               section: '',
               team: '',
               searchTable: '',
               pageCount: 0,
               userRights: 0,
               page: 1,
               loading: true,
               breadCrumbsItems: [
                    {text: 'Main Data', disabled: false, href: '#'},
                    {text: 'Transfer Employee', disabled: false, href: '#'},
                    {text: 'History', disabled: true, href: '#'}
               ],
               headers: [
                    {text:'Code',value:'EmployeeCode'},
                    {text:'Name',value:'EmployeeName'},
                    {text:'Old Department',value:'DepartmentName'},
                    {text:'Old Section',value:'SectionName'},
                    {text:'Old Team',value:'TeamName'}
               ]

          }
     },
     created(){
          this.loadRights()
     },
     sockets: {
          showNotifications() {
               setTimeout(() => {
                    this.loadRights()
               }, 1500);
          }
     },
     computed: {
          filterData() {
               return this.history.filter(rec => {
                    return (
                         this.moment(rec.TransferredDate).format('YYYY-MM-DD') == this.transferredDate &&
                         (rec.DepartmentName.includes(this.department || '') &&
                         rec.SectionName.includes(this.section || '') &&
                         rec.TeamName.includes(this.team || '')      )                   
                    )
               })
          },
          loadDepartmentList(){
               if (this.userInfo.UserLevel == 5){
                    return this.userInfo.AssignDepartments.map(rec =>{
                         return rec
                    }).sort()
               }else{
                    return this.history.map(rec =>{
                    return rec.DepartmentName
                    }).sort()
               }
          },
          loadSectionList(){
               return this.history.map(rec =>{
                   return rec.SectionName
               }).sort()
          },
          loadTeamList(){
               return this.filterData.map(rec =>{
                   return rec.TeamName
               }).sort()
          }
     },
     methods:{
          loadRights() {
               if(this.userInfo.UserLevel != 9) {
                    this.axios.get(`${this.api}/processrights/${this.userInfo.EmployeeCode}/EM01/${this.$route.query.id}`, { headers: this.axiosHeaders }).then(res => {
                         this.userRights = res.data[0].Rights
                         this.loadHistory()
                    })
               } else {
                    this.loadHistory()
               }
          },
          loadHistory(){
               let url = ''
               this.loading = true
               switch (this.userInfo.UserLevel) {
                    case 1: // DH
                         url = `${this.api}/history/${this.userInfo.ShortName}/${this.userInfo.DepartmentName}`
                         break;
                    case 2: // Section Head
                         url = `${this.api}/history/${this.userInfo.ShortName}/${this.userInfo.DepartmentName}/${this.userInfo.SectionName}`
                         break;
                    case 3: // Team Leader
                         url = `${this.api}/history/${this.userInfo.ShortName}/${this.userInfo.DepartmentName}/${this.userInfo.SectionName}/${this.userInfo.TeamName}`
                         break;
                    case 5: // JA
                         // url = `${this.api}/history/${this.userInfo.Comp_Name}`
                         url = `${this.api}/history/${this.userInfo.Comp_Name}/${this.userInfo.LocalDepartments}?array=${this.userInfo.AssignDepartments}`
                         break;
                    default: // Developer & QA
                         url = `${this.api}/history/${this.userInfo.ShortName}`
                         break;
               }
               this.axios.get(url, { headers: this.axiosHeaders }).then(res => {
                    this.history = res.data
                    this.loading = false
               }).catch(() => this.$router.push('*'))
          }
     },
     components: {
          datePicker
     }
          
     

}
</script>