import 'package:flutter/material.dart';
import 'package:herewego/model/post_model.dart';
import 'package:herewego/pages/add_post_page.dart';
import 'package:herewego/services/auth_service.dart';

import '../services/prefs_service.dart';
import '../services/rtdb_service.dart';

class HomePage extends StatefulWidget {
  static const String id = 'home_page';
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Post> items = <Post>[];
  String? userId;

  @override
  void initState() {
    super.initState();
    _apiGetPosts();
  }

  Future _openAddPost() async {
    Map? result = await Navigator.of(context).push(MaterialPageRoute(builder: (context) => const AddPostPage()));
    if (result != null && result.containsKey('data')) {
      debugPrint(result['data']);
      _apiGetPosts();
    }
  }

  _apiGetPosts() async {
    var id = await Prefs.loadUserId() ?? '';
    RTDBService.getPosts(id).then((posts) => {
          _respPosts(posts),
        });
  }

  _respPosts(List<Post> posts) {
    setState(() {
      items = posts;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepOrange,
        title: const Text('All Posts'),
        actions: [
          IconButton(
            onPressed: () {
              AuthService.signOutUser(context);
            },
            icon: const Icon(
              Icons.exit_to_app,
              color: Colors.white,
            ),
          ),
        ],
      ),
      body: FutureBuilder(
          future: RTDBService.getPosts((userId ?? '')),
          builder: (context, snp) {
            return ListView.builder(
              itemCount: items.length,
              itemBuilder: (context, index) => _itemOfPost(items[index]),
            );
          }),
      floatingActionButton: FloatingActionButton(
        onPressed: _openAddPost,
        backgroundColor: Colors.deepOrange,
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _itemOfPost(Post post) {
    return Container(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('${post.firstName} ${post.lastName}', style: const TextStyle(color: Colors.black, fontSize: 20)),
          const SizedBox(height: 10),
          Text(post.date, style: const TextStyle(color: Colors.black, fontSize: 16)),
          const SizedBox(height: 10),
          Text(post.content, style: const TextStyle(color: Colors.black, fontSize: 16)),
        ],
      ),
    );
  }
}
