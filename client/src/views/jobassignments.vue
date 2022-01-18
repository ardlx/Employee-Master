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
                         <v-toolbar flat>
                              <v-spacer></v-spacer>
                              <v-row dense>
                                   <v-col class="ml-auto" cols="12" md="6">
                                        <!-- <v-card-text class="pa-0 headline">Job Assignments</v-card-text> -->
                                        <v-text-field
                                             v-model="searchTable"
                                             placeholder="Search Job Assignment"
                                             append-icon="mdi-magnify"
                                             :color="themeColor == '' ? 'primary' : themeColor"
                                             hide-details
                                             clearable
                                             outlined  
                                             dense
                                        ></v-text-field>
                                   </v-col>
                              </v-row>
                              <v-btn 
                                   class="ml-3"
                                   v-if="userInfo.UserLevel == 4 || userInfo.UserLevel == 9 || userRights == 3" 
                                   @click="newRecord()" 
                                   :color="themeColor == '' ? 'primary' : themeColor" 
                                   dark
                              >
                                   <v-icon left>mdi-plus</v-icon>New
                              </v-btn>
                         </v-toolbar>
                         <v-divider></v-divider>
                         <v-data-table
                              :headers="headers"
                              :items="jobassignments"
                              :loading="loading"
                              :search="searchTable"
                              :page.sync="page"
                              loading-text="Loading Data. . .Please Wait"
                              @page-count="pageCount = $event"
                              hide-default-footer
                         >
                         
                              <v-progress-linear v-show="loading" slot="progress" :color="themeColor == '' ? 'primary' : themeColor" indeterminate></v-progress-linear>
                              <template v-slot:item="props">
                                   <tr :style="props.item.DeletedDate != null ? 'color: #b71c1c;' : ''">
                                        <td>{{props.item.JobAssignmentDesc}}</td>
                                        <td>{{props.item.CreatedDate}}</td>
                                        <td>{{props.item.UpdatedDate}}</td>
                                        <td>
                                             <div v-if="userInfo.UserLevel == 4 || userInfo.UserLevel == 9 || userRights > 1">
                                                  <v-btn @click="editRecord(props.item)" icon>
                                                       <v-icon >mdi-pencil</v-icon>
                                                  </v-btn>
                                                  <v-btn  @click="deleteRecord(props.item)" icon>
                                                       <v-icon v-if="props.item.DeletedDate == null">mdi-delete</v-icon>
                                                       <v-icon v-else>mdi-restore</v-icon>
                                                  </v-btn>
                                             </div>
                                             <div v-else>
                                                  <v-btn @click="editRecord(props.item)" icon>
                                                       <v-icon>mdi-eye</v-icon>
                                                  </v-btn>
                                             </div>
                                        </td>
                                   </tr>
                              </template>
                         </v-data-table>
                         <v-pagination
                              v-model="page"
                              :length="pageCount"
                              :total-visible="10"
                              :color="themeColor == '' ? 'primary' : themeColor"
                         ></v-pagination>
                         <v-card-text class="caption">Total Record(s): {{jobassignments.length}}</v-card-text>
                    </v-card>
               </v-container>
          </v-lazy>
          <v-dialog v-model="dialog" width="500" persistent>
               <v-card>
                    <v-toolbar :color="themeColor == '' ? 'primary' : themeColor" dark flat>
                         <v-toolbar-title v-if="userRights > 1">{{editMode == 1 ? 'Edit Record' : 'New Record'}}</v-toolbar-title>
                         <v-toolbar-title v-else>View Record</v-toolbar-title>
                    </v-toolbar>
                    <v-container fluid>
                              <v-form ref="form" v-model="valid" lazy-validation>
                                   <v-row align="center" justify="center" dense>
                                        <v-col cols="12" md="12">
                                             <v-text-field
                                                  v-model="editjobassignment.JobAssignmentDesc"
                                                  label="Job Assignment"
                                                  @keypress.enter="saveRecord()"
                                                  :rules="[v => !!v || 'This field is required']"
                                                  :readonly="userInfo.UserLevel != 4 && userInfo.UserLevel != 9 || userRights == 1"
                                                  :color="themeColor == '' ? 'primary' : themeColor"
                                                  hide-details
                                                  outlined
                                                  dense
                                             ></v-text-field>
                                        </v-col>
                                   </v-row>
                              </v-form>
                    </v-container>
                    <v-card-actions>
                         <v-spacer></v-spacer>
                         <v-btn @click="clearVariables()" text>
                              <v-icon left>mdi-cancel</v-icon>Cancel
                         </v-btn>
                         <v-btn v-if="userInfo.UserLevel == 4 || userInfo.UserLevel == 9 || userRights > 1" @click="saveRecord()" :color="themeColor == '' ? 'primary' : themeColor" dark>
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
               alert: false,
               dialog: false,
               valid: true,
               loading: true,
               editMode: 0,
               pageCount: 0,
               userRights: 0,
               page: 1,
               searchTable: '',
               jobassignments: [],
               saveOptions: {
                    title: 'Are you sure?',
                    text: "You won't be able to revert this!",
                    icon: 'warning',
                    showCancelButton: true,
                    confirmButtonText: 'Save',
               },
               editjobassignment: {
                    CompanyCode: '',
                    DepartmentCode: '00',
                    JobAssignmentCode: 0,
                    JobAssignmentName: '',
                    CreatedDate: this.moment().format('YYYY-MM-DD hh:mm:ss'),
                    UpdatedDate: this.moment().format('YYYY-MM-DD hh:mm:ss'),
                    UpdatedUserId: '',
                    Option: 1
               },
               headers: [
                    {text: 'Job Assignments', value: 'JobAssignmentDesc'},
                    {text: 'Date Created', value: 'CreatedDate'},
                    {text: 'Last Update', value: 'UpdatedDate'},
                    {text: 'Actions', value: 'actions'}
               ],
               breadCrumbsItems: [
                    {text: 'Main Data', disabled: false, href: '#'},
                    {text: 'Job Assignments', disabled: true, href: '#'}
               ]
          }
     },
     created() {
          this.loadRights()
     },
     sockets: {
          showNotifications() {
               setTimeout(() => {
                    this.loadRights()
               }, 1500);
          }
     },
     methods: {
          loadRights() {
               if(this.userInfo.UserLevel != 9 && this.userInfo.UserLevel != 8) {
                    this.axios.get(`${this.api}/processrights/${this.userInfo.EmployeeCode}/EM01/${this.$route.query.id}`).then(res => {
                         this.userRights = res.data[0].Rights
                         this.loadJobAssignments()
                    })
               } else {
                    this.loadJobAssignments()
               }
          },
          loadJobAssignments() {
               let url = ''
               switch(this.userInfo.UserLevel) {
                    case 5: // Japanese
                         url = `${this.api}/jobassignment/${this.userInfo.Comp_Name}?array=${this.userInfo.AssignDepartments}`
                         break;
                    default:
                         url = `${this.api}/jobassignment/${this.userInfo.ShortName}/${this.userInfo.DepartmentName}`
                         break;
               }
               this.axios.get(url).then(async res => {
                    this.loading = true
                    this.jobassignments = await res.data
                    this.loading = false
               })
          },
          saveRecord() {
               if(this.$refs.form.validate()) {
                    this.swal.fire(this.saveOptions).then(result => {
                         if(result.isConfirmed) {
                              let body = {
                                   procedureName: 'ProcJobAssignment',
                                   values: [
                                        this.userInfo.CompanyCode,
                                        this.userInfo.DepartmentCode,
                                        this.editjobassignment.JobAssignmentCode,
                                        this.editjobassignment.JobAssignmentDesc,
                                        this.editjobassignment.CreatedDate,
                                        this.moment().format('YYYY-MM-DD hh:mm:ss'),
                                        this.userInfo.EmployeeCode,
                                        1
                                   ]
                              }
                              this.axios.post(`${this.api}/execute`, {data: JSON.stringify(body)})
                              this.alert = !this.alert
                              this.clearVariables()
                              this.setNotifications(
                                   this.userInfo.EmployeeCode, 
                                   this.editMode == 0 ? 'added a new Job Assignment' : 'updated a Job Assignment'
                              )
                         }
                    })
               }
          },
          newRecord() {
               this.dialog = true
               this.editjobassignment.CompanyCode = this.userInfo.CompanyCode
          },
          editRecord(val) {
               this.editjobassignment = val
               this.dialog = true
               this.editMode = 1
          },
          deleteRecord(val) {
               this.swal.fire({
                    title: 'Are you sure?',
                    text: val.DeletedDate == null ? "This data wil not be used in any records." : "This wil restore the data.",
                    icon: 'warning',
                    showCancelButton: true,
                    confirmButtonText: val.DeletedDate == null  ? 'Yes, delete it!' : 'Yes, restore it!',
                    denyButtonText: 'Cancel'
               }).then(result => {
                    if(result.isConfirmed) {
                         let body = {
                              procedureName: 'ProcJobAssignment',
                              values: [
                                   val.CompanyCode,
                                   val.DepartmentCode,
                                   val.JobAssignmentCode,
                                   val.JobAssignmentDesc,
                                   val.CreatedDate,
                                   this.moment().format('YYYY-MM-DD hh:mm:ss'),
                                   this.userInfo.EmployeeCode,
                                   0
                              ]
                         }
                         this.axios.post(`${this.api}/execute`, {data: JSON.stringify(body)})
                         this.swal.fire('Confirmed!','Changes has been saved', 'success')
                         this.setNotifications('Deleted a record', `User: ${this.userInfo.EmployeeName} deleted a record`)
                         this.clearVariables()
                    }
               }) 
          },
          clearVariables() {
               this.editjobassignment = {
                    CompanyCode: '',
                    DepartmentCode: '00',
                    JobAssignmentCode: 0,
                    JobAssignmentName: '',
                    CreatedDate: this.moment().format('YYYY-MM-DD hh:mm:ss'),
                    UpdatedDate: this.moment().format('YYYY-MM-DD hh:mm:ss'),
                    UpdatedUserId: '',
                    Option: 1
               },
               this.$refs.form.resetValidation()
               this.dialog = false
               this.editMode = 0
               this.loadJobAssignments()
          }
     }
}
</script>