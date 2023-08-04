'use strict'

const express = require('express')
const morgan = require('morgan')
const axios = require('axios')

const app = express()
const bodyParser = require('body-parser')
const port = process.env.NODE_PORT || 8180

const OPA_URL = 'http://localhost:8181/v1/data/authz'

function indexHandler(req, res) {
  console.log(req)
  axios.post(OPA_URL, 
    { 
      input: {
        method: req.headers['x-forwarded-method'],
        token: (req.headers['opa-authorization'] || 'eyJ0eXAiOiJKV1QiLCJhbGciOiJub25lIn0.e30.').replace(/bearer\s+/i, ''),
        path: req.headers['x-forwarded-uri']
      } 
    },
    { headers: { 'Content-Type': 'application/json' } })
  .then(function (resp) {
    if ((resp.status === 200) && (resp.data.result.allow === true)) {
      res.status(200).send('')
    }
    else if ((resp.status === 200) && (resp.data.result.blocked === false)) {
      res.status(200).send('')
    }
    else {
      res.status(403).send('You are not authorized to perform this action.')
    }
  })
  .catch(function (err) {
    console.log(err)
    res.status(403).json({ error: `You are not authorized to perform this action. ${err.message}`})
  })
}

app.use(bodyParser.json())
app.use(morgan('combined'))

// We only get GET request from Traefik authForward middleware
app.get('/', indexHandler)
app.listen(port, () => console.log(`Middleware Service listening on port ${port}!`))


