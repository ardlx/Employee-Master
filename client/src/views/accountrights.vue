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
                <v-card>
                    <v-toolbar :color="themeColor == '' ? 'primary' : themeColor" dark>
                        <v-toolbar-title>Account Rights</v-toolbar-title>
                    </v-toolbar>
                    <v-list>
                        <v-list-item three-line>
                            <v-list-item-avatar :size="50">
                                <v-img :src="`${photo}/${employeeDetails.EmployeeCode}.jpg`"></v-img>
                            </v-list-item-avatar>
                            <v-list-item-content>
                                <v-list-item-title class="font-weight-bold">{{employeeDetails.EmployeeName}} ({{employeeDetails.EmployeeCode}})</v-list-item-title>
                                <v-list-item-subtitle>{{employeeDetails.DepartmentName}}</v-list-item-subtitle>
                                <v-list-item-subtitle>{{employeeDetails.SectionName}}</v-list-item-subtitle>
                            </v-list-item-content>
                        </v-list-item>
                    </v-list>
                    <v-divider class="mx-3"></v-divider>
                    <v-container fluid>
                        <v-row dense>   
                            <v-col cols="12" md="4">
                                <v-autocomplete
                                    v-model="selectedSystem"
                                    label="System"
                                    :color="themeColor == '' ? 'primary' : themeColor"
                                    :items="systemList"
                                    item-value="SystemCode"
                                    item-text="SystemDesc"
                                    @change="loadSystemProcess(selectedSystem)"
                                    hide-details
                                    clearable
                                    outlined
                                    dense
                                ></v-autocomplete>
                            </v-col>
                            <v-spacer></v-spacer>
                            <v-col cols="12" md="6">
                                <v-radio-group class="mt-2" v-model="userRightsAll" hide-details dense row>
                                    <template v-slot:label>
                                        <div class="font-weight-bold">Set Rights All:</div>
                                    </template>
                                    <v-radio
                                        v-for="(item, i) in userRights" :key="i"
                                        :label="item.text"
                                        :value="item.value"
                                        :color="themeColor == '' ? 'primary' : themeColor"
                                    ></v-radio>
                                </v-radio-group>
                            </v-col>
                        </v-row>
                    </v-container>
                    <v-divider></v-divider>
                    <v-data-table
                        v-model="selectedProcess"
                        item-key="ProcessId"
                        :headers="headers"
                        :items="systemProcessLists"
                        :items-per-page="6"
                        :page.sync="page"
                        @page-count="pageCount = $event"
                        hide-default-footer
                        show-select
                    >                        
                        <template v-slot:[`item.Rights`]="{ item }">
                            <v-radio-group class="mt-n2" v-model="item.Rights" hide-details dense row>
                                <v-radio
                                    v-for="(item, i) in userRights" :key="i"
                                    :label="item.text"
                                    :value="item.value"
                                    :color="themeColor == '' ? 'primary' : themeColor"
                                ></v-radio>
                            </v-radio-group>
                        </template>
                    </v-data-table>
                    <v-pagination
                        v-model="page"
                        :length="pageCount"
                        :total-visible="10"
                        :color="themeColor == '' ? 'primary' : themeColor"
                    ></v-pagination>
                    <v-card-actions>
                        <v-card-text class="caption">Total Record(s): {{systemProcessLists.length}}</v-card-text>
                        <v-spacer></v-spacer>
                        <v-btn to="/accounts" class="mx-3" text>
                            <v-icon left>mdi-keyboard-return</v-icon>Back
                        </v-btn>
                        <v-btn @click="saveUserRights()" :color="themeColor == '' ? 'primary' : themeColor" dark>
                            <v-icon left>mdi-content-save</v-icon>Save
                        </v-btn>
                    </v-card-actions>
                    <v-overlay
                        :value="loading"
                        absolute
                    >
                        <v-progress-circular
                            :size="64"
                            indeterminate
                            dark
                        ></v-progress-circular>
                    </v-overlay>
                </v-card>
            </v-container>
        </v-lazy>
    </v-main>
</template>

