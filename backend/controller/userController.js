const UserService = require("../service/userService");

exports.register = async (req, res, next) => {
  try {
    const { email, password } = req.body;
    const user = await UserService.registerUser(email, password);
    res.status(200).json({ user });
  } catch (err) {
    next(err);
  }
};
