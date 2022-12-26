const express = require('express');

const app = express();
app.use(express.json());

app.get('/api/webhooks', (req, res) => {
  console.log({ req })
  res.send({
    query: req.query,
    body: req.body,
  });
});

module.exports = app
