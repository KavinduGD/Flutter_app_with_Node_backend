const express = require("express");
const dotenv = require("dotenv");
const morgan = require("morgan");
const bodyParser = require("body-parser");
const connectDB = require("./config/db.js");
const userRoutes = require("./routes/userRoute.js");

dotenv.config();

const app = express();

app.use(bodyParser.json());
app.use(morgan("dev"));

app.use("/api/user", userRoutes);

connectDB();
app.listen(4000, () => {
  console.log("connected  to the server in port 4000");
});
