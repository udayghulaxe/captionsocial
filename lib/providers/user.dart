import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

class UserItem {
  final String id;
  final String name;
  final String email;
  final String imageUrl;

  UserItem({this.id, this.name, this.email, this.imageUrl});
}

class Users with ChangeNotifier {
  Future<void> createUser(
      String id, String name, String email, String imageUrl) async {
    var url = 'http://udayghulaxe.me/captioncards/api/user/create.php';

    try {
      final response = await http.post(url,
          body: json.encode({
            'id': id,
            'name': name,
            'email': email,
            'imageUrl': imageUrl,
          }));
      if (response.body != 'null') {
        print(response.body);
      }
    } catch (error) {
      throw (error);
    }
  }
}
