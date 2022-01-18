const dotenv = require('dotenv')
const mssql = require('mssql')

dotenv.config()

const connect = function() {
    const conn = new mssql.ConnectionPool({
        user: process.env.USER,
        password: process.env.PASS,
        server: process.env.SERVER,
        database: process.env.PES_DATABASE,
        options: {
            encrypt: false,
            enableArithAbort: true
        },
    })
    return conn
}

module.exports = connect