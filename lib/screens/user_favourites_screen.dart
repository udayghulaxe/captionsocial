import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:captionsocial/widgets/caption.dart';
import '../providers/posts.dart';

class UserFavouritesScreen extends StatefulWidget {
  static const routeName = 'user-favourite-screen';

  @override
  _UserFavouritesScreenState createState() => _UserFavouritesScreenState();
}

class _UserFavouritesScreenState extends State<UserFavouritesScreen> {
  bool loading = true;
  Map routeArgs;
  Future postsFuture;

  @override
  void didChangeDependencies() {
    if (loading) {
      routeArgs =
          ModalRoute.of(context).settings.arguments as Map<String, String>;
      final postsData = Provider.of<Posts>(context, listen: false);
      postsFuture = postsData.getUserFavourites(routeArgs['userId']);
      loading = false;
    }
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          'My Favourite Captions',
        ),
      ),
      body: FutureBuilder(
        future: postsFuture,
        builder: (ctx, snapShot) =>
            snapShot.connectionState == ConnectionState.waiting
                ? Center(
                    child: CircularProgressIndicator(),
                  )
                : Consumer<Posts>(
                    builder: (ct, postsData, child) => Padding(
                      padding: EdgeInsets.symmetric(horizontal: 0, vertical: 0),
                      child: postsData.userFavouritesCaption.length > 0
                          ? ListView.builder(
                              physics: BouncingScrollPhysics(),
                              padding: const EdgeInsets.all(10.0),
                              itemCount: postsData.userFavouritesCaption.length,
                              itemBuilder: (ctx, i) => Caption(
                                postsData.userFavouritesCaption[i].id,
                                postsData.userFavouritesCaption[i].title,
                                postsData.userFavouritesCaption[i].categorySlug,
                                postsData.userFavouritesCaption[i].isFavorite,
                              ),
                            )
                          : Container(
                              margin: EdgeInsets.only(top: 100),
                              height: 200,
                              child: Center(
                                child: Column(
                                  children: [
                                    Icon(
                                      Icons.favorite_border,
                                      size: 100,
                                      color: Colors.grey[300],
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    Text(
                                      'No favourite captions so far.',
                                      style: TextStyle(
                                        color: Colors.grey,
                                        fontSize: 20,
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                    ),
                  ),
      ),
    );
  }
}
