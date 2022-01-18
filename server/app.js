const express = require('express')
const cors = require('cors')
const bodyparser = require('body-parser')
const dotenv = require('dotenv')
const helmet = require('helmet')
const query = require('./controller/query')
const pes = require('./controller/pes.query')
const auth = require('./config/auth.config')

dotenv.config()

const app = express()
const port = process.env.PORT || 8700

app.use(cors())
app.use(bodyparser.urlencoded({limit: '50mb', extended: true }))
app.use(bodyparser.json({limit: '50mb'}))
app.use(helmet())

const server = app.listen(port, () => {
        console.log(`Server running at ${port}`)
    })
    
const socketio = require('socket.io')(server, {
    cors: {
        origin: '*',
        // [
        //     process.env.URL,
        //     process.env.GRP_URL,
        //     process.env.PES_URL,
        //     process.env.PRESENT_EMPLOYEE_URL,
        //     process.env.LOGTIME_URL,
        //     process.env.GRP_LOCAL_URL,
        //     process.env.PES_LOCAL_URL,
        //     process.env.PRESENT_EMPLOYEE_LOCAL_URL,
        //     process.env.LOGTIME_LOCAL_URL,
        //     process.env.HTI_WEBSERVER,
        //     process.env.DORMITORY_LOCAL_URL
        // ], 
        methods: ["GET", "POST"],
        allowedHeaders: [
            "master-api"
        ],
        credentials: true
    }
})

socketio.on('connection', (socket) => {

    //User Logged In
    socket.on('loggedIn', (data) => {
        socketio.emit('loggedIn', data)
    })

    //Notifications
    socket.on('newNotifications', (data) => {
        socketio.emit('showNotifications', {
            socket: data.socket,
            title: data.title,
            message: data.message
        })
    })
})

app.use('/api', auth, query)
// app.use('/api', query)
app.use('/pes', pes)

app.get('/appversion', (req, res) => {
    res.send(JSON.stringify(require('./package.json').version))
})