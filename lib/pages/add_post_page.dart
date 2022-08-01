import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:herewego/services/prefs_service.dart';
import 'package:herewego/services/rtdb_service.dart';
import 'package:image_picker/image_picker.dart';

import '../model/post_model.dart';
import '../services/store_service.dart';

class AddPostPage extends StatefulWidget {
  static const String id = 'add_post_page';
  const AddPostPage({Key? key}) : super(key: key);

  @override
  State<AddPostPage> createState() => _AddPostPageState();
}

class _AddPostPageState extends State<AddPostPage> {
  var isLoading = false;
  File? _image;
  final picker = ImagePicker();

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
    if (_image == null) return;

    _apiUploadImage(fName, lName, content, date);
  }

  void _apiUploadImage(String fName, String lName, String content, String date) {
    setState(() {
      isLoading = true;
    });
    StoreService.uploadImage(_image!).then((imgUrl) => {
          _apiAddPost(fName, lName, content, date, imgUrl),
        });
  }

  _apiAddPost(String fName, String lName, String content, String date, String imgUrl) async {
    var id = await Prefs.loadUserId() ?? '';
    RTDBService.addPost(Post(
      userId: id,
      firstName: fName,
      lastName: lName,
      content: content,
      date: date,
      imgUrl: imgUrl,
    )).then(
      (response) {
        _resAddPost();
      },
    );
  }

  _resAddPost() {
    setState(() {
      isLoading = false;
    });
    Navigator.of(context).pop({'data': 'done'});
  }

  Future _getImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      } else {
        if (kDebugMode) {
          print('No image selected.');
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepOrange,
        title: const Text('All Posts'),
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Container(
              height: MediaQuery.of(context).size.height,
              padding: const EdgeInsets.all(30),
              child: Column(
                children: [
                  // #pickImage
                  /// via clicking camera image user can pick image from her/his gallery or shoot the picture.
                  GestureDetector(
                    onTap: _getImage,
                    child: SizedBox(
                      width: 100,
                      height: 100,
                      child: _image != null
                          ? Image.file(_image!, fit: BoxFit.cover)
                          : Image.asset('assets/images/ic_instagram_camera.png'),
                    ),
                  ),

                  const SizedBox(height: 15),
                  // #firstname
                  TextField(
                    controller: _firstNameController,
                    decoration: const InputDecoration(
                      hintText: "Firstname",
                    ),
                  ),
                  const SizedBox(height: 15),
                  // #lastname
                  TextField(
                    controller: _lastNameController,
                    decoration: const InputDecoration(
                      hintText: "Lastname",
                    ),
                  ),
                  const SizedBox(height: 15),
                  // #content
                  TextField(
                    controller: _contentController,
                    decoration: const InputDecoration(
                      hintText: "Content",
                    ),
                  ),
                  const SizedBox(height: 15),
                  // #date
                  TextField(
                    controller: _dateController,
                    decoration: const InputDecoration(
                      hintText: "Date",
                    ),
                  ),
                  const SizedBox(height: 15),
                  // #addBtn#
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
          isLoading
              ? const Positioned(
                  top: 0, bottom: 0, left: 0, right: 0, child: Center(child: CircularProgressIndicator()))
              : const SizedBox.shrink(),
        ],
      ),
    );
  }
}
