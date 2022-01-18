<template>
     <v-main>
          <v-breadcrumbs :items="breadCrumbsItems" divider="/"></v-breadcrumbs>
          <v-lazy transition="scroll-y-transition" :options="{ threshold: 0.8 }">
               <v-container fluid>
                    <v-card>
                         <v-row class="pa-2" dense>
                              <v-col v-if="userInfo.UserLevel == 5 || userInfo.UserLevel == 8 || userInfo.UserLevel == 9" cols="12" md="4">           
                                   <v-autocomplete
                                        v-model="department"
                                        :items="departmentList"
                                        :color="themeColor == '' ? 'primary' : themeColor"
                                        placeholder="Department"
                                        hide-details
                                        clearable
                                        outlined
                                        dense
                                   ></v-autocomplete>
                              </v-col>
                              <v-col cols="12" md="4">
                                   <v-autocomplete
                                        v-model="section"
                                        :items="sectionList"
                                        :color="themeColor == '' ? 'primary' : themeColor"
                                        placeholder="Section"
                                        hide-details
                                        clearable
                                        outlined
                                        dense
                                   ></v-autocomplete>
                              </v-col>
                              <v-col cols="12" md="4">
                                   <v-autocomplete
                                        v-model="team"
                                        :items="teamList"
                                        :color="themeColor == '' ? 'primary' : themeColor"
                                        placeholder="Team"
                                        hide-details
                                        clearable
                                        outlined
                                        dense
                                   ></v-autocomplete>
                              </v-col>
                              <v-col cols="12" md="4">
                                   <v-radio-group class="text-center" v-model="selectedStatus" hide-details row>
                                        <v-radio
                                             class="mt-n3"
                                             v-for="(item, i) in status" :key="i"
                                             :color="themeColor == '' ? 'primary' : themeColor"
                                             :label="item.text"
                                             :value="item.value"
                                        ></v-radio>
                                   </v-radio-group>
                              </v-col>
                              <v-col cols="12" md="12">
                                   <v-card-actions class="pa-0">
                                        <v-text-field
                                             v-model="searchTable"
                                             placeholder="Search Code, LastName, etc.."
                                             append-icon="mdi-magnify"
                                             :color="themeColor == '' ? 'primary' : themeColor"
                                             hide-details
                                             clearable
                                             outlined
                                             dense
                                        ></v-text-field>
                                        <v-tooltip bottom>
                                             <template v-slot:activator="{ on, attrs }">
                                                  <v-btn 
                                                       class="mx-3"
                                                       @click="printDialog = !printDialog" 
                                                       :color="themeColor == '' ? 'primary' : themeColor"
                                                       v-bind="attrs"
                                                       v-on="on"
                                                       icon
                                                  >
                                                       <v-icon large>mdi-file-download</v-icon>
                                                  </v-btn>
                                             </template>
                                             <span>Download</span>
                                        </v-tooltip>
                                   </v-card-actions>
                              </v-col>
                              <!-- <v-col cols="12" md="4">
                                   <v-autocomplete
                                        v-model="remarks"
                                        :items="filterStatus"
                                        :color="themeColor == '' ? 'primary' : themeColor"
                                        placeholder="Status"
                                        hide-details
                                        clearable
                                        outlined
                                        dense
                                   ></v-autocomplete>
                              </v-col> -->
                         </v-row>
                    <v-divider></v-divider>
                    <v-data-table 
                         :headers="headers"
                         :items="filterData"
                         :search="searchTable"
                         :page.sync="page"
                         :loading="loading"
                         :items-per-page="8"
                         loading-text="Loading Data. . .Please Wait"
                         @page-count="pageCount = $event"
                         hide-default-footer
                    >
                         <v-progress-linear v-show="loading" slot="progress" :color="themeColor == '' ? 'primary' : themeColor" indeterminate></v-progress-linear>
                         <template v-slot:[`item.actions`]="{ item }">
                              <v-btn v-if="userRights == 3 || userRights == 1 || userInfo.UserLevel == 5" @click="viewRecord(item.EmployeeCode)" icon>
                                   <v-icon>mdi-eye</v-icon>
                              </v-btn>
                              <v-btn  v-if="(userInfo.UserLevel != 5 || userRights > 1)" @click="editRecord(item.EmployeeCode)" icon>
                                   <v-icon>mdi-pencil</v-icon>
                              </v-btn>
                         </template>
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
          <v-dialog v-model="printDialog" transition="scroll-y-transition" width="500" persistent>
               <v-card>
                    <v-container>
                         <v-card outlined dense>
                              <v-container>
                                   <v-text-field
                                        v-model="fileName"
                                        label="Filename"
                                        append-icon="mdi-file"
                                        :color="themeColor == '' ? 'primary' : themeColor"
                                        :disabled="selectedFileExtension == 'pdf'"
                                        hide-details
                                        clearable
                                        outlined
                                        dense
                                   ></v-text-field>
                                   <v-radio-group 
                                        v-model="selectedFileExtension" 
                                        hide-details
                                        dense 
                                        row
                                   >
                                        <template v-slot:label>
                                             <v-subheader class="font-weight-bold caption">Print As:</v-subheader>
                                        </template>
                                        <v-radio 
                                             v-for="(item, i) in fileExtension" :key="i" 
                                             :color="themeColor == '' ? 'primary' : themeColor"
                                             :value="item.value" 
                                             :label="item.text"
                                        ></v-radio>
                                   </v-radio-group>
                                   <v-card-actions>
                                        <v-subheader v-if="selectedFileExtension == 'xls'" class="font-italic text-caption red--text text--darken-1">Note: You need to have a higher version of Excel</v-subheader>
                                        <v-spacer></v-spacer>
                                        <v-btn @click="printDialog = !printDialog" text>
                                             <v-icon left>mdi-cancel</v-icon>Cancel
                                        </v-btn>
                                        <v-btn :color="themeColor == '' ? 'primary' : themeColor" @click="printData()" dark>
                                             <v-icon left>mdi-download</v-icon>Download
                                        </v-btn>
                                   </v-card-actions>
                              </v-container>
                         </v-card>
                    </v-container>
               </v-card>
          </v-dialog>
     </v-main>
