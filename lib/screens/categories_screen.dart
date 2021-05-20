import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/categories.dart';
import 'package:captionsocial/widgets/category.dart';

class CategoryScreen extends StatefulWidget {
  @override
  _CategoryScreenState createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {
  Future<void> _refreshCategories(BuildContext context) async {
    await Provider.of<Categories>(context, listen: false)
        .fetchAndSetCategories();
  }

  Future myFuture;

  @override
  void initState() {
    myFuture = Future.delayed(Duration.zero).then((value) {
      Provider.of<Categories>(context, listen: false).fetchAndSetCategories();
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8),
      color: Colors.white,
      child: FutureBuilder(
        future: myFuture,
        builder: (ctx, snapShot) => snapShot.connectionState ==
                ConnectionState.waiting
            ? Center(
                child: CircularProgressIndicator(),
              )
            : RefreshIndicator(
                onRefresh: () {
                  return _refreshCategories(context);
                },
                child: Consumer<Categories>(
                  builder: (ct, categoriesData, child) => Padding(
                    padding: EdgeInsets.symmetric(horizontal: 0, vertical: 0),
                    child: GridView.builder(
                      //physics: BouncingScrollPhysics(),
                      physics: const AlwaysScrollableScrollPhysics(),
                      padding: const EdgeInsets.all(10.0),
                      itemCount: categoriesData.categories.length,
                      itemBuilder: (ctx, i) => Category(
                        categoriesData.categories[i].id,
                        categoriesData.categories[i].name,
                        categoriesData.categories[i].image,
                        categoriesData.categories[i].slug,
                      ),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        childAspectRatio: 3 / 2,
                        mainAxisSpacing: 10,
                        crossAxisSpacing: 10,
                      ),
                    ),
                  ),
                ),
              ),
      ),
    );
  }
}
