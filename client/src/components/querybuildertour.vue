<template>
    <v-tour name="startTour" :steps="steps" :options="tourOptions" :callbacks="tourCallBacks"></v-tour>
</template>

<script>
import scrollToElement from 'scroll-to-element'
export default {
    data() {
        return {
            tourCallBacks: {
                onPreviousStep: this.handleGetPrevStepClick,
                onNextStep: this.handleGetNextStepClick,
                onFinish: this.handleGetFinishStepClick
                // onSkip: this.handleGetSkipStepClick
            },
            tourOptions: {
                highlight: true,
                labels: {
                    buttonSkip: 'Skip',
                    buttonPrevious: 'Prev',
                    buttonNext: 'Next',
                    buttonStop: 'Done'
                }
            },
            steps: [
                {
                    target: '#step1',
                    header: {
                        title: 'Fields to show'
                    },
                    content: 'Select or Search columns that you want to show.'
                },
                {
                    target: '#step2',
                    content: 'click one of these buttons of actions.'
                },
                {
                    target: '#step3',
                    header: {
                        title: 'Arrange Fields'
                    },
                    content: '<strong>Drag</strong> one column and arrange it in your desire position. You can click <strong>delete</strong> button if you want to remove it.'
                },
                {
                    target: '#step4',
                    content: 'Set your conditions on how you want your data to be executed.'
                },
                {
                    target: '#step5',
                    content: 'All your conditions lies here. You can modify this section for you to customize your output.',
                    params: {
                        placement: 'top'
                    }
                },
                {
                    target: '#step6',
                    header: {
                        title: 'Optional'
                    },
                    content: 'List all the employees you want to gather using employees\' ID.'
                },
                {
                    target: '#step7',
                    content: 'If your done setting up, you can now execute your query.',
                    params: {
                        placement: 'left'
                    }
                }
            ]
        }
    },
    mounted() {
        if (this.isEnableTour) {
            this.$tours['startTour'].start()
        }
    },
    methods: {
        handleGetPrevStepClick(data) {
            let element = this.steps[data - 1].target
            this.functionGotoElement(element)
        },
        handleGetNextStepClick(data) {
            let element = this.steps[data + 1].target
            this.functionGotoElement(element)
        },
        handleGetFinishStepClick() {
            this.functionGotoElement('#top')
            this.$store.commit('CHANGE_TOUR_VALUE', false)
        },
        handleGetSkipStepClick() {
            this.functionGotoElement('#top')
            this.$store.commit('CHANGE_TOUR_VALUE', false)
        },
        functionGotoElement(id) {
            scrollToElement(id, {
                align: 'middle',
                offset: 20,
                ease: 'out-cube',
                duration: 1500,
            })
        },
    }
}
</script>

<style>
    .v-tour__target--highlighted {
        padding: 5px 5px 5px 5px;
        box-shadow: 0 0 0 99999px rgba(0,0,0,.4);
    }	
</style>