<script>
export default {
    data() {
        return {
            code: null,
            alert: false,
            loading: true,
            pageCount: 0,
            page: 1,
            userRightsAll: 0,
            selectedSystem: null,
            systemList: [],
            selectedProcess: [],
            systemProcessLists: [],
            employeeDetails: {},
            userRights: [
                {text: 'Read', value: 1},
                {text: 'Write', value: 2},
                {text: 'Full Access', value: 3}
            ],
            headers: [
                {text: 'Id', value: 'ProcessId'},
                {text: 'Process', value: 'ProcessName'},
                {text: 'Account Rights', value: 'Rights'}
            ],
            breadCrumbsItems: [ 
                {text: 'Maintenance', disabled: false, href: '#'},
                {text: 'User Accounts', disabled: false, href: '/employeemaster/accounts'},
                {text: 'Account Rights', disabled: true, href: '#'}
            ]
        }
    },
    created() {
        this.loadEmployeeDetails()
    },
    methods: {
        loadEmployeeDetails() {
            this.loading = true
            this.axios.get(`${this.api}/basicinfo/${this.$route.query.code}`, { headers: this.axiosHeaders }).then(res => {
                this.employeeDetails = res.data[0]
                this.loading = false 
                this.loadSystemLists()
            })
        },
        loadSystemLists() {
            this.axios.get(`${this.api}/systemlist`, { headers: this.axiosHeaders }).then(res => {
                this.systemList = res.data
            })
        },
        loadSystemProcess(syscode) {
            this.loading = true
            this.systemProcessLists = []
            this.axios.get(`${this.api}/systemprocess/${syscode}`, { headers: this.axiosHeaders }).then(res => {
                if(Array.isArray(res.data)) {
                    res.data.forEach(rec => {
                        this.loadSystemProcessRights(rec)
                    })
                    this.loading = false
                }
            })
        },
        loadSystemProcessRights(data) {
            let tempData = {}
            this.axios.get(`${this.api}/processrights/${this.$route.query.code}/${data.SystemCode}/${data.ProcessId}`, { headers: this.axiosHeaders }).then(res => {
                if(res.data[0] != undefined) {
                    tempData = res.data[0]
                    this.systemProcessLists.push({
                        EmployeeCode: tempData.EmployeeCode,
                        SystemCode: tempData.SystemCode,
                        ProcessId: tempData.ProcessId,
                        ProcessName: data.ProcessName,
                        Rights: tempData.Rights
                    })
                } else {
                    this.systemProcessLists.push({
                        EmployeeCode: this.$route.query.code,
                        SystemCode: data.SystemCode,
                        ProcessId: data.ProcessId,
                        ProcessName: data.ProcessName,
                        Rights: 0
                    })
                }
            })
        },
        saveUserRights() {
            let data = []
            let body = {
                procedureName: 'ProcSystemProcessRights',
                values: []
            }
            if(this.selectedSystem == null) {
                this.swal.fire('Oops!','Please select system name', 'warning')
            } else if(this.selectedProcess.length == 0) {
                this.swal.fire('Oops!','Please select process name', 'warning')                
            } else {
                this.selectedProcess.forEach(rec => {
                    data = [
                        rec.EmployeeCode,
                        rec.SystemCode,
                        rec.ProcessId,
                        rec.Rights,
                        this.userInfo.EmployeeCode,
                        1
                    ]
                    body.values.push(data)
                })
                this.axios.post(`${this.api}/execute`, {data: JSON.stringify(body)}, { headers: this.axiosHeaders })
                this.alert = !this.alert
                this.selectedProcess = []
                this.loadSystemProcess(this.selectedSystem)
                this.setNotifications(
                    this.userInfo.EmployeeCode, 
                    'updated an account'
                )
                this.userRightsAll = 0
            }
        }
    },
    watch: {
        selectedProcess(rec) {
            rec.forEach(rec => {
                if(this.userRightsAll != 0) {
                    rec.Rights = this.userRightsAll
                }
            })
        },
        userRightsAll() {
            this.selectedProcess = []
        }
    }
}
</script>