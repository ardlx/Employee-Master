<template>
    <v-main>
        <v-breadcrumbs :items="breadCrumbsItems" divider="/"></v-breadcrumbs>
        <v-lazy transition="scroll-y-transition" :options="{ threshold: 0.8 }">
            <v-container fluid>
                <v-card tile>
                    <transition name="fade" mode="in-out">
                        <v-img height="12.5rem" :src="profileBackground == null ? require('../assets/16251.jpg') : profileBackground"></v-img>
                    </transition>
                    <v-row>
                        <v-col cols="12" md="4">
                            <v-container fluid>
                                <v-avatar :color="themeColor == '' ? 'primary' : themeColor"  size="150" style="position:absolute; top: 127px">
                                    <v-avatar size="140">
                                         <img 
                                            :src="employeeDetails.EmployeeName ? `${photo}/${employeeDetails.EmployeeCode}.jpg` : `${this.photo}/NoPic.jpg`" 
                                            :onerror="`this.src = '${this.photo}/NoPic.jpg'`" />
                                    </v-avatar>
                                </v-avatar>
                            </v-container>
                        </v-col>
                    </v-row>
                    <v-list-item class="mt-12">
                        <v-list-item-content>
                            <v-list-item-title class="headline">
                                {{`${employeeDetails.EmployeeName} (${employeeDetails.EmployeeCode})`}}
                            </v-list-item-title>
                            <v-list-item-subtitle>{{employeeDetails.DesignationName}}</v-list-item-subtitle>
                            <v-list-item-subtitle>{{employeeDetails.WorkEmailAddress ? employeeDetails.WorkEmailAddress : 'None'}}</v-list-item-subtitle>
                        </v-list-item-content>
                    </v-list-item>
                    <v-divider class="mx-3"></v-divider>
                    <v-subheader class="caption">Employee Information:</v-subheader>
                    <v-row>
                        <v-col class="mt-n5" cols="12" md="6">
                            <v-card-text>
                                <v-subheader>
                                    <div class="font-weight-bold">Employee ID:</div>
                                    <v-spacer></v-spacer>
                                    {{employeeDetails.EmployeeCode}}
                                </v-subheader>
                                <v-divider class="mx-3"></v-divider>
                                <v-subheader>
                                    <div class="font-weight-bold">Employee Name:</div>
                                    <v-spacer></v-spacer>
                                    {{employeeDetails.EmployeeName}}
                                </v-subheader>
                                <v-divider class="mx-3"></v-divider>
                                <v-subheader>
                                    <div class="font-weight-bold">Department:</div>
                                    <v-spacer></v-spacer>
                                    {{employeeDetails.DepartmentName}}
                                </v-subheader>
                                <v-divider class="mx-3"></v-divider>
                                <v-subheader>
                                    <div class="font-weight-bold">Section:</div>
                                    <v-spacer></v-spacer>
                                    {{employeeDetails.SectionName}}
                                </v-subheader>
                                <v-divider class="mx-3"></v-divider>
                                <v-subheader>
                                    <div class="font-weight-bold">Team:</div>
                                    <v-spacer></v-spacer>
                                    {{employeeDetails.TeamName}}
                                </v-subheader>
                                <v-divider class="mx-3"></v-divider>
                            </v-card-text>
                        </v-col>
                        <v-col class="mt-n5" cols="12" md="6">
                            <v-card-text>
                                <v-subheader>
                                    <div class="font-weight-bold">Position:</div>
                                    <v-spacer></v-spacer>
                                    {{employeeDetails.DesignationName}}
                                </v-subheader>
                                <v-divider class="mx-3"></v-divider>
                                <v-subheader>
                                    <div class="font-weight-bold">Designation:</div>
                                    <v-spacer></v-spacer>
                                    {{employeeDetails.PositionName}}
                                </v-subheader>
                                <v-divider class="mx-3"></v-divider>
                                <v-subheader>
                                    <div class="font-weight-bold">Date Hired:</div>
                                    <v-spacer></v-spacer>
                                    {{moment.utc(employeeDetails.DateHired).format('MMM DD, YYYY')}}
                                </v-subheader>
                                <v-divider class="mx-3"></v-divider>
                                <v-subheader>
                                    <div class="font-weight-bold">Status:</div>
                                    <v-spacer></v-spacer>
                                    {{employeeDetails.EmployeeStatus}}
                                </v-subheader>
                                <v-divider class="mx-3"></v-divider>
                                <v-subheader>
                                    <div class="font-weight-bold">Date Separated:</div>
                                    <v-spacer></v-spacer>
                                    {{employeeDetails.SeparationDate ? moment.utc(employeeDetails.SeparationDate).format('MMM DD, YYYY') : ''}}
                                </v-subheader>
                                <v-divider class="mx-3"></v-divider>
                            </v-card-text>
                        </v-col>
                    </v-row>
                    <v-card-actions>
                        <v-spacer></v-spacer>
                        <v-tooltip v-for="(item, i) in navButtons" :key="i" bottom>
                            <template v-slot:activator="{ on, attrs }">
                                <v-btn 
                                    class="mx-3" 
                                    @click="navRecords(currentEmployee, item.value)" 
                                    :color="themeColor == '' ? 'primary' : themeColor" 
                                    v-on="on"
                                    v-bind="attrs"
                                    :disabled="item.disabled"
                                    :dark="!item.disabled"
                                    small
                                    fab
                                >
                                    <v-icon>{{ item.icon }}</v-icon>
                                </v-btn>
                            </template>
                            <span>{{ item.text }}</span>
                        </v-tooltip>
                    </v-card-actions>
                </v-card>
            </v-container>
        </v-lazy>
    </v-main>
</template>

<script>

export default {
    data() {
        return {
            tab: null,
            imgSource: null,
            employeeDetails: {},
            information: [],
            navButtons: [
                {text: 'Prev', icon: 'mdi-chevron-left', value: 1, disabled: true},
                {text: 'Next', icon: 'mdi-chevron-right', value: 0, disabled: false},
            ],
            breadCrumbsItems: [
                {text: 'Main Data', disabled: false, href: '#'},
                {text: 'Employees', disabled: false, href: '#'},
                {text: 'Details', disabled: true, href: '#'}
            ],
            
        }
    },
    created() {
        if(!this.$route.params.id) this.$router.push('/dashboard')
        this.setConfiguration()
    },
    methods: {
        setConfiguration() {
            this.currentEmployee = this.$route.params.id
            this.information = this.$route.params.records
            this.employeeDetails = this.filterCurrentData(this.currentEmployee)
            this.imgSource = `${this.photo}/${this.currentEmployee}.jpg`

            let index = this.information.findIndex(item => item.EmployeeCode == this.currentEmployee)
            this.disabledNavigations(index)
        },
        navRecords(id, option) {
            let index = this.information.findIndex(item => item.EmployeeCode == id)
            let itemIndex = option > 0 ? index - 1 : index + 1
            this.currentEmployee = this.information[itemIndex].EmployeeCode
            this.employeeDetails = this.filterCurrentData(this.currentEmployee)
            this.disabledNavigations(itemIndex)
        },
        disabledNavigations(index) {
            if(index == 0) {
                this.navButtons[0].disabled = true
                this.navButtons[1].disabled = false
            } else if (index + 1 == this.information.length) {
                this.navButtons[0].disabled = false
                this.navButtons[1].disabled = true
            } else {
                this.navButtons[0].disabled = false
                this.navButtons[1].disabled = false
            }
        },
        filterCurrentData(code) {
            return this.information.find(rec => {
                return rec.EmployeeCode.includes(code)
            })
        },
    }
}
</script>