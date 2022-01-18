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
          <v-lazy transition="scroll-y-transition" :options="{ threshold: 0.2 }">
               <v-container fluid>
                    <v-row class="mb-n6" dense>
                         <v-col cols="12" md="2">
                              <v-select
                                   v-model="companies"
                                   :items="companyList"
                                   :readonly="userInfo.UserLevel < 9"
                                   :color="themeColor == '' ? 'primary' : themeColor"
                                   placeholder="Company"
                                   outlined
                                   dense
                              ></v-select>
                         </v-col>
                         <v-col cols="12" md="4">
                              <v-select
                                   v-model="departments"
                                   :items="departmentList"
                                   :color="themeColor == '' ? 'primary' : themeColor"
                                   placeholder="Department"
                                   clearable
                                   outlined
                                   dense
                              ></v-select>
                         </v-col>
                         <v-col cols="12" md="3">
                              <v-select
                                   v-model="sections"
                                   :items="sectionList"
                                   :color="themeColor == '' ? 'primary' : themeColor"
                                   placeholder="Section"
                                   clearable
                                   outlined
                                   dense
                              ></v-select>
                         </v-col>
                         <v-col cols="12" md="3">
                              <v-select
                                   v-model="teams"
                                   :items="teamList"
                                   :color="themeColor == '' ? 'primary' : themeColor"
                                   placeholder="Team"
                                   clearable
                                   outlined
                                   dense
                              ></v-select>
                         </v-col>
                    </v-row>
                    <v-card>
                         <v-toolbar flat>
                              <v-spacer></v-spacer>
                              <v-row dense>
                                   <v-col class="ml-auto" cols="12" md="6">
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
                              <v-btn class="ml-3" @click="dialog = !dialog" :color="themeColor == '' ? 'primary' : themeColor" dark>
                                   <v-icon left>mdi-plus</v-icon>New
                              </v-btn>
                         </v-toolbar>
                         <v-divider></v-divider>
                         <v-data-table 
                              :headers="headers" 
                              :items="filterData"
                              :loading="loading"
                              :search="searchTable"
                              :page.sync="page"
                              :items-per-page="9"
                              loading-text="Loading Data. . .Please Wait"
                              @page-count="pageCount = $event"
                              hide-default-footer
                         >
                              <v-progress-linear v-show="loading" slot="progress" :color="themeColor == '' ? 'primary' : themeColor" indeterminate></v-progress-linear>
                              <template v-slot:[`item.rights`]="{ item }">
                                   <v-tooltip bottom>
                                        <template v-slot:activator="{ on, attrs }">
                                             <v-btn :disabled="item.Status == 0" @click="gotoProcessRights(item.EmployeeCode)" v-on="on" v-bind="attrs" :color="themeColor == '' ? 'primary' : themeColor" elevation="3" outlined icon>
                                                  <v-icon>mdi-card-account-details</v-icon>
                                             </v-btn>
                                        </template>
                                        <span>Account Rights</span>
                                   </v-tooltip>
                              </template>
                              <template v-slot:[`item.actions`]="{ item }">
                                   <v-tooltip bottom>
                                        <template v-slot:activator="{ on, attrs }">
                                             <v-btn @click="editRecord(item)" v-on="on" v-bind="attrs" icon>
                                                  <v-icon>mdi-pencil</v-icon>
                                             </v-btn>
                                        </template>
                                        <span>Edit</span>
                                   </v-tooltip>
                                   <v-tooltip bottom>
                                        <template v-slot:activator="{ on, attrs }">
                                             <v-btn @click="deleteRecord(item)" v-on="on" v-bind="attrs" icon>
                                                  <v-icon v-if="item.Status == 1">mdi-delete</v-icon>
                                                  <v-icon v-else>mdi-restore</v-icon>
                                             </v-btn>
                                        </template>
                                        <span v-if="item.Status == 1">Deactivate</span>
                                        <span v-else>Restore</span>
                                   </v-tooltip>
                                   <v-tooltip bottom>
                                        <template v-slot:activator="{ on, attrs }">
                                             <v-btn @click="resetRecord(item)"  v-on="on" v-bind="attrs" icon>
                                                  <v-icon>mdi-lock-reset</v-icon>
                                             </v-btn>
                                        </template>
                                        <span>Reset</span>
                                   </v-tooltip>
                              </template>
                              <template v-slot:[`item.Status`]="{ item }">
                                   <v-avatar :color="item.Status == 1 ? 'success' : 'error'" :size="24">
                                   </v-avatar>
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
          <v-dialog v-model="dialog" width="500" persistent>
               <v-card>
                    <v-toolbar :color="themeColor == '' ? 'primary' : themeColor" dark flat>
                         <v-toolbar-title>{{editMode == 1 ? 'Edit Record' : 'New Record'}}</v-toolbar-title>
                    </v-toolbar>
                    <v-container fluid>
                         <v-form v-model="valid" ref="form" lazy-validation>
                              <v-card-text>
                                   <v-row align="center" justify="center" dense>
                                        <v-col cols="12" md="3">
                                             <v-text-field
                                                  v-model="editedAccount.EmployeeCode"
                                                  label="Code"
                                                  :readonly="editMode == 1"
                                                  :rules="[v => !!v || 'Code is required']"
                                                  :color="themeColor == '' ? 'primary' : themeColor"
                                                  outlined
                                                  dense
                                                  @blur="getEmployeeFullname()"
                                             ></v-text-field>
                                        </v-col>
                                        <v-col cols="12" md="9">
                                             <v-text-field
                                                  v-model="editedAccount.Fullname"
                                                  :color="themeColor == '' ? 'primary' : themeColor"
                                                  label="Name"
                                                  readonly
                                                  outlined
                                                  dense
                                             >
                                                  <template v-slot:append>
                                                       <v-fade-transition leave-absolute>
                                                            <v-progress-circular
                                                            v-if="loadName"
                                                            size="24"
                                                            :color="themeColor == '' ? 'primary' : themeColor"
                                                            indeterminate
                                                            ></v-progress-circular>
                                                       </v-fade-transition>
                                                  </template>
                                             </v-text-field>
                                        </v-col>
                                        <v-col cols="12" md="12">
                                             <v-text-field
                                                  v-model="editedAccount.Username"
                                                  append-icon="mdi-account"
                                                  label="UserName"
                                                  :rules="[v => !!v || 'Username is required']"
                                                  :color="themeColor == '' ? 'primary' : themeColor"
                                                  outlined
                                                  dense
                                             ></v-text-field>
                                        </v-col>
                                        <v-col cols="12" md="6">
                                             <v-text-field
                                                  v-model="newPassword"
                                                  append-icon="mdi-lock"
                                                  label="Password"
                                                  type="password"
                                                  :rules="[v => !!v || 'Password is required']"
                                                  :color="themeColor == '' ? 'primary' : themeColor"
                                                  outlined
                                                  dense
                                             ></v-text-field>
                                        </v-col>
                                        <v-col cols="12" md="6">
                                             <v-text-field
                                                  v-model="confirmedPassword"
                                                  append-icon="mdi-lock-check"
                                                  label="Confirm Password"
                                                  type="password"
                                                  :rules="passwordRules"
                                                  :color="themeColor == '' ? 'primary' : themeColor"
                                                  outlined
                                                  dense
                                             ></v-text-field>
                                        </v-col>
                                        <v-col cols="12" md="6">
                                             <v-select
                                                  v-model="editedAccount.UserLevel"
                                                  :items="userLevel"
                                                  :color="themeColor == '' ? 'primary' : themeColor"
                                                  item-text="text"
                                                  item-value="value"
                                                  label="Level"
                                                  outlined
                                                  dense
                                             ></v-select>
                                        </v-col>
                                   </v-row>
                              </v-card-text>
                         </v-form>
                    </v-container>
                    <v-card-actions>
                         <v-spacer></v-spacer>
                         <v-btn @click="clearVariables()" text>
                              <v-icon left>mdi-cancel</v-icon>Cancel
                         </v-btn>
                         <v-btn @click="saveRecord()" :color="themeColor == '' ? 'primary' : themeColor" :disabled="disabled" dark>
                              <v-icon left>mdi-content-save</v-icon>Save
                         </v-btn>
                    </v-card-actions>
               </v-card>
          </v-dialog>
     </v-main>
