import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class PostItem {
  final String id;
  final String categorySlug;
  final String title;
  bool isFavorite;

  PostItem({
    this.id,
    this.categorySlug,
    this.title,
    this.isFavorite = false,
  });
}

class UserPostItem {
  final String id;
  final String categorySlug;
  final String title;
  final String active;
  bool isFavorite;

  UserPostItem({
    this.id,
    this.categorySlug,
    this.title,
    this.active,
    this.isFavorite = false,
  });
}

class Posts with ChangeNotifier {
  final FirebaseAuth auth = FirebaseAuth.instance;

  List<PostItem> _posts = [];

  List<PostItem> _searchedPosts = [];

  List<PostItem> _userSearchedPosts = [];

  List<PostItem> _userFavouritesCaption = [];

  List<UserPostItem> _userCaption = [];

  List<PostItem> get userFavouritesCaption {
    return [..._userFavouritesCaption];
  }

  List<UserPostItem> get userCaption {
    return [..._userCaption];
  }

  List<PostItem> get searchedPosts {
    return [..._searchedPosts];
  }

  List<PostItem> get userSearchedPosts {
    return [..._userSearchedPosts];
  }

  set userSearchedPosts(List<PostItem> data) {
    _userSearchedPosts = data;
  }

  List<PostItem> get posts {
    return [..._posts];
  }

  Future<void> updateFavorite(String captionId, bool isFav) async {
    var url =
        'http://udayghulaxe.me/captioncards/api/user/updateUserFavorite.php';

    try {
      await http.post(url,
          body: json.encode({
            'captionId': captionId,
            'userId': auth.currentUser.uid,
            'favoriteStatus': isFav,
          }));
      // if (response.body != 'null') {
      //   print(response.body);
      // }
    } catch (error) {
      throw (error);
    }
  }

  Future<void> addUserCaption(String captionText, String categoryId,
      String categorySlug, String userId) async {
    var url = 'http://udayghulaxe.me/captioncards/api/posts/addUserCaption.php';

    try {
      final response = await http.post(url,
          body: json.encode({
            'captionText': captionText,
            'categoryId': categoryId,
            'categorySlug': categorySlug,
            'userId': userId,
          }));
      print(response.body);
      if (response.statusCode != 200) {
        throw HttpException('${response.statusCode}');
      }
    } catch (error) {
      print('error');
      throw (error);
    }
  }

  Future<void> deleteUserCaption(String captionId) async {
    var url =
        'http://udayghulaxe.me/captioncards/api/posts/deleteUserCaption.php';
    try {
      final response = await http.post(url,
          body: json.encode({
            'captionId': captionId,
          }));
      if (response.statusCode != 200) {
        throw HttpException('${response.statusCode}');
      }
      _userCaption.removeWhere((item) => item.id == captionId);

      notifyListeners();
    } catch (error) {
      print('error');
      throw (error);
    }
  }

  Future<void> getUserCaptions(String userId) async {
    var url =
        'http://udayghulaxe.me/captioncards/api/user/getUserCaptions.php?userId=$userId';
    try {
      final response = await http.get(url);
      if (response.body.isNotEmpty) {
        final List<UserPostItem> loadedPosts = [];
        final extractedData = json.decode(response.body);
        extractedData.forEach((value) {
          loadedPosts.add(UserPostItem(
            id: value['id'].toString(),
            categorySlug: value['categorySlug'],
            title: value['title'],
            // isfavorite can be null so checking exact condition below
            isFavorite: value['isFavorite'] == true ? true : false,
            active: value['active'],
          ));
        });

        _userCaption = loadedPosts;
      } else {
        _userCaption = [];
      }
      notifyListeners();
    } catch (error) {
      print('error here');
      throw (error);
    }
  }

  Future<void> getUserFavourites(String userId) async {
    var url =
        'http://udayghulaxe.me/captioncards/api/user/getFavorites.php?userId=$userId';
    try {
      final response = await http.get(url);
      if (response.body.isNotEmpty) {
        final List<PostItem> loadedPosts = [];
        final extractedData = json.decode(response.body);
        extractedData.forEach((value) {
          loadedPosts.add(PostItem(
            id: value['id'].toString(),
            categorySlug: value['categorySlug'],
            title: value['title'],
            // isfavorite can be null so checking exact condition below
            isFavorite: value['isFavorite'] == true ? true : false,
          ));
        });

        _userFavouritesCaption = loadedPosts;
      } else {
        _userFavouritesCaption = [];
      }
      notifyListeners();
    } catch (error) {
      print('error here');
      throw (error);
    }
  }

  Future<void> searchCaptions(String keyword, {bool usersearch = false}) async {
    var url =
        'http://udayghulaxe.me/captioncards/api/posts/search.php?search=$keyword';

    try {
      final response = await http.get(url);
      if (response.body.isNotEmpty) {
        final List<PostItem> loadedPosts = [];
        final extractedData = json.decode(response.body);
        extractedData.forEach((value) {
          loadedPosts.add(PostItem(
            id: value['id'].toString(),
            categorySlug: value['categorySlug'],
            title: value['title'],
          ));
        });
        if (usersearch == true) {
          _userSearchedPosts = loadedPosts;
        } else {
          _searchedPosts = loadedPosts;
        }
      } else {
        if (usersearch == true) {
          _userSearchedPosts = [];
        } else {
          _searchedPosts = [];
        }
      }
      notifyListeners();
    } catch (error) {
      print('error here');
      throw (error);
    }
  }

  Future<void> getPostsBySlug(String slug, int start, int end,
      {bool getMore = false}) async {
    final url =
        'http://udayghulaxe.me/captioncards/api/posts/read.php?slug=$slug&userId=${auth.currentUser.uid}&start=$start&end=$end';
    try {
      final response = await http.get(url);

      if (response.body != 'null') {
        final List<PostItem> loadedPosts = [];
        final extractedData = json.decode(response.body);
        extractedData.forEach((value) {
          loadedPosts.add(PostItem(
            id: value['id'].toString(),
            categorySlug: value['categorySlug'],
            title: value['title'],
            // isfavorite can be null so checking exact condition below
            isFavorite: value['isFavorite'] == true ? true : false,
          ));
        });

        if (getMore == true) {
          _posts.addAll(loadedPosts);
        } else {
          _posts = loadedPosts;
        }

        notifyListeners();
      }
    } catch (error) {
      throw (error);
    }
  }
}
