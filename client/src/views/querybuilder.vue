<template>
    <v-main>
        <v-breadcrumbs :items="breadCrumbsItems" divider="/"></v-breadcrumbs>
        <v-lazy transition="scroll-y-transition" :options="{ threshold: 0.8 }">
            <v-container class="mt-n3" fluid>
                <v-card>
                    <v-toolbar id="top" :color="themeColor == '' ? 'primary' : themeColor" dark>
                        <v-toolbar-title>Query Builder</v-toolbar-title>
                        <v-spacer></v-spacer>
                        <v-tooltip bottom>
                            <template v-slot:activator="{ on, attrs }"> 
                                <v-btn v-on="on" v-bind="attrs" @click="$tours['startTour'].start()" icon>
                                    <v-icon>mdi-help-circle-outline</v-icon>
                                </v-btn>
                            </template>
                            <span>Help</span>
                        </v-tooltip>
                    </v-toolbar>
                    <v-card-text>
                        <v-form id="step4" v-model="valid" ref="form" lazy-validation>
                            <v-row dense>
                                <v-col cols="12" md="3">
                                    <v-autocomplete
                                        v-model="selectedFilter"
                                        :items="filterByItems"
                                        :rules="[v => !!v || 'Field Name is required']"
                                        :color="themeColor == '' ? 'primary' : themeColor"
                                        label="Field Name"
                                        hide-details
                                        clearable
                                        outlined
                                        dense
                                    ></v-autocomplete>
                                </v-col>
                                <v-col cols="12" :md="showPickerTo > 0 ? 3 : 2">
                                    <v-select
                                        v-model="selectedOperator"
                                        :items="operatorItems"
                                        :rules="[v => !!v || 'Operator is required']"
                                        :color="themeColor == '' ? 'primary' : themeColor"
                                        label="Operator"
                                        return-object
                                        hide-details
                                        clearable
                                        outlined
                                        dense
                                    ></v-select>
                                </v-col>
                                <v-col v-if="showPickerFrom == 0" cols="12" :md="showPickerTo > 0 ? 2 : 3">
                                    <v-text-field
                                        v-model="searchBy"
                                        :rules="[v => !!v || 'This field is required']"
                                        :color="themeColor == '' ? 'primary' : themeColor"
                                        label="Value"
                                        hide-details
                                        clearable
                                        outlined
                                        dense
                                    ></v-text-field>
                                </v-col>
                                <v-col v-if="showPickerFrom > 0" cols="12" md="2">
                                    <datePicker
                                        :menu="dateDialog"
                                        dateLabel="From"
                                        :dateValue.sync="dateFilterItems[0]"
                                    ></datePicker>
                                </v-col>
                                <v-col v-if="showPickerTo > 0" cols="12" md="2">
                                    <datePicker
                                        :menu="dateDialog"
                                        dateLabel="To"
                                        :dateValue.sync="dateFilterItems[1]"
                                    ></datePicker>
                                </v-col>
                                <v-col cols="12" :md="showPickerTo > 0 ? 1 : 2">
                                    <v-btn @click="handleAddCriteria('AND')" :color="themeColor == '' ? 'primary' : themeColor" block dark>AND</v-btn>
                                </v-col>
                                <v-col cols="12" :md="showPickerTo > 0 ? 1 : 2">
                                    <v-btn @click="handleAddCriteria('OR')" :color="themeColor == '' ? 'primary' : themeColor" block dark>OR</v-btn>
                                </v-col>
                            </v-row>
                            <v-row dense>
                                <v-col cols="12" md="4">
                                    <v-autocomplete
                                        v-model="selectedSortBy"
                                        :items="selectedHeaders"
                                        @click:clear="selectedOrderBy = null"
                                        :color="themeColor == '' ? 'primary' : themeColor"
                                        item-text="text"
                                        item-value="value"
                                        label="Sort by"
                                        hide-details
                                        clearable
                                        multiple
                                        outlined
                                        dense
                                    ></v-autocomplete>
                                </v-col>
                                <v-col cols="12" xl="2" lg="3" md="3">
                                    <v-radio-group class="mt-0" v-model="selectedOrderBy" hide-details row>
                                        <v-radio
                                            v-for="(item, i) in orderBy" :key="i"
                                            :label="item.text"
                                            :value="item.value"
                                            :color="themeColor == '' ? 'primary' : themeColor"
                                        ></v-radio>
                                    </v-radio-group>
                                </v-col>
                                <v-col cols="12" xl="2" lg="2" md="2">
                                    <v-checkbox
                                        v-model="includeInActive"
                                        class="mt-0"
                                        :color="themeColor == '' ? 'primary' : themeColor"
                                        label="With separated"
                                    ></v-checkbox>
                                </v-col>
                            </v-row>
                        </v-form>
                        <v-row justify="center" dense>
                            <v-col id="step1" cols="12" xl="5" lg="5" md="5">
                                <v-card outlined>
                                    <v-container fluid>
                                        <v-toolbar flat>
                                            <v-toolbar-title class="text-md-caption text-lg-h6">Fields to Show</v-toolbar-title>
                                            <v-spacer></v-spacer>
                                            <v-text-field
                                                class="mt-7"
                                                v-model="searchFields"
                                                :color="themeColor == '' ? 'primary' : themeColor"
                                                append-icon="mdi-magnify"
                                                label="Search"
                                                outlined
                                                dense
                                            ></v-text-field>
                                        </v-toolbar>
                                        <v-list class="listFields" v-bind:class="[filterHeaders.length == 0 ? 'listImage' : '']" two-line dense>
                                            <v-list-item v-for="item in filterHeaders" :key="item.id">
                                                <v-list-item-content>
                                                    <v-card @click="item.isSelect = !item.isSelect" outlined>
                                                        <v-card-actions class="ma-0 pa-0">
                                                            <v-checkbox 
                                                                class="ml-3"
                                                                :color="themeColor == '' ? 'primary' : themeColor"
                                                                v-model="item.isSelect"
                                                                :label="item.text"
                                                                readonly
                                                            ></v-checkbox>
                                                        </v-card-actions>
                                                    </v-card>
                                                </v-list-item-content>
                                            </v-list-item>
                                        </v-list>   
                                    </v-container>
                                </v-card>
                            </v-col>
                            <v-col id="step2" cols="12" xl="1" lg="1" md="2">
                                <v-card class="fill-height text-center" outlined>
                                    <v-container class="fill-height" fluid>
                                        <v-row align="center" justify="center">
                                            <v-col v-for="(item, i) in queryButtonActions" :key="i">
                                                <v-tooltip left>
                                                    <template v-slot:activator="{ on, attrs }">
                                                        <v-btn 
                                                            @click="addItem(item.value)" 
                                                            :color="themeColor == '' ? 'primary' : themeColor" 
                                                            v-bind="attrs"
                                                            v-on="on"
                                                            dark
                                                        >
                                                            <v-icon large>{{item.icon}}</v-icon>
                                                        </v-btn>
                                                    </template>
                                                    <span>{{ item.tooltip }}</span>
                                                </v-tooltip>
                                            </v-col>
                                        </v-row>
                                    </v-container>
                                </v-card>
                            </v-col>
                            <v-col id="step3" cols="12" xl="5" lg="5" md="5">
                                <v-card outlined>
                                    <v-container fluid>
                                        <v-toolbar flat>
                                            <v-toolbar-title  class="text-md-caption text-lg-h6">Arrange Fields</v-toolbar-title>
                                        </v-toolbar>
                                        <v-list class="listFields" v-bind:class="[selectedHeaders.length == 0 ? 'listImage' : '']" two-line dense>
                                            <draggable v-model="selectedHeaders" v-bind="dragOptions" :move="onMove">
                                                <v-list-item v-for="(item, i) in selectedHeaders" :key="i">
                                                    <v-list-item-content>
                                                        <v-card class="dragItem" outlined>
                                                            <v-card-actions class="ma-0 pa-0">
                                                                <v-card-text>{{item.text}}</v-card-text>
                                                                <v-spacer></v-spacer>
                                                                <v-tooltip top>
                                                                    <template v-slot:activator="{ on, attrs}">
                                                                        <v-btn 
                                                                            class="mx-3" 
                                                                            v-on="on"
                                                                            v-bind="attrs"
                                                                            @click="removeItem(item)" 
                                                                            :color="themeColor == '' ? 'primary' : themeColor"
                                                                            icon
                                                                        >
                                                                            <v-icon>mdi-trash-can</v-icon>
                                                                        </v-btn>
                                                                    </template>
                                                                    <span>Remove</span>
                                                                </v-tooltip>
                                                            </v-card-actions>
                                                        </v-card>
                                                    </v-list-item-content>
                                                </v-list-item>
                                            </draggable>
                                        </v-list>   
                                    </v-container>
                                </v-card>
                            </v-col>
                        </v-row>
                    </v-card-text>
                    <v-divider class="mx-3"></v-divider>
                    <v-container fluid>
                        <v-row dense>
                            <v-col id="step5" cols="12" md="12">
                                <v-textarea
                                    v-model="queryCriteria"
                                    label="Criteria"
                                    :color="themeColor == '' ? 'primary' : themeColor"
                                    hide-details
                                    outlined
                                    dense
                                ></v-textarea>
                            </v-col>
                            <v-col id="step6" cols="12" md="12">
                                <v-text-field
                                    v-model="queryEmployeeNo"
                                    label="Employee No(s)"
                                    hint="Data should be separated by comma"
                                    :color="themeColor == '' ? 'primary' : themeColor"
                                    persistent-hint
                                    clearable
                                    outlined
                                    dense
                                ></v-text-field>
                            </v-col>
                        </v-row>
                    </v-container>
                    <v-card-actions>
                        <v-spacer></v-spacer>
                        <v-btn @click="clearVariables()" text>
                            <v-icon left>mdi-close</v-icon>Clear
                        </v-btn>
                        <v-btn id="step7" :color="themeColor == '' ? 'primary' : themeColor" @click="handleRunQuery()" dark>
                            <v-icon left>mdi-play</v-icon>Run Query
                        </v-btn>
                    </v-card-actions>
                </v-card>
                <querybuildertour />
            </v-container>
        </v-lazy>
        <v-dialog v-model="displayDialog" persistent>
            <v-card>
                <v-toolbar :color="themeColor == '' ? 'primary' : themeColor" flat dark>
                    <v-toolbar-title>Results</v-toolbar-title>
                    <v-spacer></v-spacer>
                    <v-btn @click="displayDialog = !displayDialog" icon><v-icon>mdi-close</v-icon></v-btn>
                </v-toolbar>
                <v-container fluid>
                    <v-row dense>
                        <v-col cols="12" md="3">
                            <v-text-field
                                v-model="searchVal"
                                :color="themeColor == '' ? 'primary' : themeColor"
                                label="Search"
                                append-icon="mdi-magnify"
                                hide-details
                                clearable
                                outlined
                                dense
                            ></v-text-field>
                        </v-col>
                    </v-row>
                </v-container>
                <v-divider></v-divider>
                <v-data-table
                    :headers="selectedHeaders"
                    :items="resultQuery"
                    :search="searchVal"
                    :page.sync="page"
                    :loading="loading"
                    :items-per-page="7"
                    @page-count="pageCount = $event"
                    loading-text="Loading Data. . .Please Wait"
                    hide-default-footer
                    dense
                >
                
                    <v-progress-linear v-show="loading" slot="progress" :color="themeColor == '' ? 'primary' : themeColor" indeterminate></v-progress-linear>
                </v-data-table>
                <v-pagination
                    v-model="page"
                    :length="pageCount"
                    :total-visible="10"
                    :color="themeColor == '' ? 'primary' : themeColor"
                ></v-pagination>
                <v-card-actions>
                    <v-card-text class="caption">Total Record(s): {{resultQuery.length}}</v-card-text>
                    <VueExcel :data="resultQuery" worksheet="Masterlist" name="MasterList.xls">
                        <v-btn class="mx-3" :color="themeColor == '' ? 'primary' : themeColor" dark>
                            <v-icon left>mdi-microsoft-excel</v-icon>Excel
                        </v-btn>
                    </VueExcel>
                    <v-btn @click="printPreview()" :color="themeColor == '' ? 'primary' : themeColor" dark>
                        <v-icon left>mdi-file-find</v-icon>Print Preview
                    </v-btn>
                </v-card-actions>
            </v-card>
        </v-dialog>
    </v-main>
