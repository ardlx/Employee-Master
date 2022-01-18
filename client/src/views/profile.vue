<template>
     <v-main>
          <v-breadcrumbs :items="breadCrumbsItems" divider="/"></v-breadcrumbs>
          <v-lazy transition="scroll-y-transition" :options="{ threshold: 0.8 }">
               <v-container fluid>
                    <v-card class="mx-auto" tile>
                         <transition name="fade" mode="in-out">
                              <v-img height="12.5rem" :src="profileBackground == null ? require('../assets/16251.jpg') : profileBackground"></v-img>
                         </transition>
                         <v-row class="hidden-sm-and-down" dense>
                              <v-col cols="12" md="4">
                                   <v-card-text>
                                        <v-avatar :color="themeColor == '' ? 'primary' : themeColor"  size="150" style="position:absolute; top: 127px">
                                             <v-avatar size="140">
                                                  <v-img :src="`${photo}/${userInfo.EmployeeCode}.jpg`"></v-img>
                                             </v-avatar>
                                        </v-avatar>
                                   </v-card-text>
                              </v-col>
                         </v-row>
                         <v-row class="hidden-md-and-up" align="center" justify="center" dense>
                              <v-col>
                                   <v-card-text class="text-center">
                                        <v-avatar :color="themeColor == '' ? 'primary' : themeColor"  size="150" style="top: -100px; margin-bottom: -130px">
                                             <v-avatar size="140">
                                                  <v-img :src="`${photo}/${userInfo.EmployeeCode}.jpg`"></v-img>
                                             </v-avatar>
                                        </v-avatar>
                                   </v-card-text>
                              </v-col>
                         </v-row>
                         <v-list-item class="mt-12">
                              <v-list-item-content>
                                   <v-list-item-title class="headline">
                                        {{`${information.EmployeeName} (${information.EmployeeCode})`}}
                                   </v-list-item-title>
                                   <v-list-item-subtitle>{{information.DesignationName}}</v-list-item-subtitle>
                                   <v-list-item-subtitle>{{information.WorkEmailAddress}}</v-list-item-subtitle>
                              </v-list-item-content>
                         </v-list-item>
                         <v-divider class="mx-3"></v-divider>
                         <v-card-text>
                              <v-tabs v-model="tab" :color="themeColor == '' ? 'primary' : themeColor" centered icons-and-text grow>
                                   <v-tabs-slider></v-tabs-slider>
                                   <v-tab v-for="(item, i) in tabsHeader" :key="i" :href="`#${item.value}`">
                                        {{item.label}} <v-icon :color="item.color" left>{{item.icon}}</v-icon>
                                   </v-tab>
                              </v-tabs>
                              <v-tabs-items v-model="tab">
                                   <v-tab-item value="1">
                                        <v-card-text>
                                             <v-row align="center" justify="center" dense>
                                                  <v-col cols="12" md="4">
                                                       <v-text-field
                                                            v-model="information.LastName"
                                                            :color="themeColor == '' ? 'primary' : themeColor"
                                                            label="Last Name"
                                                            readonly
                                                            outlined
                                                            dense
                                                       ></v-text-field>
                                                  </v-col>
                                                  <v-col cols="12" md="5">
                                                       <v-text-field
                                                            v-model="information.FirstName"
                                                            :color="themeColor == '' ? 'primary' : themeColor"
                                                            label="First Name"
                                                            readonly
                                                            outlined
                                                            dense
                                                       ></v-text-field>
                                                  </v-col>
                                                  <v-col cols="12" md="3">
                                                       <v-text-field
                                                            v-model="information.MiddleName"
                                                            :color="themeColor == '' ? 'primary' : themeColor"
                                                            label="Middle Name"
                                                            readonly
                                                            outlined
                                                            dense
                                                       ></v-text-field>
                                                  </v-col>
                                             </v-row>
                                             <v-row align="center" justify="center" dense>
                                                  <v-col cols="12" md="12">
                                                       <v-text-field
                                                            v-model="information.DepartmentName"
                                                            :color="themeColor == '' ? 'primary' : themeColor"
                                                            label="Department"
                                                            readonly
                                                            outlined
                                                            dense
                                                       ></v-text-field>
                                                  </v-col>
                                                  <v-col cols="12" md="12">
                                                       <v-text-field
                                                            v-model="information.SectionName"
                                                            :color="themeColor == '' ? 'primary' : themeColor"
                                                            label="Section"
                                                            readonly
                                                            outlined
                                                            dense
                                                       ></v-text-field>
                                                  </v-col>
                                                  <v-col cols="12" md="12">
                                                       <v-text-field
                                                            v-model="information.TeamName"
                                                            :color="themeColor == '' ? 'primary' : themeColor"
                                                            label="Team"
                                                            readonly
                                                            outlined
                                                            dense
                                                       ></v-text-field>
                                                  </v-col>
                                                  <v-col cols="12" md="12">
                                                       <v-text-field
                                                            v-model="information.PositionName"
                                                            :color="themeColor == '' ? 'primary' : themeColor"
                                                            label="Designation"
                                                            readonly
                                                            outlined
                                                            dense
                                                       ></v-text-field>
                                                  </v-col>
                                                  <v-col cols="12" md="12">
                                                       <v-text-field
                                                            v-model="information.DesignationName"
                                                            :color="themeColor == '' ? 'primary' : themeColor"
                                                            label="Position"
                                                            readonly
                                                            outlined
                                                            dense
                                                       ></v-text-field>
                                                  </v-col>
                                                  <v-col cols="12" md="12">
                                                       <v-text-field
                                                            v-model="information.ContractHiredDate"
                                                            :color="themeColor == '' ? 'primary' : themeColor"
                                                            label="Date Hired"
                                                            append-icon="mdi-calendar"
                                                            readonly
                                                            outlined
                                                            dense
                                                       ></v-text-field>
                                                  </v-col>
                                                  <v-col cols="12" md="12">
                                                       <v-text-field
                                                            v-model="information.RetiredDate"
                                                            :color="themeColor == '' ? 'primary' : themeColor"
                                                            label="Department Resigned"
                                                            append-icon="mdi-calendar"
                                                            readonly
                                                            outlined
                                                            dense
                                                       ></v-text-field>
                                                  </v-col>
                                                  <v-col cols="12" md="12">
                                                       <v-text-field
                                                            v-model="information.ShiftTime"
                                                            :color="themeColor == '' ? 'primary' : themeColor"
                                                            label="Shift"
                                                            append-icon="mdi-clock"
                                                            readonly
                                                            outlined
                                                            dense
                                                       ></v-text-field>
                                                  </v-col>
                                                  <v-col cols="12" md="12">
                                                       <v-text-field
                                                            v-model="information.EmployeeStatus"
                                                            :color="themeColor == '' ? 'primary' : themeColor"
                                                            label="Emloyment Status"
                                                            append-icon="mdi-podium-silver"
                                                            readonly
                                                            outlined
                                                            dense
                                                       ></v-text-field>
                                                  </v-col>
                                                  <v-col cols="12" md="12">
                                                       <v-text-field
                                                            v-model="lengthOfService"
                                                            :color="themeColor == '' ? 'primary' : themeColor"
                                                            label="Length of Service"
                                                            append-icon="mdi-briefcase"
                                                            readonly
                                                            outlined
                                                            dense
                                                       ></v-text-field>
                                                  </v-col>
                                             </v-row>
                                        </v-card-text>
                                   </v-tab-item>
                                   <v-tab-item value="2">
                                        <v-card-text>
                                             <v-row align="center" justify="center" dense>
                                                  <v-col cols="12" md="8">
                                                       <v-text-field
                                                            v-model="information.NickName"
                                                            :color="themeColor == '' ? 'primary' : themeColor"
                                                            label="Nick Name"
                                                            readonly
                                                            outlined
                                                            dense
                                                       ></v-text-field>
                                                  </v-col>
                                                  <v-col cols="12" md="2">
                                                       <v-text-field
                                                            v-model="dateBirth"
                                                            label="Date of Birth"
                                                            append-icon="mdi-calendar"
                                                            :color="themeColor == '' ? 'primary' : themeColor"
                                                            readonly
                                                            outlined
                                                            dense
                                                       ></v-text-field>
                                                  </v-col>
                                                  <v-col cols="12" md="1">
                                                       <v-text-field
                                                            v-model="ageValue"
                                                            :color="themeColor == '' ? 'primary' : themeColor"
                                                            label="Age"
                                                            readonly
                                                            outlined
                                                            dense
                                                       ></v-text-field>
                                                  </v-col>
                                                  <v-col cols="12" md="1">
                                                       <v-text-field
                                                            v-model="genderValue"
                                                            :color="themeColor == '' ? 'primary' : themeColor"
                                                            label="Gender"
                                                            readonly
                                                            outlined
                                                            dense
                                                       ></v-text-field>
                                                  </v-col>
                                                  <v-col cols="12" md="8">
                                                       <v-text-field
                                                            v-model="information.Course"
                                                            :color="themeColor == '' ? 'primary' : themeColor"
                                                            label="Course"
                                                            readonly
                                                            outlined
                                                            dense
                                                       ></v-text-field>
                                                  </v-col>
                                                  <v-col cols="12" md="4">
                                                       <v-text-field
                                                            v-model="information.EducDesc"
                                                            :color="themeColor == '' ? 'primary' : themeColor"
                                                            label="Educational Attainment"
                                                            readonly
                                                            outlined
                                                            dense
                                                       ></v-text-field>
                                                  </v-col>
                                                  <v-col cols="12" md="6">
                                                       <v-text-field
                                                            v-model="information.Phone"
                                                            :color="themeColor == '' ? 'primary' : themeColor"
                                                            append-icon="mdi-phone"
                                                            label="Telephone"
                                                            readonly
                                                            outlined
                                                            dense
                                                       ></v-text-field>
                                                  </v-col>
                                                  <v-col cols="12" md="6">
                                                       <v-text-field
                                                            v-model="information.Cellphone"
                                                            :color="themeColor == '' ? 'primary' : themeColor"
                                                            append-icon="mdi-cellphone"
                                                            label="Cellphone"
                                                            readonly
                                                            outlined
                                                            dense
                                                       ></v-text-field>
                                                  </v-col>
                                                  <v-col cols="12" md="6">
                                                       <v-textarea
                                                            v-model="information.PresentAddress"
                                                            :color="themeColor == '' ? 'primary' : themeColor"
                                                            label="Present Address"
                                                            readonly
                                                            outlined
                                                            dense
                                                       ></v-textarea>
                                                  </v-col>
                                                  <v-col cols="12" md="6">
                                                       <v-textarea
                                                            v-model="information.PermanentAddress"
                                                            :color="themeColor == '' ? 'primary' : themeColor"
                                                            label="Permanent Address"
                                                            readonly
                                                            outlined
                                                            dense
                                                       ></v-textarea>
                                                  </v-col>
                                             </v-row>
                                        </v-card-text>
                                   </v-tab-item>
                                   <v-tab-item value="3">
                                        <v-card-text>
                                             <v-row align="center" justify="center" dense>
                                                  <v-col cols="12" md="12">
                                                       <v-text-field
                                                            v-model="information.ConPerson"
                                                            :color="themeColor == '' ? 'primary' : themeColor"
                                                            label="Contact Person"
                                                            readonly
                                                            outlined
                                                            dense
                                                       ></v-text-field>
                                                  </v-col>
                                                  <v-col cols="12" md="12">
                                                       <v-text-field
                                                            v-model="information.ConRelationship"
                                                            :color="themeColor == '' ? 'primary' : themeColor"
                                                            label="Relationship"
                                                            readonly
                                                            outlined
                                                            dense
                                                       ></v-text-field>
                                                  </v-col>
                                                  <v-col cols="12" md="12">
                                                       <v-textarea
                                                            v-model="information.ConAddress"
                                                            :color="themeColor == '' ? 'primary' : themeColor"
                                                            label="Contact Address"
                                                            readonly
                                                            outlined
                                                            dense
                                                       ></v-textarea>
                                                  </v-col>
                                                  <v-col cols="12" md="12">
                                                       <v-text-field
                                                            v-model="information.ConNumber"
                                                            :color="themeColor == '' ? 'primary' : themeColor"
                                                            append-icon="mdi-phone"
                                                            label="Contact Phone No."
                                                            readonly
                                                            outlined
                                                            dense
                                                       ></v-text-field>
                                                  </v-col>
                                             </v-row>
                                        </v-card-text>
                                   </v-tab-item>
                                   <v-tab-item value="4">
                                        <v-card-text>
                                             <v-row align="center" dense>
                                                  <v-col cols="12" md="6">
                                                       <v-text-field
                                                            v-model="information.CPUNumber"
                                                            :color="themeColor == '' ? 'primary' : themeColor"
                                                            append-icon="mdi-desktop-classic"
                                                            label="CPU Number"
                                                            outlined
                                                            dense
                                                       ></v-text-field>
                                                  </v-col>
                                                  <v-col cols="12" md="6">
                                                       <v-text-field
                                                            v-model="information.IPAddress"
                                                            :color="themeColor == '' ? 'primary' : themeColor"
                                                            append-icon="mdi-ip"
                                                            label="IP Address"
                                                            outlined
                                                            dense
                                                       ></v-text-field>
                                                  </v-col>
                                                  <v-col cols="12" md="6">
                                                       <v-text-field
                                                            v-model="information.CompUserName"
                                                            :color="themeColor == '' ? 'primary' : themeColor"
                                                            append-icon="mdi-account"
                                                            label="Computer Username"
                                                            outlined
                                                            dense
                                                       ></v-text-field>
                                                  </v-col>
                                                  <v-col cols="12" md="6">
                                                       <v-text-field
                                                            v-model="information.CompPassword"
                                                            :color="themeColor == '' ? 'primary' : themeColor"
                                                            append-icon="mdi-lock"
                                                            label="Computer Password"
                                                            type="password"
                                                            outlined
                                                            dense
                                                       ></v-text-field>
                                                  </v-col>
                                                  <v-col cols="12" md="6">
                                                       <v-text-field
                                                            v-model="information.WorkEmailAddress"
                                                            :color="themeColor == '' ? 'primary' : themeColor"
                                                            append-icon="mdi-email"
                                                            label="Work Email Address"
                                                            outlined
                                                            dense
                                                       ></v-text-field>
                                                  </v-col>
                                                  <v-col cols="12" md="6">
                                                       <v-text-field
                                                            v-model="information.WorkLocation"
                                                            :color="themeColor == '' ? 'primary' : themeColor"
                                                            append-icon="mdi-map-marker"
                                                            label="Work Location"
                                                            outlined
                                                            dense
                                                       ></v-text-field>
                                                  </v-col>
                                                  <v-col cols="12" md="6">
                                                       <v-text-field
                                                            v-model="information.LocalNumber"
                                                            :color="themeColor == '' ? 'primary' : themeColor"
                                                            append-icon="mdi-phone-classic"
                                                            label="Local No."
                                                            v-mask="'####-###'"
                                                            hint="####-###"
                                                            outlined
                                                            dense
                                                       ></v-text-field>
                                                  </v-col>
                                                  <v-col cols="12" md="6">
                                                       <v-text-field
                                                            v-model="information.StaffCode"
                                                            :color="themeColor == '' ? 'primary' : themeColor"
                                                            append-icon="mdi-account-hard-hat"
                                                            label="Staff Code"
                                                            outlined
                                                            dense
                                                       ></v-text-field>
                                                  </v-col>
                                                  <v-col cols="12" md="6">
                                                       <v-autocomplete
                                                            v-model="information.JobAssignmentCode"
                                                            :color="themeColor == '' ? 'primary' : themeColor"
                                                            :items="jobassignments"
                                                            item-text="JobAssignmentDesc"
                                                            item-value="JobAssignmentCode"
                                                            label="Job Assignment"
                                                            outlined
                                                            dense
                                                       ></v-autocomplete>
                                                  </v-col>
                                                  <v-col cols="12" md="6">
                                                       <v-autocomplete
                                                            v-model="information.CategoryCode"
                                                            :color="themeColor == '' ? 'primary' : themeColor"
                                                            :items="category"
                                                            item-text="label"
                                                            item-value="value"
                                                            label="Category"
                                                            outlined
                                                            dense
                                                       ></v-autocomplete>
                                                  </v-col>
                                                  <v-col cols="12" md="6">
                                                       <v-text-field
                                                            v-model="information.ProductCategoryDesc"
                                                            label="Product Category"
                                                            :color="themeColor == '' ? 'primary' : themeColor"
                                                            outlined
                                                            readonly
                                                            dense
                                                       ></v-text-field>
                                                  </v-col>
                                             </v-row>
                                        </v-card-text>
                                   </v-tab-item>
                              </v-tabs-items>
                              <v-card-actions v-if="tab == 4">
                                   <v-spacer></v-spacer>
                                   <v-btn @click="loadInformation()" text>
                                        <v-icon left>mdi-cancel</v-icon>Cancel
                                   </v-btn>
                                   <v-btn :color="themeColor == '' ? 'primary' : themeColor" @click="saveRecord()" dark>
                                        <v-icon left>mdi-content-save</v-icon>Save
                                   </v-btn>
                              </v-card-actions>
                         </v-card-text>
                    </v-card>
               </v-container>
          </v-lazy>
          <v-overlay :value="overlay">
               <v-progress-circular
                    :size="100"
                    indeterminate
               ></v-progress-circular>
          </v-overlay>
     </v-main>
