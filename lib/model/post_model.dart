class Post {
  String userId;
  String firstName;
  String lastName;
  String content;
  String date;
  String? imgUrl;

  Post(
      {required this.userId,
      required this.firstName,
      required this.lastName,
      required this.content,
      required this.date,
      required this.imgUrl});

  Post.fromJson(Map<String, dynamic> json)
      : userId = json['userId'],
        firstName = json['firstName'],
        lastName = json['lastName'],
        content = json['content'],
        date = json['date'],
        imgUrl = json['imgUrl'];

  Map<String, dynamic> toJson() => {
        'userId': userId,
        'firstName': firstName,
        'lastName': lastName,
        'content': content,
        'date': date,
        'imgUrl': imgUrl,
      };
}
