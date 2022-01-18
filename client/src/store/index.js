import Vue from 'vue'
import Vuex from 'vuex'
import createPersistedState from 'vuex-persistedstate'

Vue.use(Vuex)

export default new Vuex.Store({
  state: {
    userInfo: {},
    isLoggedIn: false,
    isEmpEdit: false,
    darkMode: false,
    isEnableTour: true,
    isConnect: true,
    profileBackground: null,
    appVersion: null,
    themeColor: '#1976d2'
  },
  plugins: [
    createPersistedState() 
  ],
  mutations: {
    CHANGE_USER_INFO: (state, data) => {
      state.userInfo = data
    },
    CHANGE_USER_LOGGING: (state, data) => {
      state.isLoggedIn = data
    },
    CHANGE_THEME: (state, data) => {
      state.darkMode = data
    },
    CHANGE_EMP_EDIT: (state, data) => {
      state.isEmpEdit = data
    },
    CHANGE_CONNECTION: (state, data) => {
      state.isConnect = data
    },
    CHANGE_THEMECOLOR: (state, data) => {
      state.themeColor = data
    },
    CHANGE_PROFILE_BACKGROUND: (state, data) => {
      state.profileBackground = data
    },
    CHANGE_APP_VERSION: (state, data) => {
      state.appVersion = data
    },
    CHANGE_TOUR_VALUE: (state, data) => {
      state.isEnableTour = data
    }
  },
  actions: {

  },
  modules: {

  }
})
