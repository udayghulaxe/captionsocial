import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:captionsocial/providers/posts.dart';
import 'package:captionsocial/widgets/caption.dart';

class SearchScreen extends StatefulWidget {
  static const routeName = 'search-screen';

  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  var _searchText = '';
  final _formKey = GlobalKey<FormState>();
  Future futureVar;
  void _search() async {
    var isValid = _formKey.currentState.validate();
    if (!isValid) {
      return;
    }
    _formKey.currentState.save();
    myFuture = getSearchedCaptions();
  }

  Future myFuture;

  @override
  void initState() {
    myFuture = getSearchedCaptions();

    super.initState();
  }

  Future getSearchedCaptions() async {
    final postsDataProvider = Provider.of<Posts>(context, listen: false);
    await postsDataProvider.searchCaptions(_searchText, usersearch: true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () {
          FocusScope.of(context).requestFocus(new FocusNode());
        },
        child: Column(
          children: [
            Container(
              color: Theme.of(context).primaryColor,
              child: Form(
                key: _formKey,
                child: Container(
                  margin: EdgeInsets.only(
                    top: 40,
                  ),
                  child: Row(
                    children: <Widget>[
                      IconButton(
                        icon: Icon(
                          Icons.arrow_back,
                          color: Colors.white,
                        ),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      ),
                      Container(
                        margin: EdgeInsets.only(
                          left: 10,
                        ),
                        width: MediaQuery.of(context).size.width * 0.7,
                        height: 35,
                        child: TextFormField(
                          autofocus: true,
                          style: TextStyle(
                            color: Colors.white,
                          ),
                          decoration: InputDecoration(
                            floatingLabelBehavior: FloatingLabelBehavior.never,
                            hintText: 'Input search text ..',
                            hintStyle: TextStyle(color: Colors.white54),
                          ),
                          onFieldSubmitted: (value) {
                            _search();
                            FocusScope.of(context)
                                .requestFocus(new FocusNode());
                          },
                          keyboardType: TextInputType.text,
                          textInputAction: TextInputAction.search,
                          onSaved: (newValue) {
                            _searchText = newValue;
                          },
                          validator: (value) {
                            if (value.isEmpty) {
                              return 'Please enter caption';
                            }
                            return null;
                          },
                        ),
                      ),
                      IconButton(
                        icon: Icon(
                          Icons.search,
                          color: Colors.white,
                        ),
                        onPressed: () {
                          _search();
                          FocusScope.of(context).requestFocus(new FocusNode());
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Container(
              height: MediaQuery.of(context).size.height - 90,
              child: _searchText.isEmpty
                  ? Container(
                      margin: EdgeInsets.only(top: 100),
                      width: MediaQuery.of(context).size.width * 0.8,
                      child: Column(
                        children: [
                          Icon(
                            Icons.search,
                            size: 100,
                            color: Colors.grey[300],
                          ),
                          Text(
                            'Search for your favourite captions',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.grey[400],
                              fontSize: 20,
                            ),
                          )
                        ],
                      ),
                    )
                  : FutureBuilder(
                      future: myFuture,
                      builder: (ctx, snapShot) => snapShot.connectionState ==
                              ConnectionState.waiting
                          ? Center(
                              child: Container(
                                margin: EdgeInsets.only(top: 20),
                                child: CircularProgressIndicator(),
                              ),
                            )
                          : Consumer<Posts>(
                              builder: (ct, postsData, child) => postsData
                                          .userSearchedPosts.length >
                                      0
                                  ? Container(
                                      height:
                                          MediaQuery.of(context).size.height -
                                              190,
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 0, vertical: 0),
                                      child: ListView.builder(
                                        physics: BouncingScrollPhysics(),
                                        padding: const EdgeInsets.all(10.0),
                                        itemCount:
                                            postsData.userSearchedPosts.length,
                                        itemBuilder: (ctx, i) => Caption(
                                          postsData.userSearchedPosts[i].id,
                                          postsData.userSearchedPosts[i].title,
                                          postsData.userSearchedPosts[i]
                                              .categorySlug,
                                          postsData
                                              .userSearchedPosts[i].isFavorite,
                                        ),
                                      ),
                                    )
                                  : Container(
                                      margin: EdgeInsets.only(top: 100),
                                      height: 200,
                                      child: Center(
                                        child: Column(
                                          children: [
                                            Icon(
                                              Icons.sentiment_dissatisfied,
                                              size: 100,
                                              color: Colors.grey[300],
                                            ),
                                            SizedBox(
                                              height: 10,
                                            ),
                                            Text(
                                              'No result found.',
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
          ],
        ),
      ),
    );
  }
}
