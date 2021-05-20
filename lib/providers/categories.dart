import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

class CategoryItem {
  final String id;
  final String name;
  final String slug;
  final String image;

  CategoryItem({
    this.id,
    this.name,
    this.slug,
    this.image,
  });
}

class Categories with ChangeNotifier {
  List<CategoryItem> _categories = [];

  List<CategoryItem> get categories {
    return [..._categories];
  }

  Future<void> fetchAndSetCategories() async {
    var url = 'http://udayghulaxe.me/captioncards/api/category/read.php';

    try {
      final response = await http.get(url);
      if (response.body != 'null') {
        final List<CategoryItem> loadedCategories = [];
        final extractedData = json.decode(response.body);
        extractedData.forEach((value) {
          loadedCategories.add(CategoryItem(
            id: value['id'].toString(),
            name: value['name'],
            slug: value['slug'],
            image: value['image'],
          ));
        });

        _categories = loadedCategories;
        notifyListeners();
      }
    } catch (error) {
      throw (error);
    }
  }
}
