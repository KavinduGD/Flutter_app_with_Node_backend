import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import "package:jwt_decoder/jwt_decoder.dart";
import "package:http/http.dart" as http;

class Dashboard extends StatefulWidget {
  final token;
  const Dashboard({Key? key, required this.token}) : super(key: key);

  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  late String userId;
  late List todoList = [];
  TextEditingController _todoTitle = TextEditingController();
  TextEditingController _todoDescription = TextEditingController();

  @override
  void initState() {
    super.initState();
    Map<String, dynamic> jwtDecodedToken = JwtDecoder.decode(widget.token);

    userId = jwtDecodedToken["_id"];
    getTodoList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("DashBoard"),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Text(
            "Welcome $userId",
            style: GoogleFonts.roboto(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: todoList.length,
              itemBuilder: (context, index) {
                return Card(
                  child: ListTile(
                    title: Text(todoList[index]["title"]),
                    subtitle: Text(todoList[index]["description"]),
                  ),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _displayDialog(context),
        tooltip: "Add Todo",
        child: const Icon(Icons.add),
      ),
    );
  }

  void addTodo() async {
    if (_todoTitle.text.isNotEmpty && _todoDescription.text.isNotEmpty) {
      var reqBody = {
        "userId": userId,
        "title": _todoTitle.text,
        "description": _todoDescription.text
      };

      var response = await http.post(
        Uri.parse("http://192.168.1.2:4000/api/todo"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(reqBody),
      );

      var decordedResponse = jsonDecode(response.body);

      print(decordedResponse);
      if (decordedResponse["status"] == true) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Todo Added Successfully"),
          ),
        );
        Navigator.pop(context);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Todo Added Failed"),
          ),
        );
      }
      _todoDescription.clear();
      _todoTitle.clear();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Please fill all the fields"),
        ),
      );
    }
  }

  void getTodoList() async {
    var response =
        await http.get(Uri.parse("http://192.168.1.2:4000/api/todo"));

    var decordedResponse = jsonDecode(response.body);

    todoList = decordedResponse;
    setState(() {});
  }

  Future<void> _displayDialog(BuildContext context) {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Add Todo"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                decoration: const InputDecoration(hintText: "Enter Todo"),
                controller: _todoTitle,
              ),
              TextField(
                decoration:
                    const InputDecoration(hintText: "Enter Todo Description"),
                controller: _todoDescription,
              ),
            ],
          ),
          actions: [
            ElevatedButton(
                onPressed: () {
                  addTodo();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepPurple,
                ),
                child: Text(
                  "Add",
                  style: GoogleFonts.roboto(
                    color: Colors.white,
                  ),
                )),
          ],
        );
      },
    );
  }
}
