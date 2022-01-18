<script>
import { Bar } from 'vue-chartjs'

export default {
     extends: Bar,
     props: ['imageChartBase64', 'chartRecord'],
     data () {
          return {
               chartData: {},
               options: {
                    scales: {
                         yAxes: [{
                         ticks: {
                              beginAtZero: true
                         },
                         gridLines: {
                              display: true
                         }
                         }],
                         xAxes: [ {
                              gridLines: {
                                   display: false
                              }
                         }]
                    },
                    legend: {
                         display: true
                    },
                    responsive: true,
                    maintainAspectRatio: false,
                    animation: {
                         onComplete: function(animation) {
                              this.getImageBase(animation.chartInstance.toBase64Image())
                         }.bind(this)
                    }
               },
               summaryRecords: [],
               summaryLabel: [],
               summaryData: [],
          }
     },
     created() {
          this.loadStatusSection()
     },
     methods: {
          loadStatusSection() {
               let body = {
                    procedureName: 'ProcStatusSectionSummary',
                    values: this.parameterRights()
               }
               this.axios.post(`${this.api}/executeselect`, { data: JSON.stringify(body) }, { headers: this.axiosHeaders }).then(res => {
                    this.summaryRecords = res.data
                    this.summaryLabel = Object.keys(this.summaryRecords[1])
                    this.chartData = {
                         labels: this.summaryLabel.slice(1),
                         datasets: [
                              {
                                   label: 'Casual',
                                   data: Object.values(this.summaryRecords[0]).slice(1),
                                   fill: false,
                                   borderColor: '#9e9fa1',
                                   backgroundColor: '#9e9fa1',
                                   borderWidth: 1
                              },
                              {
                                   label: 'Regular',
                                   data: Object.values(this.summaryRecords[1]).slice(1),
                                   fill: false,
                                   borderColor: '#689EED',
                                   backgroundColor: '#689EED',
                                   borderWidth: 1
                              }
                         ]
                    }
                    // Convert chart to image base 64 for report
                    this.renderChart(this.chartData, this.options)
               })
          },
          parameterRights() {
               let valueParams = []
               let level = this.userInfo.UserLevel
               switch(level) {
                    case 5:
                         valueParams = [
                              this.userInfo.Comp_Name,
                              this.userInfo.LocalDepartments
                         ]
                         break;
                    default:
                         valueParams = [
                              this.userInfo.ShortName,
                              this.userInfo.DepartmentName
                         ]
                         break;
               }
               return valueParams
          },
          getImageBase(val) {
               this.$emit('update:imageChartBase64', val)
               this.$emit('update:chartRecord', this.summaryRecords)
          }
     }
  }
</script>