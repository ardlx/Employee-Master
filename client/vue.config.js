module.exports = {
  "transpileDependencies": [
    "vuetify"
  ],
  devServer: {
    host: '0.0.0.0',
    port: '1000', //name of port
    public: '0.0.0.0:1000',
    disableHostCheck: true,
    noInfo: true
  },
  publicPath: process.env.NODE_ENV ==='production' ? '/employeemaster/' : '/'
} 