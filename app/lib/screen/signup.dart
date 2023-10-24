import 'dart:convert';
import 'package:app/screen/dashboard.dart';
import 'package:app/widget/logo.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import "package:http/http.dart" as http;

class Signup extends StatefulWidget {
  const Signup({Key? key}) : super(key: key);

  @override
  _SignupState createState() => _SignupState();
}

class _SignupState extends State<Signup> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isNotValidate = false;
  late SharedPreferences prefs;

  @override
  void initState() {
    super.initState();
    initSharedPref();
  }

  void initSharedPref() async {
    prefs = await SharedPreferences.getInstance();
  }

  void loginUser() async {
    if (_emailController.text.isNotEmpty &&
        _passwordController.text.isNotEmpty) {
      var user = {
        "email": _emailController.text,
        "password": _passwordController.text
      };

      var response = await http.post(
        Uri.parse("http://192.168.1.2:4000/api/user/login"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(user),
      );

      var decodedResponse = jsonDecode(response.body);

      //print("body is this man2" + decodedResponse["token"].toString());

      if (decodedResponse["status"]) {
        final token = decodedResponse["token"];
        print(token);
        prefs.setString("token", token);

        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => Dashboard(token: token),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              "Wrong Password",
              style: GoogleFonts.roboto(
                fontSize: 18,
                color: Colors.white,
              ),
            ),
            backgroundColor: Colors.red,
          ),
        );
      }
    } else {
      setState(() {
        _isNotValidate = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
              colors: [
                Color.fromARGB(255, 243, 59, 249),
                Color.fromARGB(255, 216, 124, 219),
              ],
              begin: FractionalOffset.topLeft,
              end: FractionalOffset.bottomCenter,
              stops: [0.0, 0.8],
              tileMode: TileMode.mirror),
        ),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Logo(),
                const SizedBox(
                  height: 50,
                ),
                Text(
                  "Log In to get started",
                  style: GoogleFonts.roboto(
                    fontSize: 20,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(
                  height: 15,
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                  ),
                  child: Column(
                    children: [
                      TextField(
                        controller: _emailController,
                        keyboardType: TextInputType.text,
                        decoration: InputDecoration(
                          hintText: "Email",
                          filled: true,
                          fillColor: Colors.white,
                          errorStyle: const TextStyle(
                            color: Colors.white,
                          ),
                          prefixIcon: Icon(
                            Icons.email,
                            color: Colors.grey[500],
                          ),
                          errorText:
                              _isNotValidate ? "Enter Proper Info" : null,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(
                              20,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      TextField(
                        controller: _passwordController,
                        keyboardType: TextInputType.text,
                        decoration: InputDecoration(
                          prefixIcon: Icon(
                            Icons.lock,
                            color: Colors.grey[500],
                          ),
                          filled: true,
                          fillColor: Colors.white,
                          errorStyle: const TextStyle(color: Colors.white),
                          errorText:
                              _isNotValidate ? "Enter Proper Info" : null,
                          hintText: "Password",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(
                              20,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                ElevatedButton(
                  onPressed: () {
                    loginUser();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 121, 4, 167),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 29,
                      vertical: 12,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(
                        30,
                      ),
                    ),
                  ),
                  child: Text(
                    "LogIn",
                    style: GoogleFonts.poppins(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                      color: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(
                  height: 15,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Create a new account",
                      style: GoogleFonts.roboto(
                        fontSize: 15,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(
                      width: 8,
                    ),
                    InkWell(
                      onTap: () => Navigator.of(context).pop(),
                      child: Text(
                        "Register",
                        style: GoogleFonts.roboto(
                          fontSize: 18,
                          color: const Color.fromARGB(255, 93, 4, 134),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
