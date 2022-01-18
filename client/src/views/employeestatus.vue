<template>
    <v-main>
        <v-breadcrumbs :items="breadCrumbsItems" divider="/"></v-breadcrumbs>
        <v-container fluid>
            <v-card>
                <v-toolbar :color="themeColor == '' ? 'primary' : themeColor" dark tile>
                    <v-toolbar-title>Employee Status</v-toolbar-title>
                </v-toolbar>
                <v-container fluid>
                    <v-row dense>
                        <v-col v-if="userInfo.UserLevel >= 8 || userInfo.UserLevel == 5" cols="12" xl="2" lg="3" md="3">
                            <v-autocomplete
                                v-model="selectedDepartment"
                                :items="filterDepartments"
                                label="Departments"
                                hide-details
                                clearable
                                outlined
                                dense
                            ></v-autocomplete>
                        </v-col>
                        <v-col cols="12" xl="3" lg="3" md="3">
                            <v-select
                                v-model="selectedSection"
                                :items="filterSections"
                                label="Sections"
                                hide-details
                                clearable
                                outlined
                                dense
                            ></v-select>
                        </v-col>
                        <v-col cols="12" xl="3" lg="3" md="3">
                            <v-select
                                v-model="selectedTeam"
                                :items="filterTeams"
                                label="Teams"
                                hide-details
                                clearable
                                outlined
                                dense
                            ></v-select>
                        </v-col>
                        <v-col cols="12" xl="2" lg="3" md="3">
                            <v-select
                                v-model="selectedStatus"
                                :items="filterEmployeeStatus"
                                :color="themeColor == '' ? 'primary' : themeColor"
                                :readonly="userInfo.UserLevel != 9"
                                item-text="text"
                                item-value="value"
                                label="Status"
                                hide-details
                                outlined
                                dense
                            ></v-select>
                        </v-col>
                        <v-col cols="12" xl="2" lg="3" md="3">
                            <v-text-field
                                v-model="searchData"
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
                    :headers="headers"
                    :items="filterEmployees"
                    :search="searchData"
                    :page.sync="page"
                    :items-per-page="$vuetify.breakpoint.mdAndDown ? 7 : 8"
                    @page-count="pageCount = $event"
                    hide-default-header
                    hide-default-footer
                >
                    <template v-slot:header="{ props }">
                        <tr>
                            <th v-for="(header, i) in props.headers" :key="i" :rowspan="header.children ? 1 : 2" :colspan="header.children ? header.children.length : 1">
                                <v-container>
                                    {{header.text}}
                                </v-container>
                            </th>
                        </tr>
                        <tr>
                            <th v-for="(subHeader, i) in handleGetSubHeaders(props.headers)" :key="i">
                                <v-container>{{subHeader.text}}</v-container>
                            </th>
                        </tr>
                    </template>
                    <template v-slot:item="{ item }">
                        <tr>
                            <td>{{item.EmployeeCode}}</td>
                            <td>{{item.EmployeeName}}</td>
                            <td>{{item.DepartmentName}}</td>
                            <td>{{item.SectionName}}</td>
                            <td>{{item.TeamName}}</td>
                            <td :class="`text-center ${handleGetCurrentSchedule(item.SecondMonth)}`">{{ moment(item.SecondMonth).format('MMM DD, YYYY') }}</td>
                            <td :class="`text-center ${handleGetCurrentSchedule(item.FifthMonth)}`">{{ moment(item.FifthMonth).format('MMM DD, YYYY') }}</td>
                            <td :class="`text-center ${handleGetCurrentSchedule(item.SixthMonth)}`">{{ moment(item.SixthMonth).format('MMM DD, YYYY') }}</td>
                        </tr>
                    </template>
                </v-data-table>
                <v-pagination
                    v-model="page"
                    class="mt-3"
                    :length="pageCount"
                    :total-visible="10"
                    :color="themeColor == '' ? 'primary' : themeColor"
                ></v-pagination>
                <v-card-actions>
                    <v-card-text class="font-weight-bold">Total Record(s): {{ filterEmployees.length }}</v-card-text>
                    <v-spacer></v-spacer>
                    <v-card-text>
                        <div class="font-weight-bold float-right">Legend: 
                            <v-chip color="red darken-1" dark>For Evaluation</v-chip>
                        </div>
                    </v-card-text>
                </v-card-actions>
            </v-card>
            <v-overlay :value="loading" absolute>
                <v-progress-circular
                    :size="100"
                    :width="5"
                    indeterminate
                ></v-progress-circular>
            </v-overlay>
        </v-container>
    </v-main>
</template>

