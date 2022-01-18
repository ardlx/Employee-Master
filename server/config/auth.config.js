const dotenv = require('dotenv')
dotenv.config()

module.exports = (req, res, next) => {
    let appKey = req.header(process.env.KEY_NAME)
    if(appKey == process.env.KEY_VALUE) {
        next()
    } else {
         res.send({
              message: "Forbidden"
         })
    }
}