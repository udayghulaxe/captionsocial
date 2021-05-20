import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:captionsocial/widgets/caption.dart';
import '../providers/posts.dart';
import 'package:captionsocial/screens/add_caption_screen.dart';

class MyCaptionScreen extends StatefulWidget {
  static const routeName = 'my-caption-screen';

  @override
  _MyCaptionScreenState createState() => _MyCaptionScreenState();
}

class _MyCaptionScreenState extends State<MyCaptionScreen> {
  bool loading = true;
  Map routeArgs;
  Future postsFuture;

  @override
  void didChangeDependencies() {
    if (loading) {
      routeArgs =
          ModalRoute.of(context).settings.arguments as Map<String, String>;
      final postsData = Provider.of<Posts>(context, listen: false);
      postsFuture = postsData.getUserCaptions(routeArgs['userId']);
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
          'My Captions',
        ),
      ),
      body: FutureBuilder(
        future: postsFuture,
        builder: (ctx, snapShot) => snapShot.connectionState ==
                ConnectionState.waiting
            ? Center(
                child: CircularProgressIndicator(),
              )
            : Consumer<Posts>(
                builder: (ct, postsData, child) => Padding(
                  padding: EdgeInsets.symmetric(horizontal: 0, vertical: 0),
                  child: postsData.userCaption.length > 0
                      ? ListView.builder(
                          physics: BouncingScrollPhysics(),
                          padding: const EdgeInsets.all(10.0),
                          itemCount: postsData.userCaption.length,
                          itemBuilder: (ctx, i) => Caption(
                            postsData.userCaption[i].id,
                            postsData.userCaption[i].title,
                            postsData.userCaption[i].categorySlug,
                            postsData.userCaption[i].isFavorite,
                            deleteCaption: true,
                            underReview: postsData.userCaption[i].active == '2'
                                ? true
                                : false,
                          ),
                        )
                      : Container(
                          margin: EdgeInsets.only(
                            top: 100,
                            right: 20,
                            left: 20,
                          ),
                          height: MediaQuery.of(context).size.height,
                          child: Center(
                            child: Column(
                              children: [
                                Icon(
                                  Icons.chrome_reader_mode,
                                  size: 100,
                                  color: Colors.grey[300],
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Text(
                                  'No contribution so far.',
                                  style: TextStyle(
                                    color: Colors.grey,
                                    fontSize: 20,
                                  ),
                                ),
                                SizedBox(
                                  height: 20,
                                ),
                                MaterialButton(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12.0),
                                  ),
                                  minWidth:
                                      MediaQuery.of(context).size.width * 0.60,
                                  color: Theme.of(context).primaryColor,
                                  height: 50,
                                  onPressed: () {
                                    Navigator.of(context)
                                        .pushNamed(AddCaptionScreen.routeName);
                                  },
                                  child: Container(
                                    width: MediaQuery.of(context).size.width *
                                        0.60,
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          'Add Captions',
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            fontSize: 18,
                                            color: Colors.white,
                                            fontWeight: FontWeight.w400,
                                          ),
                                        ),
                                      ],
                                    ),
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
