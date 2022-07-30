import 'package:flutter/material.dart';
import 'package:herewego/services/prefs_service.dart';
import 'package:herewego/services/rtdb_service.dart';

import '../model/post_model.dart';

class AddPostPage extends StatefulWidget {
  static const String id = 'add_post_page';
  const AddPostPage({Key? key}) : super(key: key);

  @override
  State<AddPostPage> createState() => _AddPostPageState();
}

class _AddPostPageState extends State<AddPostPage> {
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _contentController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();

  _addPost() async {
    String fName = _firstNameController.text.toString();
    String lName = _lastNameController.text.toString();
    String content = _contentController.text.toString();
    String date = _dateController.text.toString();
    if (fName.isEmpty || lName.isEmpty || content.isEmpty || date.isEmpty) return;

    _apiAddPost(fName, lName, content, date);
  }

  _apiAddPost(String fName, String lName, String content, String date) async {
    var id = await Prefs.loadUserId() ?? '';
    RTDBService.addPost(Post(userId: id, firstName: fName, lastName: lName, content: content, date: date)).then(
      (response) {
        _resAddPost();
      },
    );
  }

  _resAddPost() {
    Navigator.of(context).pop({'data': 'done'});
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepOrange,
        title: const Text('All Posts'),
      ),
      body: SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height,
          padding: const EdgeInsets.all(30),
          child: Column(
            children: [
              const SizedBox(height: 15),
              TextField(
                controller: _firstNameController,
                decoration: const InputDecoration(
                  hintText: "Firstname",
                ),
              ),
              const SizedBox(height: 15),
              TextField(
                controller: _lastNameController,
                decoration: const InputDecoration(
                  hintText: "Lastname",
                ),
              ),
              const SizedBox(height: 15),
              TextField(
                controller: _contentController,
                decoration: const InputDecoration(
                  hintText: "Content",
                ),
              ),
              const SizedBox(height: 15),
              TextField(
                controller: _dateController,
                decoration: const InputDecoration(
                  hintText: "Date",
                ),
              ),
              const SizedBox(height: 15),
              SizedBox(
                width: MediaQuery.of(context).size.width,
                height: 45,
                child: FlatButton(
                  onPressed: _addPost,
                  color: Colors.deepOrange,
                  child: const Text("Add", style: TextStyle(color: Colors.white)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
