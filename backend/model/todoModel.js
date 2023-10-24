const mongoose = require("mongoose");
const userModel = require("./userModel");

const todoSchema = new mongoose.Schema({
  userId: {
    type: mongoose.Schema.Types.ObjectId,
    res: userModel.modelName,
  },
  title: {
    type: String,
    required: true,
  },
  description: {
    type: String,
    required: true,
  },
});

const todoModel = mongoose.model("todo", todoSchema);

module.exports = todoModel;