</template>

<script>
import store from '@/store'

export default {
     data() {
          return {
               fileName: null,
               selectedFileExtension: null,
               loading: true,
               printDialog: false,
               department: '',
               section: '',
               team: '',
               searchTable: '',
               pageCount: 0,
               userRights: 0,
               selectedStatus: 0,
               page: 1,
               status: [
                    {text: 'All', value: 0},
                    {text: 'Active', value: 1},
                    {text: 'Inactive', value: 2}
               ],
               fileExtension: [
                    {text: 'Excel', value: 'xls'},
                    {text: 'CSV', value: 'csv'},
                    {text: 'PDF', value: 'pdf'}
               ],
               breadCrumbsItems: [
                    {text: 'Main Data', disabled: false, href: '#'},
                    {text: 'Employees', disabled: true, href: '#'}
               ],
               headers:[
                    {text: 'Code', value: 'EmployeeCode'},
                    {text: 'LastName', value: 'LastName'},
                    {text: 'FirstName', value: 'FirstName'},     
                    // {text: 'MiddleName', value: 'MiddleName'},
                    // {text: 'NickName', value: 'NickName'},
                    {text: 'Department', value: 'DepartmentName'},
                    {text: 'Section', value: 'SectionName'},
                    {text: 'Team', value: 'TeamName'},
                    {text: 'Actions', value: 'actions'},
                  
               ],
               getempInfos: [],
          }

     },
     created() {
          this.loadRights()
          store.commit('CHANGE_EMP_EDIT')          
     },
     sockets: {
          showNotifications() {
               setTimeout(() => {
                    this.loadRights()
               }, 1500);
          }
     },
     computed:{
          filterData() {
               return this.getempInfos.filter(rec => {
                    if (this.selectedStatus == 1) {
                         return (
                              rec.DepartmentName.includes(this.department || '') &&
                              rec.SectionName.includes(this.section || '') &&
                              rec.TeamName.includes(this.team || '') &&
                              (rec.SeparationDate == null || this.moment(rec.SeparationDate).format('YYYY-MM-DD') >= this.moment(this.serverDateTime).format('YYYY-MM-DD')) &&
                              rec.ContactStatus != 'S'
                              
                         )
                    } else if(this.selectedStatus == 2) {
                         return (
                              rec.DepartmentName.includes(this.department || '') &&
                              rec.SectionName.includes(this.section || '') &&
                              rec.TeamName.includes(this.team || '')  &&
                              ((rec.SeparationDate != null || this.moment(rec.SeparationDate).format('YYYY-MM-DD') < this.moment(this.serverDateTime).format('YYYY-MM-DD')) ||
                              rec.ContactStatus == 'S')
                               
                         )
                    } else {
                         return (
                              rec.DepartmentName.includes(this.department || '') &&
                              rec.SectionName.includes(this.section || '') &&
                              rec.TeamName.includes(this.team || '')            
                         )
                    }
               })
          },
          departmentList() {
               if(this.userInfo.UserLevel == 5) {
                    return this.userInfo.AssignDepartments.map(rec => {
                         return rec
                    }).sort()
                }else {
                    return this.getempInfos.map(rec => {
                         return rec.DepartmentName
                    }).sort()
                }
          },
          sectionList() { 
               return this.filterData.map(rec => {
                    return rec.SectionName   
               }).sort()
          },
          teamList() {
               return this.filterData.map(rec => {
                    return rec.TeamName
               }).sort()
          },
     },
     methods:{
          printData() {
               let records = []
               this.filterData.forEach(rec => {
                    records.push({
                         Code: rec.EmployeeCode,
                         Name: rec.EmployeeName,
                         Department: rec.DepartmentName,
                         Section: rec.SectionName,
                         Team: rec.TeamName,
                         Position: rec.DesignationName
                    })
               })

               if(this.selectedFileExtension) {
                    if(this.selectedFileExtension == 'pdf') {
                         let headers = []
                         let objectKeys = Object.keys(records[0])
                         objectKeys.forEach(rec => {
                              headers.push({
                                   text: rec,
                                   value: rec
                              })
                         })
                         this.printreportpdf(headers, records, null)
                    } else {
                         if(this.fileName) {
                              this.printreport(records, this.fileName, this.selectedFileExtension)
                         }
                    }
                    this.fileName = null,
                    this.selectedFileExtension = null
                    this.printDialog = !this.printDialog
               }
          },
          loadRights() {
               let level = this.userInfo.UserLevel
               if(level != 9 && level != 8 && level != 5 ) {
                    this.axios.get(`${this.api}/processrights/${this.userInfo.EmployeeCode}/EM01/${this.$route.query.id}`, { headers: this.axiosHeaders }).then(res => {
                         this.userRights = res.data[0].Rights
                         this.loadEmpinfo()
                    })
               } else {
                    this.loadEmpinfo()
               }
          },
          loadEmpinfo(){
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
                    default: // Japanese, Administration, Developer
                         url = `${this.api}/employees/${this.userInfo.ShortName}`
                         break;
               }
               this.axios.get(url, { headers: this.axiosHeaders }).then(res => {
                    this.getempInfos = res.data
                    this.loading = false
               })
          }, 
          editRecord(code) {
               store.commit('CHANGE_EMP_EDIT', true)
               this.$router.push({name: 'employeedetails', query: {code: code}})
           
          },
          viewRecord(code) {
               store.commit('CHANGE_EMP_EDIT', false)
               this.$router.push({name: 'employeedetails', query: {code: code}})
          },
     }
}
</script>