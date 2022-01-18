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
                                        <!-- <v-card-text class="pa-0 headline">Department-Section-Team</v-card-text> -->
                                        <v-text-field
                                             v-model="searchTable"
                                             placeholder="Search Department, Section. . ."
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
                         <v-card-title>
                              <v-row dense>
                                   <v-col cols="4">
                                        <v-autocomplete
                                        v-model="departmentfilter"
                                        :items="departmentlistfilter"
                                        :color="themeColor == '' ? 'primary' : themeColor"
                                        label="Department"    
                                        hide-details
                                        clearable                                 
                                        outlined
                                        dense
                                        ></v-autocomplete>
                                   </v-col>
                                   <v-col cols="4">
                                        <v-autocomplete 
                                        v-model="sectionfilter"
                                        :items="sectionlistfilter"
                                        :color="themeColor == '' ? 'primary' : themeColor"
                                        label="Section"  
                                        hide-details 
                                        clearable    
                                        outlined
                                        dense
                                        ></v-autocomplete>
                                   </v-col>
                                   <v-col cols="4">
                                        <v-autocomplete 
                                        v-model="teamfilter"
                                        :items="teamlistfilter"
                                        :color="themeColor == '' ? 'primary' : themeColor"
                                        label="Team" 
                                        hide-details
                                        clearable    
                                        outlined
                                        dense
                                        ></v-autocomplete>
                                   </v-col>
                              </v-row>
                         </v-card-title>   
                         <v-divider></v-divider>  
                         <v-data-table
                              :headers="headers"
                              :items="filterData"
                              :search="searchTable"
                              :page.sync="page"
                              :items-per-page="8"
                              loading-text="Loading Data. . .Please Wait"
                              :loading="loading"
                              @page-count="pageCount = $event"
                                   hide-default-footer
                         >
                              
                              <v-progress-linear v-show="loading" slot="progress" :color="themeColor == '' ? 'primary' : themeColor" indeterminate></v-progress-linear>
                              <template v-slot:item="props">                             
                                   <tr>
                                        <td>{{props.item.DepartmentName}}</td>                              
                                        <td>{{props.item.SectionName}}</td>   
                                        <td>{{props.item.TeamName}}</td>      
                                        <td>
                                             <v-btn @click="editRecord(props.item)" :disabled="userInfo.UserLevel == 4 && userInfo.UserLevel == 9 && userRights > 1" icon>
                                                  <v-icon>mdi-pencil</v-icon>
                                             </v-btn>
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
                         <v-card-text class="caption">Total Record(s): {{filterData.length}}</v-card-text>
               </v-card>
               </v-container>
          </v-lazy>
          <v-dialog v-model="dialog" width="500" persistent>
               <v-card>
                    <v-toolbar :color="themeColor == '' ? 'primary' : themeColor" flat dark>
                         <v-toolbar-title>{{editMode ? 'Edit Record' : 'New Record'}}</v-toolbar-title>
                    </v-toolbar>
                    <v-container fluid>
                         <v-form ref="form"  lazy-validation>
                              <v-row align="center" justify="center" dense>
                                   <v-col cols="12" md="12">                                 
                                        <v-autocomplete
                                             v-model="editdivsecteam.DepartmentCode"
                                             :items="departmentList"
                                             :color="themeColor == '' ? 'primary' : themeColor"
                                             item-value="DepartmentCode"
                                             item-text="DepartmentName"
                                             label="Department"   
                                             hide-details
                                             clearable    
                                             outlined
                                             dense
                                             :rules="[v => !!v || 'Department is required']"
                                        ></v-autocomplete>                                         
                                   </v-col>
                                   <v-col cols="12" md="12">      
                                        <v-autocomplete 
                                             v-model="editdivsecteam.SectionCode"
                                             :items="sectionList"
                                             :color="themeColor == '' ? 'primary' : themeColor"
                                             item-value="SectionCode"
                                             item-text="SectionName"
                                             label="Section" 
                                             hide-details  
                                             clearable    
                                             outlined
                                             dense
                                             :rules="[v => !!v || 'Section is required']"
                                        ></v-autocomplete>       
                                   </v-col>
                                   <v-col cols="12" md="12">                       
                                        <v-autocomplete 
                                             v-model="editdivsecteam.TeamCode"
                                             :items="teamList"
                                             :color="themeColor == '' ? 'primary' : themeColor"
                                             item-value="TeamCode"
                                             item-text="TeamName"
                                             label="Team" 
                                             hide-details
                                             clearable    
                                             outlined
                                             dense
                                             :rules="[v => !!v || 'Team is required']"
                                        ></v-autocomplete>  
                                   </v-col>
                                   <!-- <v-col cols="12" md="12">                       
                                        <v-autocomplete 
                                             v-model="editdivsecteam.ProductCategoryNo"
                                             :items="productCategories"
                                             :color="themeColor == '' ? 'primary' : themeColor"
                                             item-value="ProductCategoryNo"
                                             item-text="ProductCategoryDesc"
                                             label="Product Category" 
                                             hide-details
                                             clearable    
                                             outlined
                                             dense
                                             :rules="[v => !!v || 'Product Category is required']"
                                        ></v-autocomplete>  
                                   </v-col> -->
                              </v-row>
                         </v-form>                         
                    </v-container>
                    <v-card-actions>
                         <v-spacer></v-spacer>    
                         <v-btn @click="clearVariables()" text><v-icon left>mdi-cancel</v-icon> Cancel</v-btn>
                         <v-btn @click="saveRecord()" :color="themeColor == '' ? 'primary' : themeColor" dark><v-icon left>mdi-content-save</v-icon> Save</v-btn>
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
               dialog:false,
               editMode: false,
               departmentfilter:'',
               sectionfilter:'',
               teamfilter:'',
               prodCategoryfilter: '',
               searchTable: '',
               departmentList: [],
               sectionList: [],
               teamList: [],
               productCategories: [],
               divsecteam:[],
               department:[],
               pageCount: 0,
               userRights: 0,
               page: 1,
               loading:true,
               headers:[
                    {text:"Department",value:"DepartmentName"},
                    {text:"Section",value:"SectionName"},
                    {text:"Team",value: "TeamName"},
                    {text:"Actions",value: "actions"}             
               ],
               breadCrumbsItems: [
                    {text: 'Main Data', disabled: false, href: '#'},
                    {text: 'Department - Section', disabled: true, href: '#'}
               ],
               editdivsecteam:{
                    CompanyCode: '',
                    DepartmentCode: '',
                    SectionCode: '',
                    TeamCode: '',
                    ProductCategoryNo: 0,
                    CreatedDate: this.moment().format('YYYY-MM-DD hh:mm:ss'),
                    UpdatedDate: this.moment().format('YYYY-MM-DD hh:mm:ss'),
                    UpdatedUserId: '',
                    Option: 1
               },               
               saveOptions: {
                    title: 'Are you sure?',
                    text: "You won't be able to revert this!",
                    icon: 'warning',
                    showCancelButton: true,
                    confirmButtonText: 'Save',
               },
          }
     },
     computed:{
          filterData() {
               return this.divsecteam.filter(rec => {
                    return (
                         rec.DepartmentName.includes(this.departmentfilter || '') &&
                         rec.SectionName.includes(this.sectionfilter || '') && 
                         rec.TeamName.includes(this.teamfilter || '')
                    )

               })
          },
          departmentlistfilter(){
               if(this.userInfo.UserLevel==5){
                    return this.userInfo.AssignDepartments.map((rec)=>{
                         return rec
                    }).sort()                
               } else {
                    return this.divsecteam.map((rec)=>{
                         return rec.DepartmentName
                    }).sort()                        
               }
           
          },
          sectionlistfilter(){
               return this.filterData.map((rec)=>{
                    return rec.SectionName
               }).sort()                
          },
          teamlistfilter(){
               return this.filterData.map((rec)=>{
                    return rec.TeamName
               }).sort()               
          },       
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
     methods:{
          loadRights() {
               let level = this.userInfo.UserLevel
               if(level != 9 && level != 8 && level != 5 ) {
                    this.axios.get(`${this.api}/processrights/${this.userInfo.EmployeeCode}/EM01/${this.$route.query.id}`, { headers: this.axiosHeaders }).then(res => {
                         this.userRights = res.data[0].Rights
                         this.loaddivsectionteam()
                    })
               } else {
                    this.loaddivsectionteam()
               }
          },
          loaddivsectionteam(){
               this.loading= true
               let url = ''
               if (this.userInfo.UserLevel==5){
                    url=`${this.api}/company/department/section/team/${this.userInfo.Comp_Name}`
               }else {
                    url=`${this.api}/company/department/section/team/${this.userInfo.ShortName}`
               }
               this.axios.get(url, { headers: this.axiosHeaders }).then(res=>{
                    this.divsecteam = res.data
                    this.loadDepartment()
                    this.loading=false
               })
          },
          loadDepartment() {
               let url = ''
               if (this.userInfo.UserLevel==5){
                    url=`${this.api}/company/department/${this.userInfo.Comp_Name}`
               }else {
                    url=`${this.api}/company/department/${this.userInfo.ShortName}`
               }
               this.axios.get(url, { headers: this.axiosHeaders }).then(res=>{
                    this.departmentList = res.data
                    this.loadSection()
               })
          },
          loadSection() {
               let url = ''
               if (this.userInfo.UserLevel==5){
                    url=`${this.api}/company/section/${this.userInfo.Comp_Name}`
               }else {
                    url=`${this.api}/company/section/${this.userInfo.ShortName}`
               }
               this.axios.get(url, { headers: this.axiosHeaders }).then(res=>{
                    this.sectionList = res.data
                    this.loadTeam()
               })
          },
          loadTeam() {
               let url = ''
               if (this.userInfo.UserLevel==5){
                    url=`${this.api}/company/team/${this.userInfo.Comp_Name}`
               }else {
                    url=`${this.api}/company/team/${this.userInfo.ShortName}`
               }
               this.axios.get(url, { headers: this.axiosHeaders }).then(res=>{
                    this.teamList = res.data
                    this.loadProductCategory()
               })
          },
          loadProductCategory() {
               let url = ''
               if (this.userInfo.UserLevel==5){
                    url=`${this.api}/productcategory/${this.userInfo.Comp_Name}`
               }else {
                    url=`${this.api}/productcategory/${this.userInfo.ShortName}`
               }
               this.axios.get(url, { headers: this.axiosHeaders }).then(res=>{
                    this.productCategories = res.data
               })
          },
          newRecord(){
               this.dialog=true
               this.editdivsecteam.CompanyCode=this.userInfo.CompanyCode
          },
          saveRecord(){
               if (this.$refs.form.validate()){                   
                    this.swal.fire(this.saveOptions).then(result=>{
                         if(result.isConfirmed){
                              let body = {
                                   procedureName:"ProcDivSecteam",
                                   values:[
                                        this.editdivsecteam.CompanyCode,
                                        this.editdivsecteam.DepartmentCode,
                                        this.editdivsecteam.SectionCode,
                                        this.editdivsecteam.TeamCode,
                                        this.editdivsecteam.ProductCategoryNo,
                                        this.editdivsecteam.CreatedDate,
                                        this.editdivsecteam.UpdatedDate,
                                        this.userInfo.EmployeeCode,
                                        1
                                   ]
                              }
                              //     console.log(body)
                              this.axios.post(`${this.api}/execute`,{data:JSON.stringify(body)}, { headers: this.axiosHeaders })
                              this.alert = !this.alert
                              this.setNotifications(
                                   this.userInfo.EmployeeCode, 
                                   this.editMode == 0 ? 'added a new Department relation' : 'updated a Department relation'
                              )
                              this.clearVariables()
                         }
                    })
               }
          },
          editRecord(data) {
               this.editMode = true
               this.dialog = true
               Object.assign(this.editdivsecteam, data)
          },
          clearVariables(){
               this.$refs.form.resetValidation()
               this.editdivsecteam={
                    CompanyCode: '',
                    DepartmentCode: '',
                    SectionCode: '',
                    TeamCode: '',
                    CreatedDate: this.moment().format('YYYY-MM-DD hh:mm:ss'),
                    UpdatedDate: this.moment().format('YYYY-MM-DD hh:mm:ss'),
                    UpdatedUserId: '',
                    Option: 1
               }
               this.loaddivsectionteam()
               this.dialog = false
               this.editMode = false
          }
     }
}
</script>