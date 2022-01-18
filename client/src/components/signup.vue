<template>
     <v-dialog
          v-model="dialog"
          width="600"
          transition="scale-transition"
          persistent
     >
          <v-card>
               <v-container fill-height fluid>
                    <v-toolbar flat>
                         <v-toolbar-title class="text-center headline">
                              Create account
                         </v-toolbar-title>
                    </v-toolbar>
                    <v-row align="center" justify="center">
                         <v-col cols="12">
                              <!-- <v-card elevation="7"> -->
                              <v-card-text class="text-center subheading">
                                   <v-form v-model="valid" ref="form" lazy-validation>
                                   <v-card-text>
                                        <v-row align="center" justify="center" dense>
                                             <v-col cols="12" md="3">
                                                  <v-text-field
                                                       v-model="editedAccount.EmployeeCode"
                                                       label="Employee Code"
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
                                                                      color="primary"
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
                                        </v-row>
                                   </v-card-text>
                              </v-form>
                              <v-card-actions>
                                   <v-btn @click="saveRecord()" :color="themeColor == '' ? 'primary' : themeColor" :disabled="disableButton" :dark="!disableButton" block>
                                        Create an account
                                   </v-btn>
                              </v-card-actions>
                              <v-card-actions>
                                   <v-btn @click="clearVariables()" :color="themeColor == '' ? 'primary' : themeColor" block dark>
                                        Log in to your account
                                   </v-btn>
                              </v-card-actions>
                              </v-card-text>
                              <!-- </v-card> -->
                         </v-col>
                    </v-row>
               </v-container>
          </v-card>
     </v-dialog>
</template>

<script>
export default {
     props: ['signUpDialog'],
     data() {
          return {
               valid: true,
               dialog: false,
               loadName: false,
               disableButton: false,
               newPassword: '',
               confirmedPassword: '',
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
                    showDenyButton: true,
                    confirmButtonText: 'Save'
               },
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
                                             "",
                                             0,
                                             this.moment().format('YYYY-MM-DD'),
                                             this.moment().format('YYYY-MM-DD'),
                                             "ASD",
                                             1
                                        ]
                                   }
                                   this.axios.post(`${this.api}/execute`, {data: JSON.stringify(body)}, { headers: this.axiosHeaders })
                                   this.swal.fire('Hooray!','Changes has been saved', 'success')
                                   this.clearVariables()
                              }
                         })
                    }
               }
          },
          getEmployeeFullname() {
               let data = {}
               if(this.editedAccount.EmployeeCode != '') {
                    this.loadName = true
                    this.axios.get(`${this.api}/employeeinfo/${this.editedAccount.EmployeeCode}`, { headers: this.axiosHeaders }).then(res => {
                         data = res.data[0]
                         this.$refs.form.resetValidation()
                         if(data != undefined) {
                              this.editedAccount.Fullname = data.EmployeeName
                              if(data.IsAccountExists == 0) {
                                   this.disableButton = false
                              } else {
                                   this.disableButton = true
                              }
                         } else {
                              this.swal.fire('','No record found', 'error')
                              this.disableButton = true
                         }
                         this.loadName = false
                    })
               }
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
               this.disableButton = false
          }
     },
     watch: {
          signUpDialog() {
               this.dialog = true
          }
     }
}
</script>