</template>

<script>

export default {
     data() {
          return {
               tab: null,
               dateDialog: false,
               overlay: true,
               ageValue: 0,
               genderValue: '',
               information: '',
               dateBirth: '',
               lengthOfService: '',
               departmentList: [],
               sectionList: [],
               teamList: [],
               designationList: [],
               positionList: [],
               educationList: [],
               breadCrumbsItems: [],
               shiftList: [],
               operatingSystem: [],
               jobassignments: [],
               category: [
                    {label: 'Direct', value: 'D'},
                    {label: 'Indirect', value: 'I'}
               ],
               saveOptions: {
                    title: 'Are you sure?',
                    text: "You won't be able to revert this!",
                    icon: 'warning',
                    showDenyButton: true,
                    showCancelButton: true,
                    confirmButtonText: 'Save',
                    denyButtonText: `Don't Save`
               },
               tabsHeader: [
                    {label: 'Employee Information', icon:'mdi-account', value: 1, color: 'primary'},
                    {label: 'Other Information', icon:'mdi-card-bulleted', value: 2, color: 'warning'},
                    {label: 'Contact Person', icon:'mdi-card-account-details', value: 3, color: 'error'},
                    {label: 'Work Information', icon:'mdi-briefcase', value: 4, color: 'success'}
               ],
               marStatus: [
                    {label: 'Single', value: 'S'},
                    {label: 'Married', value: 'M'},
                    {label: 'Widowed/Widower', value: 'W'},
                    {label: 'Separated', value: 'C'}
               ]
          }
     },
     created() {
          this.loadInformation()
     },
     sockets: {
          showNotifications() {
               setTimeout(() => {
                    this.loadInformation()
               }, 1700);
          },
          connect() {
               this.loadInformation()
               this.$store.commit('CHANGE_CONNECTION', true)
          },
          disconnect() {
               this.$router.push('*')
               this.$store.commit('CHANGE_CONNECTION', false)
          }
     },
     methods: {
          loadInformation() {
               this.overlay = true
               this.information = []
               this.axios.get(`${this.api}/employeeinfo/${this.userInfo.EmployeeCode}`, { headers: this.axiosHeaders }).then(res => {
                    this.information = res.data[0]
                    // If variable has no error
                    if(this.information) {
                         this.breadCrumbsItems = [
                              {text: this.userInfo.UserLevel == 0 ? 'Employee' : 'Maintenance', disabled: false, href: '#'},
                              {text: 'Profile', disabled: true, href: '#'}
                         ]
                         this.loadEducations()
                         this.loadShifts()
                    // catch error goto error page
                    } else {
                         // this.$router.push('*')
                         console.log(res.data);
                    }
                    this.overlay = false
               })
          },
          loadEducations() {
               this.axios.get(`${this.api}/education`, { headers: this.axiosHeaders }).then(res => {
                    this.educationList = res.data
                    this.loadOperatingSystem()
               })
          },
          loadShifts() {
               this.axios.get(`${this.api}/shift/${this.userInfo.ShortName}`, { headers: this.axiosHeaders }).then(res => {
                    this.shiftList = res.data
               })
          },
          loadOperatingSystem() {
               this.axios.get(`${this.api}/os`, { headers: this.axiosHeaders }).then(res => {
                    this.operatingSystem = res.data
                    this.loadJobAssignments()
               })
          },
          loadJobAssignments() {
               this.axios.get(`${this.api}/jobassignment/${this.userInfo.ShortName}/${this.userInfo.DepartmentName}`, { headers: this.axiosHeaders }).then(async res => {
                    this.jobassignments = await res.data
               })
          },
          saveRecord() {
               this.swal.fire(this.saveOptions).then(result => {
                    if(result.isConfirmed) {
                         let body = {
                              procedureName: 'ProcPostEmployee',
                              values: [	
                                        this.information.CompanyCode,
                                        this.information.EmployeeCode,
                                        this.information.AgencyCode,
                                        this.information.LastName,
                                        this.information.FirstName,
                                        this.information.MiddleName,
                                        this.information.NickName,
                                        this.information.Gender,
                                        this.information.DateBirth,
                                        this.information.MarStatus,
                                        this.information.NoOfChildren,
                                        this.information.EducCode,
                                        this.information.Phone,
                                        this.information.Cellphone,
                                        this.information.PresentAddress,
                                        this.information.PermanentAddress,
                                        this.information.Course,
                                        this.information.School,
                                        this.information.ConPerson,
                                        this.information.ConRelationship,
                                        this.information.ConAddress,
                                        this.information.ConNumber,
                                        this.information.ShiftID,
                                        this.information.DepartmentCode,
                                        this.information.SectionCode,
                                        this.information.TeamCode,
                                        this.information.PositionCode,
                                        this.information.DesignationCode,
                                        this.information.SalaryGrade,
                                        this.information.ContractStatus,
                                        this.information.ContractHiredDate,
                                        this.information.RegularHiredDate,
                                        this.information.RetiredDate,
                                        this.information.StaffCode,
                                        this.information.CPUNumber,
                                        this.information.IPAddress,
                                        this.information.CompUserName,
                                        this.information.CompPassword,
                                        this.information.OperatingSystem,
                                        this.information.WorkEmailAddress,
                                        this.information.WorkLocation,
                                        this.information.LocalNumber,
                                        this.information.JobAssignmentCode,
                                        this.information.CategoryCode,
                                        this.moment().format('YYYY-MM-DD'),
                                        this.moment().format('YYYY-MM-DD'),
                                        this.userInfo.EmployeeCode  
                              ]
                         }
                         this.axios.post(`${this.api}/execute`, {data: JSON.stringify(body)}, { headers: this.axiosHeaders })
                         this.swal.fire('Hooray!','Changes has been saved', 'success')
                         this.loadInformation()
                    } else if(result.isDenied) {
                         this.swal.fire('Oh no!', 'Changes are not saved', 'info')
                    }
               })
          }
     },
     watch: {
          information(val) {
               // Format dates
               val.ContractHiredDate = val.ContractHiredDate ? this.moment(val.ContractHiredDate).format('YYYY-MM-DD') : ""
               val.RegularHiredDate = val.RegularHiredDate ? this.moment(val.RegularHiredDate).format('YYYY-MM-DD') : ""
               val.RetiredDate = val.RetiredDate ? this.moment(val.RetiredDate).format('YYYY-MM-DD') : ""
               this.dateBirth = val.DateBirth ? this.moment(val.DateBirth).format('YYYY-MM-DD') : ""
               this.genderValue = val.Gender == 'M' ? 'Male' : 'Female'
               this.ageValue = this.moment().diff(this.dateBirth, 'years')
               this.lengthOfService = this.moment().diff(val.ContractHiredDate, 'years')
          },
          dateBirth(val) {
               this.information.DateBirth = val
               this.ageValue = this.moment().diff(val, 'years')
          }
     }
}
</script>