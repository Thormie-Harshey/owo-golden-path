const app = require('./app');

const port = process.env.PORT || 3000;

app.listen(port, () => console.log(`__SERVICE_NAME__ listening on port ${port}`));
