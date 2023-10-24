const todoModel = require("../model/todoModel");

const createTOdo = async (req, res) => {
  const { userId, title, description } = req.body;
  const todo = new todoModel({
    userId,
    title,
    description,
  });
  try {
    await todo.save();
    res.status(201).json({ status: true, todo: todo });
  } catch (error) {
    res.status(409).json({ message: error.message });
  }
};

const getAllTodos = async (req, res) => {
  try {
    const todos = await todoModel.find();
    res.status(200).json(todos);
  } catch (error) {
    res.status(404).json({ message: error.message });
  }
};

module.exports = {
  createTOdo,
  getAllTodos,
};