</template>

<script>
// packages
import draggable from 'vuedraggable'
import VueExcel from 'vue-json-excel'
import datePicker from '@/components/datepicker'
import querybuildertour from '@/components/querybuildertour'

export default {
    data() {
        return {
            tab: null,
            valid: true,
            loading: false,
            dateDialog: false,
            isDragging: false,
            displayDialog: false,
            includeInActive: false,
            pageCount: 0,
            page: 1,              
            showPickerFrom: 0, 
            showPickerTo: 0,
            searchVal: '',
            searchFields: '',
            selectedTeam: '',
            queryCriteria: '',
            sqlWhereOuput: '',
            selectedSortBy: '',
            selectedGender: '',
            selectedOrderBy: '',
            queryEmployeeNo: '',
            selectedSection: '',
            selectedDepartment: '',
            searchBy: null,
            selectedFilter: null,
            selectedOperator: null,
            headers: [],
            resultQuery: [],
            operatorItems: [],
            selectedHeaders: [],
            genderItems: [
                {text: 'Male', value: 'M'},
                {text: 'Female', value: 'F'}
            ],
            orderBy: [
                {text: 'Ascending', value: 'ASC'},
                {text: 'Descending', value: 'DESC'}
            ],
            dateFilterItems: [
                this.moment().startOf('month').format('YYYY-MM-DD'),
                this.moment().endOf('month').format('YYYY-MM-DD')
            ],
            breadCrumbsItems: [ 
                {text: 'Main Data', disabled: false, href: '#'},
                {text: 'Query Builder', disabled: true, href: '#'}
            ],
            queryButtonActions: [
                {icon: 'mdi-menu-right', tooltip: 'Move fields', value: 'next'},
                {icon: 'mdi-skip-next', tooltip: 'Move all fields',value: 'next-all'},
                {icon: 'mdi-restore',tooltip: 'Reset', value: 'reset'},
                // {icon: 'mdi-skip-previous', value: 'previous-all'}
            ],
            tabHeaders: [
                {text: 'Lists', icon: 'mdi-format-list-bulleted', value: 'tab-1'},
                {text: 'Summary', icon: 'mdi-chart-box-outline', value: 'tab-2'}
            ],
            filterByItems: [
                {text: 'Employee Code', value: 'EmployeeCode'},
                {text: 'Last Name', value: 'LastName'},
                {text: 'First Name', value: 'FirstName'},
                {text: 'Middle Name', value: 'MiddleName'},
                {text: 'Department', value: 'DepartmentName'},
                {text: 'Section', value: 'SectionName'},
                {text: 'Team', value: 'TeamName'},
                {text: 'Gender', value: 'Gender'},
                {text: 'Present Address', value: 'PresentAddress'},
                {text: 'Permanent Address', value: 'PermanentAddress'},
                {text: 'Birthday', value: 'DateBirth'},
                {text: 'Hired Date', value: 'ContractHiredDate'},
                {text: 'Separation Date', value: 'SeparationDate'},
                {text: 'Transferred Date', value: 'TransferredDate'}
            ]
        }
    },
    created() {
        this.getTableFields()
    },
    computed: {
        filterHeaders() {
            return this.headers.filter(rec => {
                return rec.text.toLowerCase().includes(this.searchFields.toLowerCase() || '')
            })
        },
        dragOptions() {
            return {
                animation: 300,
                group: "fields",
                disabled: false,
                ghostClass: "ghost",
                scrollSensitivity: 200,
                forceFallback: true
            }
        },
    },
    methods: {
        addItem(category) {
            let arrIndex = 0
            let arrSelect = []
            if (category == 'next') {
                this.searchFields = ''
                arrSelect = this.headers.filter(rec => rec.isSelect)
                arrSelect.forEach(rec => {
                    rec.isSelect = false
                    this.selectedHeaders.push(rec)
                    arrIndex = this.headers.findIndex(item => item.id == rec.id)
                    this.headers.splice(arrIndex, 1)
                })
            } else if (category == 'next-all') {
                Object.assign(this.selectedHeaders, this.headers)
                this.headers = []
            } else {
                this.getTableFields()
                this.selectedHeaders = []
            }
        },
        removeItem(val) {
            let index = 0
            index = this.selectedHeaders.findIndex(rec => rec.id == val.id)
            this.selectedHeaders.splice(index, 1)
            this.headers.push(val)
        },
        onMove({ relatedContext, draggedContext }) {
            const relatedElement = relatedContext.element;
            const draggedElement = draggedContext.element;
            return (
                (!relatedElement || !relatedElement.fixed) && !draggedElement.fixed
            )
        },   
        handleAddCriteria(relation) {
            if(this.selectedHeaders.length != 0) {
                if(this.$refs.form.validate()) {
                    this.loading = true
                    let searchVal = this.searchBy
                    let filter = this.selectedFilter
                    let operator = this.selectedOperator.value
                    let operatorName = this.selectedOperator.text
                    let dateFrom = this.dateFilterItems[0]
                    let dateTo = this.dateFilterItems[1]

                    switch (operator) {
                        case '%':
                            this.sqlWhereOuput = `${this.filterSearchQuery()} ${relation} ${filter} ${operatorName} "${operator}${searchVal}${operator}"`
                            break;
                        case 'BETWEEN':
                            this.sqlWhereOuput = `${this.filterSearchQuery()} ${relation} ${filter} ${operator} "${dateFrom}" AND "${dateTo}"`
                            break;
                        default:
                            this.sqlWhereOuput = `${this.filterSearchQuery()} ${relation} ${filter} ${operator} "${searchVal == null ? dateFrom : searchVal}"`
                            break;
                    }
                    this.queryCriteria += ` ${this.sqlWhereOuput}`
                    this.showPickerFrom = 0
                    this.showPickerTo = 0
                    this.selectedFilter = ''
                    this.selectedOperator = ''
                    this.searchBy = null
                    this.$refs.form.resetValidation()
                }
            }
        },
        handleRunQuery() {   
            let queryEmplCode = ''
            let querySortBy = ''
            let queryFinalSQL = this.queryCriteria
            let intOption = this.includeInActive ? 1 : 0
            if (this.queryEmployeeNo) {
                queryEmplCode = `AND EmployeeCode IN (${this.queryEmployeeNo})` 
            }

            if (this.selectedSortBy && this.selectedOrderBy) {
                querySortBy = `ORDER BY ${this.selectedSortBy} ${this.selectedOrderBy}`
            }

            queryFinalSQL = `${this.queryCriteria} ${queryEmplCode} ${querySortBy}`
            // console.log(queryFinalSQL);
            let body = {
                procedureName: 'ProcQueryData',
                values: [
                    this.userInfo.CompanyCode,
                    this.getSelectedHeaders(),
                    queryFinalSQL,
                    this.selectedFilter == 'TransferredDate' ? 2 : intOption
                ]
            }
            // console.log(body);
            this.axios.post(`${this.api}/executeselect`, {data: JSON.stringify(body)}, { headers: this.axiosHeaders }).then(res => {
                this.loading = false
                if(Array.isArray(res.data)) {
                    this.resultQuery = res.data
                } else {
                    this.resultQuery = []
                }
            })
            this.displayDialog = true
        },
        getSelectedHeaders() {
            let data = ''
            this.selectedHeaders.forEach(rec => {
                data += `,${rec.value}`
            })
            return data.substring(1, data.length)
        },
        // Get Table Fields
        getTableFields() {
            // call procedure
            let body = {
                procedureName: 'ProcGetFields',
                values: []
            }
            this.axios.post(`${this.api}/executeselect`, {data: JSON.stringify(body)}, { headers: this.axiosHeaders }).then(res => {
                this.headers = []
                if(Array.isArray(res.data)) {
                    let fields = res.data
                    fields.forEach((rec, index) => {
                        this.headers.push({
                            id: index,
                            text: rec.FieldDesc,
                            value: rec.FieldUsed,
                            isSelect: false
                        })
                    })
                } else {
                    this.headers = []
                }
            })
        },
        filterSearchQuery() {
            let query = ''
            let department = this.userInfo.DepartmentName
            let section = this.userInfo.SectionName
            let team = this.userInfo.TeamName

            switch (this.userInfo.UserLevel) {
                case 1: // DH
                    query = ` AND lower(DepartmentName) = lower("${department}")`
                    break;
                case 2: // Section Head
                    query = ` AND lower(DepartmentName) = lower("${department}")
                                AND lower(SectionName) = lower("${section}")`
                    break;
                case 3: // Team Head
                    query = ` AND lower(DepartmentName) = lower("${department}")
                                AND lower(SectionName) = lower("${section}")
                                AND lower(TeamName) = lower("${team}")`
                    break;
                default: // QA Staff and Developer
                    query = ''
                    break;
            }
            return query
        },
        printPreview() {
            this.printreportpdf(this.selectedHeaders, this.resultQuery, null)
        },
        excelExport() {
            this.exportExcel(this.resultQuery, 'Master List')
        },
        clearVariables() {
            this.showPickerTo = 0
            this.showPickerFrom = 0
            this.selectedTeam = ''
            this.selectedSortBy = ''
            this.selectedSection = ''
            this.selectedOrderBy = ''
            this.queryEmployeeNo = ''
            this.selectedDepartment = ''
            this.searchBy = null
            this.queryCriteria = null
            this.sqlWhereOuput = null
            this.selectedFilter = null
            this.selectedOperator = null
            this.headers = []
            this.resultQuery = []
            this.selectedHeaders = []
            this.getTableFields()
            this.$refs.form.resetValidation()
        }
    },
    watch: {
        selectedFilter(val) {
            switch (val) {
                case 'DateBirth':
                case 'ContractHiredDate':
                case 'SeparationDate':
                case 'TransferredDate':
                    this.showPickerFrom = 1
                    this.operatorItems = [
                        {text: 'equals to', value: '='},
                        {text: 'greater than', value: '>'},
                        {text: 'less than', value: '<'},
                        {text: 'greater than or equals to', value: '>='},
                        {text: 'less than or equals to', value: '<='},
                        {text: 'not equals to', value: '<>'},
                        {text: 'between', value: 'BETWEEN'}
                    ]
                    break;
                default:
                    this.showPickerFrom = 0
                    this.operatorItems = [
                        {text: 'equals to', value: '='},
                        {text: 'not equals to', value: '<>'},
                        {text: 'like', value: '%'}
                    ]
                    break;
            }
        },
        selectedOperator(val) {
            if(val != undefined) {
                this.showPickerTo = val.value == 'BETWEEN'  ? 1 : 0
            } else {
                this.showPickerTo = 0
            }
        }
    },
    components: {
        draggable,
        VueExcel,
        datePicker,
        querybuildertour
    }
}
</script>

<style scoped> 
     .listFields {
          height: 380px;
          overflow-y: auto;
          overflow-x: hidden;
     }
     .listImage {
        background: url('../assets/box.png') no-repeat center center;
        background-size: 100px 100px;
        opacity: 0.3;
     }
     .dragItem {
         cursor: grab;
     }
     .dragItem:active {
         cursor: grabbing;
     }
</style>