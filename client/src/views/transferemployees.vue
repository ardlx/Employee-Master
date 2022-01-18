<template>
     <v-main>
          <v-breadcrumbs :items="breadCrumbsItems" divider="/"></v-breadcrumbs>
          <v-snackbar 
               v-model="alert" 
               color="success" 
               transition="scroll-y-transition" 
               :timeout="3000"
               outlined
               text
               top
          >
               <v-icon color="success" left>mdi-check-circle</v-icon>Record has been saved
          </v-snackbar>
          <v-lazy transition="scroll-y-transition" :options="{ threshold: 0.8 }">
               <v-container fluid>
                    <v-card>
                         <v-card-title>
                              <v-row dense>
                                   <v-col>
                                        <v-card-text class="pa-0 headline">Transfer Employees</v-card-text>
                                   </v-col>
                                   <v-spacer></v-spacer>
                                   <v-btn 
                                        v-if="userRights > 1 || userInfo.UserLevel == 9 || userInfo.UserLevel == 4"
                                        :color="themeColor == '' ? 'primary' : themeColor" 
                                        @click="transferEmployees()" 
                                        :disabled="selected.length <= 0" 
                                        dark
                                   >
                                        <v-icon left>mdi-transit-transfer</v-icon>Proceed
                                   </v-btn>
                              </v-row>
                         </v-card-title>
                         <v-divider></v-divider>
                         <v-card-title>
                              <v-row class="mb-n6" dense>
                                   <v-col v-if="userInfo.UserLevel == 4 || userInfo.UserLevel == 5 || userInfo.UserLevel == 9" cols="12" md="3">
                                        <v-autocomplete
                                             v-model="departmentFilter"
                                             :items="loadDepartmentFilter"
                                             :color="themeColor == '' ? 'primary' : themeColor"
                                             placeholder="Department"
                                             clearable
                                             outlined
                                             dense
                                        ></v-autocomplete>
                                   </v-col>
                                   <v-col cols="12" md="3">
                                        <v-autocomplete
                                             v-model="sectionFilter"
                                             :items="loadSectionFilter"
                                             :color="themeColor == '' ? 'primary' : themeColor"
                                             placeholder="Section"
                                             clearable
                                             outlined
                                             dense
                                        ></v-autocomplete>
                                   </v-col>
                                   <v-col cols="12" md="3">
                                        <v-autocomplete
                                             v-model="teamFilter"
                                             :items="loadTeamFilter"
                                             :color="themeColor == '' ? 'primary' : themeColor"
                                             placeholder="Team"
                                             clearable
                                             outlined
                                             dense
                                        ></v-autocomplete>
                                   </v-col>
                                   <v-col cols="12" md="3">
                                        <v-text-field
                                             v-model="searchTable"
                                             placeholder="Search Name, Code, etc..."
                                             append-icon="mdi-magnify"
                                             :color="themeColor == '' ? 'primary' : themeColor"
                                             clearable
                                             outlined  
                                             dense
                                        ></v-text-field>
                                   </v-col>
                              </v-row>
                         </v-card-title>
                         <v-divider></v-divider>
                         <v-data-table
                              v-model="selected"
                              :headers="headers"
                              :items="filterData"
                              :loading="loading"
                              :search="searchTable"
                              :items-per-page="8"
                              :page.sync="page"
                              :single-select="singleSelect"
                              item-key="EmployeeCode"
                              loading-text="Loading Data. . .Please Wait"
                              @page-count="pageCount = $event"
                              show-select
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
                    <v-dialog v-model="dialog" width="500" persistent>
                         <v-card>
                              <v-toolbar :color="themeColor == '' ? 'primary' : themeColor" dark flat>
                                   <v-toolbar-title>Transfer Employees</v-toolbar-title>
                              </v-toolbar>
                              <v-card-text>
                                   <v-container fluid>
                                        <v-form ref="form" v-model="valid" lazy-validation>
                                             <v-row align="center" justify="center" dense>
                                                  <v-col cols="12" md="12">     
                                                       <div class="mb-5">
                                                            <datePicker
                                                                 :menu="dateDialog"
                                                                 dateLabel="Effectivity Date"
                                                                 :dateValue.sync="transdivsecteam.EffectivityDate"
                                                            ></datePicker>
                                                       </div>
                                                       <v-autocomplete
                                                            v-model="transdivsecteam.DepartmentCode"
                                                            :items="departmentList"
                                                            :color="themeColor == '' ? 'primary' : themeColor"
                                                            item-value="DepartmentCode"
                                                            item-text="DepartmentName"
                                                            placeholder="Department"
                                                            clearable
                                                            outlined
                                                            dense
                                                       ></v-autocomplete>
                                                       <v-autocomplete
                                                            v-model="transdivsecteam.SectionCode"
                                                            :items="sectionList"
                                                            :color="themeColor == '' ? 'primary' : themeColor"
                                                            item-value="SectionCode"
                                                            item-text="SectionName"
                                                            placeholder="Section"
                                                            clearable
                                                            outlined
                                                            dense
                                                       ></v-autocomplete>
                                                       <v-autocomplete
                                                            v-model="transdivsecteam.TeamCode"
                                                            :items="teamList"
                                                            :color="themeColor == '' ? 'primary' : themeColor"
                                                            item-value="TeamCode"
                                                            item-text="TeamName"
                                                            placeholder="Team"
                                                            clearable
                                                            outlined
                                                            dense
                                                       ></v-autocomplete>
                                                  </v-col>
                                             </v-row>
                                        </v-form>
                                   </v-container>
                                   <v-card-actions>
                                        <v-spacer></v-spacer>
                                        <v-btn @click="dialog = !dialog" text>
                                             <v-icon left>mdi-cancel</v-icon>Cancel
                                        </v-btn>
                                        <v-btn @click="saveRecord()" :color="themeColor == '' ? 'primary' : themeColor" dark>
                                             <v-icon left>mdi-content-save</v-icon>Save
                                        </v-btn>
                                   </v-card-actions>
                              </v-card-text>
                         </v-card>
                    </v-dialog>
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
               selected: [],
               dialogDivSecTeam: [],
               departmentFilter: '',
               sectionFilter: '',
               teamFilter: '',
               searchTable: '',
               divsecteam: [],
               pageCount: 0,
               userRights: 0,
               page: 1,
               alert: false,
               dateDialog: false,
               loading: true,
               singleSelect: false,
               dialog: false,
               valid: true,
               breadCrumbsItems: [
                    {text: 'Main Data', disabled: false, href: '#'},
                    {text: 'Transfer Employee', disabled: false, href: '#'},
                    {text: 'Transfer', disabled: true, href: '#'},
               ],
               headers: [
                    {text:'Code',value:'EmployeeCode'},
                    {text:'Name',value:'EmployeeName'},
                    {text:'Department',value:'DepartmentName'},
                    {text:'Section',value:'SectionName'},
                    {text:'Team',value:'TeamName'}
               ],
               transdivsecteam:{
                    EffectivityDate: this.moment().format('YYYY-MM-DD'),
                    DepartmentCode: '',
                    SectionCode: '',
                    TeamCode: '',
                    CreatedDate: this.moment().format('YYYY-MM-DD hh:mm:ss'),
                    UpdatedDate: this.moment().format('YYYY-MM-DD hh:mm:ss'),
                    UpdatedUserId: ''
               }, 
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
                         rec.DepartmentName.includes(this.departmentFilter || '') &&
                         rec.SectionName.includes(this.sectionFilter || '') &&
                         rec.TeamName.includes(this.teamFilter || '') && 
                         (this.moment(rec.SeparationDate).format('YYYY-MM-DD') >= this.moment().format('YYYY-MM-DD') ||
                         rec.SeparationDate == null)                
                    )
               })
          },
          filterSection() {
               return this.divsecteam.filter(rec => {
                    return (
                         rec.DepartmentCode.includes(this.transdivsecteam.DepartmentCode || '')              
                    )
               })
          },
          filterTeam() {
               return this.divsecteam.filter(rec => {
                    return (
                         rec.DepartmentCode.includes(this.transdivsecteam.DepartmentCode || '') &&
                         rec.SectionCode.includes(this.transdivsecteam.SectionCode || '')                   
                    )
               })
          },
          filterDivSecTeam() {
               return this.dialogDivSecTeam.filter(rec => {
                    return rec
               })
          },
          loadDepartmentFilter(){
               return this.history.map(rec =>{
                   return rec.DepartmentName
               }).sort()
          },
          loadSectionFilter(){
               return this.history.map(rec =>{
                   return rec.SectionName
               }).sort()
          },
          loadTeamFilter(){
               return this.filterData.map(rec =>{
                   return rec.TeamName
               }).sort()
          },
          departmentList(){
               return this.filterDivSecTeam.filter(rec =>{
                   return rec.DepartmentName
               }).sort()
          },
          sectionList(){
               return this.filterSection.filter(rec =>{
                   return rec.SectionName
               }).sort()
          },
          teamList(){
               return this.filterTeam.filter(rec =>{
                   return rec.TeamName         
               }).sort()
          }
     },
     methods:{
          loadRights() {
               if(this.userInfo.UserLevel != 9) {
                    this.axios.get(`${this.api}/processrights/${this.userInfo.EmployeeCode}/EM01/${this.$route.query.id}`, { headers: this.axiosHeaders }).then(res => {
                         this.userRights = res.data[0].Rights
                         this.loadEmployees()
                    })
               } else {
                    this.loadEmployees()
               }
          },
          loadEmployees(){
               let url = ''
               this.loading = true
               switch (this.userInfo.UserLevel) {
                    case 1: // DH
                         url = `${this.api}/employees/${this.userInfo.ShortName}/${this.userInfo.DepartmentName}`
                         break;
                    case 5: //JA
                         // url = `${this.api}/employees/${this.userInfo.Comp_Name}`
                         url = `${this.api}/employees/${this.userInfo.Comp_Name}/${this.userInfo.LocalDepartments}?array=${this.userInfo.AssignDepartments}`
                         break;
                    case 2: // Section Head
                         url = `${this.api}/employees/${this.userInfo.ShortName}/${this.userInfo.DepartmentName}/${this.userInfo.SectionName}`
                         break;
                    case 3: // Team Leader
                         url = `${this.api}/employees/${this.userInfo.ShortName}/${this.userInfo.DepartmentName}/${this.userInfo.SectionName}/${this.userInfo.TeamName}`
                         break;
                    default: // Developer
                         url = `${this.api}/employees/${this.userInfo.ShortName}`
                         break;
               }
               this.axios.get(url, { headers: this.axiosHeaders }).then(res => {
                    this.history = res.data
                    this.loaddivsectionteam()
                    this.loading = false
               })
          },
          loaddivsectionteam(){
               let url = ''
               if (this.userInfo.UserLevel==5){
                    url=`${this.api}/company/department/section/team/${this.userInfo.Comp_Name}`
               }else {
                    url=`${this.api}/company/department/section/team/${this.userInfo.ShortName}`
               }
               this.axios.get(url, { headers: this.axiosHeaders }).then(res=>{
                    this.dialogDivSecTeam = res.data
               })
          },
          transferEmployees(){
               this.dialog = true
               this.axios.get(`${this.api}/company/department/section/team/${this.userInfo.ShortName}`, { headers: this.axiosHeaders }).then(res=>{
                    this.divsecteam = res.data
               })
          },
          saveRecord(){
               let data = []
               let body = {
                    procedureName: 'ProcGetEmployeesForTransfer',
                    values: []
               }
               this.selected.forEach(rec =>{
                    data = [
                         this.transdivsecteam.EffectivityDate,
                         rec.CompanyCode,
                         rec.EmployeeCode,
                         this.transdivsecteam.DepartmentCode,
                         this.transdivsecteam.SectionCode,
                         this.transdivsecteam.TeamCode,
                         this.transdivsecteam.CreatedDate,
                         this.transdivsecteam.UpdatedDate,
                         this.userInfo.EmployeeCode
                    ]
                    body.values.push(data)
               })
               console.log(body);
               this.axios.post(`${this.api}/execute`, {data: JSON.stringify(body)}, { headers: this.axiosHeaders })
               this.alert = !this.alert
               // this.$router.push('/transfer')
               this.selected = [],
               this.dialog = false
          },
          clearVariables(){
               this.transdivsecteam = {
                    EffectivityDate: this.moment().format('YYYY-MM-DD'),
                    DepartmentCode: '',
                    SectionCode: '',
                    TeamCode: '',
                    CreatedDate: this.moment().format('YYYY-MM-DD hh:mm:ss'),
                    UpdatedDate: this.moment().format('YYYY-MM-DD hh:mm:ss'),
                    UpdatedUserId: ''
               }
               this.dialog = false
          }
     },
     components: {
          datePicker
     }
}
</script>