import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:captionsocial/widgets/caption.dart';
import '../providers/posts.dart';

class CategoryDetailScreen extends StatefulWidget {
  static const routeName = 'category-detail-screen';

  @override
  _CategoryDetailScreenState createState() => _CategoryDetailScreenState();
}

class _CategoryDetailScreenState extends State<CategoryDetailScreen> {
  Future myFuture;
  Map categoryArgs;
  bool loading = true;
  int initialStart = 0;
  int initialEnd = 15;
  bool isLoading = false;
  ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    print('init state');
    int start = initialEnd + 1;

    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        if (!isLoading) {
          setState(() {
            isLoading = true;
          });
          final postsData = Provider.of<Posts>(context, listen: false);
          postsData
              .getPostsBySlug(categoryArgs['slug'], start, initialEnd,
                  getMore: true)
              .then((value) {
            setState(() {
              isLoading = false;
            });
          }).catchError((onError) {
            setState(() {
              isLoading = false;
            });
          });
          start = start + initialEnd;
        }
      }
    });

    super.initState();
  }

  @override
  void didChangeDependencies() {
    if (loading) {
      categoryArgs =
          ModalRoute.of(context).settings.arguments as Map<String, String>;
      final postsData = Provider.of<Posts>(context, listen: false);
      myFuture = postsData.getPostsBySlug(
          categoryArgs['slug'], initialStart, initialEnd);
      loading = false;
    }
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    print('running again');

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          categoryArgs['name'],
        ),
      ),
      body: FutureBuilder(
        future: myFuture,
        builder: (ctx, snapShot) =>
            snapShot.connectionState == ConnectionState.waiting
                ? Center(
                    child: CircularProgressIndicator(),
                  )
                : Consumer<Posts>(
                    builder: (ct, postsData, child) => Padding(
                      padding: EdgeInsets.symmetric(horizontal: 0, vertical: 0),
                      child: ListView.builder(
                        controller: _scrollController,
                        physics: BouncingScrollPhysics(),
                        padding: const EdgeInsets.all(10.0),
                        itemCount: postsData.posts.length + 1,
                        itemBuilder: (ctx, i) => (i == postsData.posts.length)
                            ? Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Center(
                                  child: Opacity(
                                    opacity: isLoading ? 1.0 : 0.0,
                                    child: CircularProgressIndicator(),
                                  ),
                                ),
                              )
                            : Caption(
                                postsData.posts[i].id,
                                postsData.posts[i].title,
                                postsData.posts[i].categorySlug,
                                postsData.posts[i].isFavorite,
                              ),
                      ),
                    ),
                  ),
      ),
    );
  }
}