<script>
export default {
    data() {
        return {
            selectedDepartment: null,
            selectedSection: null,
            selectedTeam: null,
            searchData: null,
            loading: true,
            withSeparated: false,
            selectedStatus: 'C',
            pageCount: 0,
            page: 1,
            employees: [],
            headers: [
                {text: 'Code', value: 'EmployeeCode'},
                {text: 'Name', value: 'EmployeeName'},
                {text: 'Department', value: 'DepartmentName'},
                {text: 'Section', value: 'SectionName'},
                {text: 'Team', value: 'TeamName'},
                {
                    text: 'Evaluation Date',
                    children: [
                        {text: '2nd Month', value: 'SecondMonth'},
                        {text: '5th Month', value: 'FifthMonth'},
                        {text: '6th Month', value: 'SixthMonth'},
                    ]
                }
            ],
            breadCrumbsItems: [
                {text: 'Main Data', disabled: false, href: '#'},
                {text: 'Employee Status', disabled: true, href: '#'}
            ]
        }
    },
    created() {
        this.handleLoadEmployees()
    },
    computed: {
        filterEmployees() {
            return this.employees.filter(rec => {
                return rec.DepartmentName.includes(this.selectedDepartment || '') &&
                       rec.SectionName.includes(this.selectedSection || '') &&
                       rec.TeamName.includes(this.selectedTeam || '') &&
                       rec.ContractStatus.includes(this.selectedStatus)
            })
        },
        filterEmployeeStatus() {
            return this.employees.map(rec => {
                return {text: rec.ContractStatusDesc, value: rec.ContractStatus}
            })
        },
        filterDepartments() {
            return this.filterEmployees.map(rec => {
                return rec.DepartmentName
            }).sort()
        },
        filterSections() {
            return this.filterEmployees.map(rec => {
                return rec.SectionName
            }).sort()
        },
        filterTeams() {
            return this.filterEmployees.map(rec => {
                return rec.TeamName
            }).sort()
        }
    },
    methods: {
        handleLoadEmployees() {
            this.loading = true
            let body = {
                procedureName: 'ProcEmployeeStatus',
                values: [ this.withSeparated ? 1 : 0 ]
            }
            // console.log(body);
            this.axios.post(`${this.api}/executeselect`, {data: JSON.stringify(body)}, { headers: this.axiosHeaders }).then(res => {
                this.handleFilterUserRecords(res.data)
                this.loading = false
            })
        },
        handleFilterUserRecords(data) {
            let userData = this.userInfo
            switch (userData.UserLevel) {
                case 1:
                case 4:
                    this.employees = data.filter(rec => rec.ShortName.includes(userData.ShortName) && rec.DepartmentName == userData.DepartmentName)
                    break;
                case 2:
                    this.employees = data.filter(rec => rec.ShortName.includes(userData.ShortName) && 
                                    rec.DepartmentName.includes(userData.DepartmentName) && 
                                    rec.SectionName.includes(userData.SectionName))
                    break;
                case 3:
                    this.employees = data.filter(rec => rec.ShortName.includes(userData.ShortName) && 
                                    rec.DepartmentName.includes(userData.DepartmentName) && rec.SectionName.includes(userData.SectionName) && 
                                    rec.TeamName.includes(userData.TeamName))
                    break;
                case 5:
                    this.employees = data.filter(rec => rec.ShortName.includes(userData.Comp_Name) && userData.AssignDepartments.includes(rec.DepartmentName))
                    break;
                default:
                    this.employees = data.filter(rec => rec.ShortName.includes(userData.ShortName))
                    break;
            }
        },
        handleGetSubHeaders(data) {
            let result = []
            data.filter(rec => rec.children).forEach(item => {
                result = result.concat(item.children)
            })
            return result
        },
        handleGetCurrentSchedule(date) {
            let curDate = this.moment().add(1, 'day').format('YYYY-MM-DD')
            if (date == curDate) {
                return 'evaluation'
            } else if (date < curDate) {
                return 'done-eval'
            } else {
                return
            }
        }
    }
}
</script>

<style scoped>
    th {
      border-color: rgba(0, 0, 0, 0.12);
      border-style: solid;
      border-left-width: 0px;
      border-right-width: 1px;
      border-top-width: 0px;
      border-bottom-width: 1px;
    }

    td {
      padding: 12px 8px;
      border-color: rgba(0, 0, 0, 0.12);
      border-style: solid;
      border-left-width: 0px;
      border-right-width: 1px;
      border-top-width: 0px;
      border-bottom-width: 1px;
    }

    .evaluation {
        color: #ffffff;
        background-color: #E53935;
    }

    .done-eval {
        color: #BDBDBD;
    }
</style>