</template>

<script>
export default {
     data() {
          return {
               valid: true,
               loading: true,
               alert: false,
               loadName: false,
               dialog: false,
               disabled: false,
               pageCount: 0,
               page: 1,
               editMode: 0,
               searchTable: '',
               newPassword: '',
               companies: '',
               departments: '',
               sections: '',
               teams: '',
               confirmedPassword: '',
               accounts: [],
               userLevel: [],
               passwordRules: [
                    v => !!v || 'Password is required',
                    v => (v == this.newPassword) || 'Password do not match'
               ],
               editedAccount: {
                    EmployeeCode: '',
                    Username: '',
                    Fullname: '',
                    IPAddr: '',
                    UserLevel: 0
               },
               saveOptions: {
                    title: 'Are you sure?',
                    text: "You won't be able to revert this!",
                    icon: 'warning',
                    showCancelButton: true,
                    confirmButtonText: 'Save'
               },
               headers: [
                    {text: 'Code', value: 'EmployeeCode'},
                    {text: 'Name', value: 'Fullname'},
                    {text: 'Username', value: 'Username'},  
                    {text: 'Level', value: 'UserLevel'},
                    {text: 'Actions', value: 'actions'},
                    {text: 'Rights', value: 'rights'},
                    {text: 'Status', value: 'Status'}
               ],
               breadCrumbsItems: [ 
                    {text: 'Maintenance', disabled: false, href: '#'},
                    {text: 'User Accounts', disabled: true, href: '#'}
               ]
          }
     },
     created() {
          this.loadUserLevel()
          this.loadAccounts()
          this.companies = this.userInfo.ShortName
     },
     sockets: {
          showNotifications() {
               this.loadAccounts()
          }
     },
     computed: {
          filterData() {
               return this.accounts.filter(rec => {
                    return (
                         rec.ShortName.includes(this.companies || '') &&
                         rec.DepartmentName.includes(this.departments || '') &&
                         rec.SectionName.includes(this.sections || '') &&
                         rec.TeamName.includes(this.teams || '')
                    )
               })
          },
          companyList() {
               return this.accounts.map(rec => {
                    return rec.ShortName
               })
          },
          departmentList() {
               return this.filterData.map(rec => {
                    return rec.DepartmentName
               }).sort()
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
          }
     },
     methods: {
          checkSpecialCharacters(str) {
               let specialKey = "[`~!#$^&*()=|{}':;',\\[\\].<>/?~！#￥……&*（）——|{}【】‘；：”“'。，、？]‘'"; 
               let value = str
               for (var i = 0; i < value.length; i++) {
                    if (specialKey.indexOf(value.substr(i, 1)) != -1) {
                         return true
                    }
               }
               
          },
          gotoProcessRights(code) {
               this.$router.push({name: 'accountrights', query: {code: code}})
          },
          loadUserLevel() {
               if(this.userInfo.DepartmentName == 'QA') { 
                    this.userLevel = [
                         {text: 'Staff', value: 0},
                         {text: 'Department Head', value: 1},
                         {text: 'Section Head', value: 2},
                         {text: 'Team Leader', value: 3},
                         {text: 'QA', value: 4},
                         {text: 'Japanese Manager', value: 5},
                         {text: 'Administration', value: 8},
                         {text: 'Developer', value: 9}
                    ]
               } else {
                    this.userLevel = [
                         {text: 'Staff', value: 0},
                         {text: 'Department Head', value: 1},
                         {text: 'Section Head', value: 2},
                         {text: 'Team Leader', value: 3},
                         {text: 'Japanese Manager', value: 5}
                    ]
               }
          },
          loadAccounts() {
               this.loading = true
               this.accounts = []
               let arrayParams = []
               switch (this.userInfo.UserLevel) {
                    case 1: // Department Head
                    case 4: // QA Staff
                         arrayParams = [
                              this.userInfo.ShortName,
                              this.userInfo.DepartmentName,
                              'NONE',
                              'NONE'
                         ]
                         break;
                    case 2: // Section Head
                         arrayParams = [
                              this.userInfo.ShortName,
                              this.userInfo.DepartmentName,
                              this.userInfo.SectionName,
                              'NONE'
                         ]
                         break;
                    case 3: // Team Leader
                         arrayParams = [
                              this.userInfo.ShortName,
                              this.userInfo.DepartmentName,
                              this.userInfo.SectionName,
                              this.userInfo.TeamName,
                         ]
                         break;            
                    default: // Developer
                         arrayParams = [
                              'NONE',
                              'NONE',
                              'NONE',
                              'NONE'
                         ]
                         break;
               }
               this.axios.get(`${this.api}/usercontrol?array=${arrayParams}`, { headers: this.axiosHeaders }).then(res => {
                    this.accounts = res.data
                    this.loading = false
               })
          },   
          getEmployeeFullname() {
               this.loadName = true
               this.disabled = false
               let data = this.accounts.filter(rec => (rec.EmployeeCode == this.editedAccount.EmployeeCode))
               if(data.length == 0 && this.editedAccount.EmployeeCode != '') {
                    this.axios.get(`${this.api}/employeeinfo/${this.editedAccount.EmployeeCode}`, { headers: this.axiosHeaders }).then(res => {
                         if(res.data.length != 0) {
                              this.$refs.form.resetValidation()
                              this.editedAccount.Fullname = res.data[0].EmployeeName
                         } else {
                              this.editedAccount.Fullname = ''
                              this.disabled = true
                         }
                         this.loadName = false
                    })
               } else {
                    this.editedAccount = Object.assign({}, data[0])
                    this.loadName = false
               }
               this.disabled = false
          },
          saveRecord() {
               if(this.$refs.form.validate()) {
                    if(this.checkSpecialCharacters(this.editedAccount.Username)) {
                         this.swal.fire('', 'Special characters are not required. Try again', 'error')
                    } else {
                         this.swal.fire(this.saveOptions).then(result => {
                              if(result.isConfirmed) {
                                   let body = {
                                        procedureName: 'ProcUserControl',
                                        values: [
                                             this.editedAccount.EmployeeCode,
                                             this.editedAccount.Username,
                                             this.editedAccount.Fullname,
                                             this.md5(this.newPassword),
                                             this.editedAccount.IPAddr,
                                             this.editedAccount.UserLevel,
                                             this.moment().format('YYYY-MM-DD'),
                                             this.moment().format('YYYY-MM-DD'),
                                             this.userInfo.EmployeeCode,
                                             1
                                        ]
                                   }
                                   this.axios.post(`${this.api}/execute`, {data: JSON.stringify(body)}, { headers: this.axiosHeaders })
                                   this.alert = !this.alert
                                   this.setNotifications(
                                        this.userInfo.EmployeeCode, 
                                        this.editMode == 0 ? 'added a new account' : 'updated an account'
                                   )
                                   this.clearVariables()
                              }
                         })
                    }
               }
          },
          editRecord(val) {
               this.editMode = 1
               this.editedAccount = val
               this.dialog = true
               this.disabled = false
          },
          deleteRecord(val) {
               this.swal.fire({
                    title: 'Are you sure?',
                    text: val.Status == 1 ? "This account wil set to Inactive." : "This wil restore the account.",
                    icon: 'warning',
                    showCancelButton: true,
                    confirmButtonText: val.Status == 1 ? 'Yes, delete it!' : 'Yes, restore it!',
                    denyButtonText: 'Cancel'
               }).then(result => {
                    if(result.isConfirmed) {
                         let body = {
                              procedureName: 'ProcUserControl',
                              values: [
                                   val.EmployeeCode,
                                   val.Username,
                                   val.Fullname,
                                   this.md5(this.newPassword),
                                   val.IPAddr,
                                   val.UserLevel,
                                   this.moment().format('YYYY-MM-DD'),
                                   this.moment().format('YYYY-MM-DD'),
                                   this.userInfo.EmployeeCode,
                                   0
                              ]
                         } 
                         this.axios.post(`${this.api}/execute`, {data: JSON.stringify(body)}, { headers: this.axiosHeaders })
                         this.swal.fire('Confirmed!','Changes has been saved', 'success')
                         this.setNotifications(
                              this.userInfo.EmployeeCode, 
                              val.Status != 1 ? 'restored an account' : `account set to inactive`
                         )
                         this.clearVariables()    
                    }
               })
          },
          resetRecord(val) {
               this.swal.fire({
                    title: 'Are you sure?',
                    text: `This will reset the account of: ${val.Fullname}.`,
                    icon: 'warning',
                    showCancelButton: true,
                    confirmButtonText: 'Yes, reset the account!',
                    denyButtonText: 'Cancel'
               }).then(result => {
                    if(result.isConfirmed) {
                         let body = {
                              procedureName: 'ProcUserControl',
                              values: [
                                   val.EmployeeCode,
                                   val.EmployeeCode, // set the username to employee code
                                   val.Fullname,
                                   this.md5(val.EmployeeCode),
                                   val.IPAddr,
                                   val.UserLevel,
                                   this.moment().format('YYYY-MM-DD'),
                                   this.moment().format('YYYY-MM-DD'),
                                   this.userInfo.EmployeeCode,
                                   2
                              ]
                         }
                         this.axios.post(`${this.api}/execute`, {data: JSON.stringify(body)}, { headers: this.axiosHeaders })
                         this.swal.fire('Confirmed!','Changes has been saved', 'success')
                         this.setNotifications(
                              this.userInfo.EmployeeCode, 
                              `reset the account of: ${val.EmployeeCode}: ${val.Fullname}`
                         )
                         this.clearVariables()
                    }
               })
          },
          clearVariables() {
               this.editedAccount = {
                    EmployeeCode: '',
                    Username: '',
                    Fullname: '',
                    IPAddr: '',
                    UserLevel: 0,
               }
               if(this.dialog) {
                    this.$refs.form.resetValidation()
               }
               this.newPassword = ''
               this.confirmedPassword = ''
               this.dialog = false
               this.disabled = false
               this.editMode = 0
          }
     }
}
</script>