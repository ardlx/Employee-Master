<template>
     <v-menu
          ref="menu"
          v-model="menuDialog"
          :close-on-content-click="false"
          :return-value.sync="date"
          transition="scale-transition"
          offset-y
          min-width="290px"
     >
          <template v-slot:activator="{ on, attrs }">
               <v-text-field
                    v-model="date"
                    :label="label"
                    :filled="isEmpEdit == true"
                    :color="themeColor == '' ? 'primary' : themeColor"
                    @click:append="menuDialog = true"
                    append-icon="mdi-calendar"
                    v-bind="attrs"
                    v-on="on"
                    hide-details
                    clearable
                    readonly
                    outlined
                    dense
               ></v-text-field>
          </template>
          <v-date-picker
               v-model="date"
               no-title
               scrollable
               :events="events"
               event-color="#ED6351"
               :color="themeColor == '' ? 'primary' : themeColor"
               @change="$refs.menu.save(date)"
          >
          </v-date-picker>
     </v-menu>
</template>

<script>
export default {
     props: [
          'menu',
          'dateValue',
          'dateLabel'
     ],
     data() {
          return {
               events: [],
               menuDialog: false,
               date: this.dateValue,
               label: this.dateLabel
          }
     },
     created() { 
          this.loadEvents()
     },
     methods: {
          loadEvents() {
               let data = {
                    server: this.userInfo.UserLevel == 5 ? `HRIS${this.userInfo.Comp_Name.toLowerCase()}` : `HRIS${this.userInfo.ShortName.toLowerCase()}`
               }
               this.axios.post(`${this.asd_sql}/timeholidays.php`, data).then(res => {
                    res.data.forEach(rec => {
                         this.events.push(this.moment(rec.HOLDATE).format('YYYY-MM-DD'))
                    })
               })
          }
     },
     watch: {
          menu() {
               this.menuDialog = true
          },
          dateValue(val) {
               this.date = val
          },
          date(val) {
               this.$emit('update:dateValue', val)
               this.menuDialog = false
          }
     }
}
</script>