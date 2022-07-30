import 'dart:collection';

import 'package:firebase_database/firebase_database.dart';

import '../model/post_model.dart';

class RTDBService {
  static final _database = FirebaseDatabase.instance.ref();

  static Future<Stream<DatabaseEvent>> addPost(Post post) async {
    _database.child("posts").push().set(post.toJson());
    return _database.onChildAdded;
  }

  static Future<List<Post>> getPosts(String id) async {
    List<Post> items = <Post>[];
    LinkedHashMap? result;
    Query query = _database.ref.child("posts").orderByChild("userId").equalTo(id);
    await query.once().then((snp) {
      result = snp.snapshot.value as LinkedHashMap?;
    });
    result?.forEach((key, value) {
      items.add(Post.fromJson(Map<String, dynamic>.from(value)));
    });
    return items;
  }
}
