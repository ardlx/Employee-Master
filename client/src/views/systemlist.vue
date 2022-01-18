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
                        <!-- <v-toolbar-title>System Lists</v-toolbar-title> -->
                        <v-spacer></v-spacer>
                        <v-row dense>
                            <v-col class="ml-auto" cols="12" md="6">
                                <v-text-field
                                    v-model="searchTable"
                                    placeholder="Search System"
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
                            :items="systemLists"
                            :loading="loading"
                            :search="searchTable"
                            :page.sync="page"
                            loading-text="Loading Data. . .Please Wait"
                            @page-count="pageCount = $event"
                            hide-default-footer
                    >
                    
                        <v-progress-linear v-show="loading" slot="progress" :color="themeColor == '' ? 'primary' : themeColor" indeterminate></v-progress-linear>
                        <template v-slot:item="props">
                            <tr>
                                <td>{{props.item.SystemCode}}</td>
                                <td>{{props.item.SystemDesc}}</td>
                                <td>
                                    <v-avatar :color="props.item.DeletedDate == null ? 'success' : 'error'" :size="24">
                                        <span></span>
                                    </v-avatar>
                                </td>
                                <td>
                                    <v-tooltip bottom>
                                        <template v-slot:activator="{ on, attrs }">
                                            <v-btn @click="editRecord(props.item)" v-bind="attrs" v-on="on" icon>
                                                <v-icon>mdi-pencil</v-icon>
                                            </v-btn>
                                        </template>
                                        <span>Edit</span>
                                    </v-tooltip>
                                    <v-tooltip bottom>
                                        <template v-slot:activator="{ on, attrs }">
                                            <v-btn @click="saveRecord(props.item, 0)" v-bind="attrs" v-on="on" icon>
                                                <v-icon>mdi-delete</v-icon>
                                            </v-btn>
                                        </template>
                                        <span>Delete</span>
                                    </v-tooltip>
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
                    <v-card-text class="caption">Total Record(s): {{systemLists.length}}</v-card-text>
                </v-card>
            </v-container>
        </v-lazy>
        <v-dialog v-model="dialog" width="900" persistent>
            <v-card>
                <v-toolbar :color="themeColor == '' ? 'primary' : themeColor" dark>
                    <v-toolbar-title>{{editMode == 0 ? "New Record" : "Edit Record"}}</v-toolbar-title>
                </v-toolbar>
                <v-container fluid>
                    <v-form v-model="valid" ref="form" lazy-validation>
                        <v-row dense>
                            <v-col cols="12" md="3">
                                <v-text-field
                                    v-model="editSystemList.SystemCode"
                                    :rules="[v => !!v || 'This field is required']"
                                    :color="themeColor == '' ? 'primary' : themeColor"
                                    label="Code"
                                    hide-details
                                    outlined
                                    dense
                                ></v-text-field>
                            </v-col>
                            <v-col cols="12" md="9">
                                <v-text-field
                                    v-model="editSystemList.SystemDesc"
                                    :rules="[v => !!v || 'This field is required']"
                                    :color="themeColor == '' ? 'primary' : themeColor"
                                    label="Title"
                                    hide-details
                                    outlined
                                    dense
                                ></v-text-field>
                            </v-col>
                        </v-row>
                    </v-form>
                    <v-row v-if="systemProcessMode == 1">
                        <v-col cols="12" md="8">
                            <v-card outlined>
                                <v-simple-table fixed-header height="200px">
                                    <template v-slot:default>
                                        <thead>
                                            <tr>
                                                <th class="font-weight-bold subtitle-2 text-center" v-for="item in headerProcess" :key="item">{{item}}</th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            <tr v-for="(item, i) in systemProcess" :key="i">
                                                <td>{{item.ProcessId}}</td>
                                                <td>{{item.ProcessName}}</td>   
                                                <td>
                                                    <v-avatar :color="item.DeletedDate == null ? 'success' : 'error'" :size="24">
                                                        <span></span>
                                                    </v-avatar>
                                                </td>
                                                <td>
                                                    <v-tooltip bottom>
                                                        <template v-slot:activator="{ on, attrs }">
                                                            <v-btn @click="editProcessRecord(item)" v-on="on" v-bind="attrs" icon>
                                                                <v-icon>mdi-pencil</v-icon>
                                                            </v-btn>
                                                        </template>
                                                        <span>Edit</span>
                                                    </v-tooltip>
                                                    <v-tooltip bottom>
                                                        <template v-slot:activator="{ on, attrs }">
                                                            <v-btn @click="saveSystemProcess(editSystemList.SystemCode, item, 0)" v-on="on" v-bind="attrs" icon>
                                                                <v-icon>mdi-delete</v-icon>
                                                            </v-btn>
                                                        </template>
                                                        <span>Delete</span>
                                                    </v-tooltip>
                                                </td>
                                            </tr>
                                        </tbody>
                                    </template>
                                </v-simple-table>
                                <v-card-text class="caption">Total Record(s): {{systemProcess.length}}</v-card-text>
                            </v-card>
                        </v-col>
                        <v-col cols="12" md="4">
                            <v-card outlined>
                                <v-container fluid>
                                    <v-form v-model="valid" ref="form" lazy-validation>
                                        <v-text-field
                                            v-model="editSystemProcess.ProcessId"
                                            :rules="[v => !!v || 'This field is required']"
                                            :color="themeColor == '' ? 'primary' : themeColor"
                                            :disabled="disableObject"
                                            label="Id"
                                            outlined
                                            dense
                                        ></v-text-field>
                                        <v-text-field
                                            v-model="editSystemProcess.ProcessName"
                                            :rules="[v => !!v || 'This field is required']"
                                            :color="themeColor == '' ? 'primary' : themeColor"
                                            label="Process Name"
                                            :disabled="disableObject"
                                            outlined
                                            dense
                                        ></v-text-field>
                                        <v-text-field
                                            v-model="editSystemProcess.ProcessPath"
                                            :rules="[v => !!v || 'This field is required']"
                                            :color="themeColor == '' ? 'primary' : themeColor"
                                            label="Process Path"
                                            :disabled="disableObject"
                                            outlined
                                            dense
                                        ></v-text-field>
                                    </v-form>
                                    <v-row class="mr-5" align="center" justify="center" dense>
                                        <v-col cols="12" md="4">
                                            <v-btn @click="newSystemProcess()" :disabled="!disableObject" :color="themeColor == '' ? 'primary' : themeColor" small text>
                                                <v-icon left>mdi-pencil</v-icon>New
                                            </v-btn>
                                        </v-col>
                                        <v-col cols="12" md="4">
                                            <v-btn @click="saveSystemProcess(editSystemList.SystemCode, editSystemProcess, 1)" :disabled="disableObject" small text>
                                                <v-icon left>mdi-content-save</v-icon>save
                                            </v-btn>
                                        </v-col>
                                        <v-col cols="12" md="4">
                                            <v-btn @click="clearVariables()" :disabled="disableObject" small text>
                                                <v-icon left>mdi-close</v-icon>Clear
                                            </v-btn>
                                        </v-col>
                                    </v-row>
                                </v-container>
                            </v-card>
                        </v-col>
                    </v-row>
                    <v-card-actions>
                        <v-spacer></v-spacer>
                        <v-btn @click="closeDialog()" text><v-icon left>mdi-cancel</v-icon>Cancel</v-btn>
                        <v-btn v-if="systemProcessMode == 0" @click="saveRecord(editSystemList, 1)" :color="themeColor == '' ? 'primary' : themeColor" dark>
                            <v-icon left>mdi-content-save</v-icon>Save
                        </v-btn>
                    </v-card-actions>
                </v-container>
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
            disableObject: true,
            loading: true,
            valid: true,
            systemProcessMode: 0,
            editMode: 0,
            pageCount: 0,
            page: 1,
            searchTable: '',
            systemLists: [],
            systemProcess: [],
            processRights: [],
            editSystemList: {   
                SystemCode: null,
                SystemDesc: null
            },
            editSystemProcess: {
                SystemCode: null,
                ProcessId: null,
                ProcessName: null,
                ProcessPath: null
            },
            saveOptions: {
                title: 'Are you sure?',
                text: "You won't be able to revert this!",
                icon: 'warning',
                showCancelButton: true,
                confirmButtonText: 'Save',
            },
            headers: [
                {text: 'Code', value: 'SystemCode'},
                {text: 'Title', value: 'SystemDesc'},
                {text: 'Status', value: 'DeletedDate'},
                {text: 'Actions', value: ''}
            ],
            headerProcess: ['Id', 'Process', 'Status', 'Action'],
            breadCrumbsItems: [ 
                {text: 'Maintenance', disabled: false, href: '#'},
                {text: 'System Lists', disabled: true, href: '#'}
            ]
        }
    },
    created() {
        this.loadSystemLists()
    },
    methods: {
        loadSystemLists() {
            this.loading = true
            this.axios.get(`${this.api}/systemlist`, { headers: this.axiosHeaders }).then(res => {
                this.systemLists = res.data
                this.loading = false
            })
        },
        loadSystemProcess(syscode) {
            this.systemProcess = []
            this.axios.get(`${this.api}/systemprocess/${syscode}`, { headers: this.axiosHeaders }).then(res => {
                this.systemProcess = res.data
            })
        },
        editRecord(val) {
            this.editMode = 1
            this.systemProcessMode = 1
            this.dialog = true
            Object.assign(this.editSystemList, {
                SystemCode: val.SystemCode,
                SystemDesc: val.SystemDesc
            })
            this.loadSystemProcess(val.SystemCode)
        },
        newSystemProcess() {
            this.disableObject = !this.disableObject
            this.editSystemProcess = {
                SystemCode: this.editSystemList.SystemCode,
                ProcessId: `${this.editSystemList.SystemCode}-`,
                ProcessName: null,
                ProcessPath: null
            }
        },
        editProcessRecord(val) {
            Object.assign(this.editSystemProcess, {
                SystemCode: val.SystemCode,
                ProcessId: val.ProcessId,
                ProcessName: val.ProcessName,
                ProcessPath: val.ProcessPath
            })
            this.disableObject = false
        },
        saveRecord(val, option) {
            this.swal.fire(this.saveOptions).then(result => {
                if(result.isConfirmed) {
                    let body = {
                        procedureName: 'ProcSystemLists',
                        values: [
                            val.SystemCode.toUpperCase(),
                            this.sentenceCase(val.SystemDesc),
                            this.userInfo.EmployeeCode,
                            option
                        ]
                    }
                    this.axios.post(`${this.api}/execute`, {data: JSON.stringify(body)}, { headers: this.axiosHeaders })
                    this.alert = !this.alert
                    this.systemProcessMode = 1
                    this.clearVariables()
                }
            })
        },  
        saveSystemProcess(syscode, val, option) {
            if (option == 0) { 
                this.swal.fire(this.saveOptions).then(result => {
                    if(result.isConfirmed) {
                        let body = {
                            procedureName: 'ProcSystemProcess',
                            values: [
                                syscode,
                                val.ProcessId,
                                this.sentenceCase(val.ProcessName),
                                val.ProcessPath.toLowerCase(),
                                this.userInfo.EmployeeCode,
                                option
                            ]
                        }
                        this.axios.post(`${this.api}/execute`, {data: JSON.stringify(body)}, { headers: this.axiosHeaders })
                        this.loadSystemProcess(syscode)
                        this.clearVariables()
                    }
                })
            }
            
            if(this.$refs.form.validate()) {
                this.swal.fire(this.saveOptions).then(result => {
                    if(result.isConfirmed) {
                        let body = {
                            procedureName: 'ProcSystemProcess',
                            values: [
                                syscode,
                                val.ProcessId,
                                this.sentenceCase(val.ProcessName),
                                val.ProcessPath.toLowerCase(),
                                this.userInfo.EmployeeCode,
                                option
                            ]
                        }
                        this.axios.post(`${this.api}/execute`, {data: JSON.stringify(body)}, { headers: this.axiosHeaders })
                        this.loadSystemProcess(syscode)
                        this.clearVariables()
                    }
                })
            }
        },  
        closeDialog() {
            this.dialog = false
            this.systemProcessMode = 0
            this.editSystemList = {
                SystemCode: null,
                SystemDesc: null
            }
            this.clearVariables()
            this.loadSystemLists()
        },
        clearVariables() {
            this.editMode = 0
            this.$refs.form.resetValidation()
            this.editSystemProcess = {
                SystemCode: null,
                ProcessId: null,
                ProcessName: null,
                ProcessPath: null
            }
            this.disableObject = true
        }
    }
}
</script>