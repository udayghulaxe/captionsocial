import 'dart:io';
import 'package:flutter/material.dart';

import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:firebase_ml_vision/firebase_ml_vision.dart';

import 'package:captionsocial/providers/posts.dart';
import 'package:captionsocial/widgets/caption.dart';

class SuggestionsScreen extends StatefulWidget {
  @override
  _SuggestionsScreenState createState() => _SuggestionsScreenState();
}

class _SuggestionsScreenState extends State<SuggestionsScreen> {
  File _imageFile;
  String _searchKeyword;
  final picker = ImagePicker();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  Future getImage(source) async {
    final pickedFile = await picker.getImage(source: source);
    final FirebaseVisionImage visionImage =
        FirebaseVisionImage.fromFile(File(pickedFile.path));
    final ImageLabeler labeler = FirebaseVision.instance.imageLabeler();

    final List<ImageLabel> labels = await labeler.processImage(visionImage);

    _searchKeyword = labels[0].text;

    // for (ImageLabel label in labels) {
    //   print(label.text);
    //   print(label.confidence);
    //   // final String text = label.text;
    //   // final String entityId = label.entityId;
    //   // final double confidence = label.confidence;
    // }

    setState(() {
      _imageFile = File(pickedFile.path);
    });
  }

  Future getSearchedCaptions() async {
    final postsDataProvider = Provider.of<Posts>(context, listen: false);
    await postsDataProvider.searchCaptions(_searchKeyword);
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        height: MediaQuery.of(context).size.height - 130,
        child: Column(
          children: [
            Container(
              alignment: Alignment.topCenter,
              width: MediaQuery.of(context).size.width,
              // height: 120,
              margin: EdgeInsets.only(top: 5, bottom: 5),
              child: _imageFile == null
                  ? Column(
                      children: <Widget>[
                        Container(
                          margin: EdgeInsets.only(
                            top: 20,
                          ),
                          width: MediaQuery.of(context).size.width * 0.80,
                          child: Text(
                            'Try our new machine learning captions search by image.',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 20,
                              color: Theme.of(context)
                                  .primaryColor
                                  .withOpacity(0.8),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 30,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            MaterialButton(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              color: Theme.of(context).primaryColor,
                              minWidth:
                                  MediaQuery.of(context).size.width * 0.40,
                              height: 50,
                              onPressed: () {
                                getImage(ImageSource.gallery);
                              },
                              child: Text(
                                'Gallery',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                ),
                              ),
                            ),
                            MaterialButton(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              color: Theme.of(context).primaryColor,
                              minWidth:
                                  MediaQuery.of(context).size.width * 0.40,
                              height: 50,
                              onPressed: () {
                                getImage(ImageSource.camera);
                              },
                              child: Text(
                                'Camera',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                ),
                              ),
                            )
                          ],
                        ),
                      ],
                    )
                  : Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Container(
                          height: 45,
                          width: 45,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.black87),
                            image: new DecorationImage(
                              fit: BoxFit.fill,
                              image: FileImage(_imageFile),
                            ),
                          ),
                        ),
                        MaterialButton(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          color: Theme.of(context).primaryColor,
                          minWidth: MediaQuery.of(context).size.width * 0.30,
                          height: 40,
                          onPressed: () {
                            getImage(ImageSource.gallery);
                          },
                          child: Text(
                            'Gallery',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                            ),
                          ),
                        ),
                        MaterialButton(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          color: Theme.of(context).primaryColor,
                          minWidth: MediaQuery.of(context).size.width * 0.30,
                          height: 40,
                          onPressed: () {
                            getImage(ImageSource.camera);
                          },
                          child: Text(
                            'Camera',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                            ),
                          ),
                        )
                      ],
                    ),
            ),
            _imageFile == null
                ? Container()
                : FutureBuilder(
                    future: getSearchedCaptions(),
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
                                        .searchedPosts.length >
                                    0
                                ? Container(
                                    height: MediaQuery.of(context).size.height -
                                        190,
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 0, vertical: 0),
                                    child: ListView.builder(
                                      physics: BouncingScrollPhysics(),
                                      padding: const EdgeInsets.all(10.0),
                                      itemCount: postsData.searchedPosts.length,
                                      itemBuilder: (ctx, i) => Caption(
                                        postsData.searchedPosts[i].id,
                                        postsData.searchedPosts[i].title,
                                        postsData.searchedPosts[i].categorySlug,
                                        postsData.searchedPosts[i].isFavorite,
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
          ],
        ),
      ),
    );
  }
}
