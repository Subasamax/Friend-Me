import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';



Future<http.Response> rGetUsers() async {
  String?uid = FirebaseAuth.instance.currentUser?.uid; 
  var url = Uri(
    scheme: 'http',
    host: '127.0.0.1',
    port: 8000,
    path: 'usersdetails/', //placeholder url, replace with backend url.
  );
  http.Response response = await http.get(
    url,
    headers: {
      'Authorization': '$uid',
    },
  );
  if (response.statusCode != 200) {
    return response;
  }
  //List<HTTPUser> users =
  return response;
}

Future<http.Response> postUser(friendme_user user, String? uid) {
  var url = Uri(
    scheme: 'http',
    host: '127.0.0.1',
    port: 8000,
    path: 'usersdetails/',
  );
  return http.post(
    url,
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization': '$uid',
    },
    body: jsonEncode(<String, String>{
      'id': '${user.id}',
      'uid': "$uid",
      'username': "${user.username}",
      'email': "${user.email}",
      'first_name': "${user.first_name}",
      'last_name': "${user.last_name}",
    }),
  );
}

List<friendme_user> rListUsers(http.Response response) {
  Iterable list = json.decode(response.body);
  List<friendme_user> users =
      List<friendme_user>.from(list.map((model) => friendme_user.fromJson(model)));
  return users;
}


class friendme_user {
  final int id;
  final String? uid;
  final String? username;
  final String? email;
  final String? first_name;
  final String? last_name;
  //final int creator_id

  friendme_user({
    required this.id,
    required this.uid,
    required this.username,
    required this.email,
    required this.first_name,
    required this.last_name,
  });

  factory friendme_user.fromJson(Map<String, dynamic> json) {
    print(json["username"]as String); 
    return friendme_user(
      id: json['id'] as int,
      uid: json['uid'] as String,
      username: json['username'] as String,
      email: json['email'] as String,
      first_name: json['first_name'] as String,
      last_name: json['last_name'] as String,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id, //exclude since auto generated by django
        'uid': uid,
        'username': username,
        'email': email,
        'first_name': first_name,
        'last_name': last_name,
      };
}
