const express = require("express");
const { createTOdo, getAllTodos } = require("../controller/todoController");

const router = express.Router();

router.post("/", createTOdo);
router.get("/", getAllTodos);

module.exports = router;
