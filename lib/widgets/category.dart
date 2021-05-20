import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

import 'package:captionsocial/screens/category_detail_screen.dart';

class Category extends StatelessWidget {
  final String id;
  final String name;
  final String image;
  final String slug;

  Category(this.id, this.name, this.image, this.slug);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () {
        Navigator.of(context).pushNamed(
          CategoryDetailScreen.routeName,
          arguments: {
            'id': id,
            'name': name,
            'slug': slug,
          },
        );
      },
      child: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            alignment: Alignment.center,
            fit: BoxFit.cover,
            image: CachedNetworkImageProvider(
              image,
            ),
          ),
          borderRadius: BorderRadius.circular(12),
          //color: Theme.of(context).primaryColor.withOpacity(0.8),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 0, sigmaY: 0),
            child: Container(
              alignment: Alignment.center,
              color: Colors.black.withOpacity(0.6),
              child: Text(
                name,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  // shadows: [
                  //   Shadow(
                  //     blurRadius: 5.0,
                  //     color: Colors.black,
                  //     offset: Offset(2.0, 2.0),
                  //   ),
                  // ],
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
