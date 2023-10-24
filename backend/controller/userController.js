const UserService = require("../service/userService");

exports.register = async (req, res, next) => {
  try {
    const { email, password } = req.body;
    const user = await UserService.registerUser(email, password);
    res.status(200).json({ status: true, user });
  } catch (err) {
    throw err;
  }
};

exports.login = async (req, res, next) => {
  try {
    const { email, password } = req.body;

    const user = await UserService.checkUser(email);
    console.log(user);
    if (!user) {
      throw new Error("User dont exist");
    }
    const isMatch = await user.comparePassword(password);
    console.log("isMatch", isMatch);
    if (isMatch === false) {
      throw new Error("Wrong password");
    }

    let tokenData = { _id: user._id, email: user.email };

    const token = await UserService.generateToken(
      tokenData,
      "KavinduKey",
      "1h"
    );

    res.status(200).json({ status: true, token });
  } catch (err) {
    res.send({ status: false, message: err.message });
  }
};
