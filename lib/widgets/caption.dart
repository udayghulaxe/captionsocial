import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:clipboard/clipboard.dart';
import 'package:wc_flutter_share/wc_flutter_share.dart';

import 'package:captionsocial/providers/posts.dart';
import 'package:captionsocial/screens/create_card_screen.dart';

class Caption extends StatefulWidget {
  final String id;
  final String title;
  final String categorySlug;
  bool isFavorite;
  bool deleteCaption;
  bool underReview;

  Caption(this.id, this.title, this.categorySlug, this.isFavorite,
      {this.deleteCaption = false, this.underReview = false});

  @override
  _CaptionState createState() => _CaptionState();
}

class _CaptionState extends State<Caption> {
  Color firstColor = Colors.indigo[600].withOpacity(0.9);
  Color secondColor = Color(0xFF363795);

  @override
  Widget build(BuildContext context) {
    final postsData = Provider.of<Posts>(context);

    toggleFavorite() {
      setState(() {
        widget.isFavorite = !widget.isFavorite;
      });

      postsData.updateFavorite(widget.id, widget.isFavorite).then((value) {
        String msg = 'Saved to favourites';
        if (widget.isFavorite == false) {
          msg = 'Removed from favourites';
        }
        final snackBar = SnackBar(
          duration: Duration(
            seconds: 1,
          ),
          content: Text(msg),
        );
        Scaffold.of(context).showSnackBar(snackBar);
      }).catchError((onError) {
        setState(() {
          widget.isFavorite = !widget.isFavorite;
        });
        final snackBar = SnackBar(
          elevation: 10,
          duration: Duration(
            seconds: 1,
          ),
          content: Text('Oops, Something went wrong'),
        );
        Scaffold.of(context).showSnackBar(snackBar);
      });
    }

    deleteCaption() {
      postsData.deleteUserCaption(widget.id).then((value) {
        final snackBar = SnackBar(
          duration: Duration(
            seconds: 1,
          ),
          content: Text('Caption removed!'),
        );
        Scaffold.of(context).showSnackBar(snackBar);
      }).catchError((onError) {
        final snackBar = SnackBar(
          elevation: 10,
          duration: Duration(
            seconds: 1,
          ),
          content: Text('Oops, Something went wrong'),
        );
        Scaffold.of(context).showSnackBar(snackBar);
      });
    }

    return Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(6),
        gradient: LinearGradient(
          colors: [
            firstColor,
            secondColor,
          ],
          begin: Alignment.bottomCenter,
          end: Alignment.topCenter,
          stops: [0.0, 1.0],
          tileMode: TileMode.mirror,
        ),
        border: Border.all(
          width: 1,
          color: Colors.black.withOpacity(0.2),
        ),
      ),
      child: Padding(
        padding: EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              decoration: BoxDecoration(),
              padding: EdgeInsets.fromLTRB(10, 20, 10, 30),
              child: Text(
                widget.title,
                style: TextStyle(
                  fontSize: 21,
                  color: Colors.white,
                ),
              ),
            ),
            Container(
              decoration: BoxDecoration(
                border: Border(
                  top: BorderSide(
                    color: Colors.white24,
                    width: 0.8,
                  ),
                ),
              ),
              height: 30,
              //color: Theme.of(context).primaryColor.withOpacity(0.6),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  IconButton(
                    splashColor: Colors.grey,
                    icon: Icon(
                      Icons.edit,
                      size: 21,
                      color: Colors.white54,
                      semanticLabel: 'Create Card',
                    ),
                    onPressed: () {
                      Navigator.of(context).pushNamed(
                        CreateCardScreen.routeName,
                        arguments: {
                          'captionTitle': widget.title,
                        },
                      );
                    },
                  ),
                  IconButton(
                    splashColor: Colors.grey,
                    icon: Icon(
                      Icons.share,
                      size: 22,
                      semanticLabel: 'Share',
                      color: Colors.white54,
                    ),
                    onPressed: () {
                      WcFlutterShare.share(
                        sharePopupTitle: 'Share',
                        subject: 'Captions by caption card',
                        text: widget.title,
                        mimeType: 'text/plain',
                      );
                    },
                  ),
                  IconButton(
                    splashColor: Colors.grey,
                    icon: Icon(
                      Icons.content_copy,
                      semanticLabel: 'Copy Caption',
                      size: 22,
                      color: Colors.white54,
                    ),
                    onPressed: () {
                      FlutterClipboard.copy(widget.title).then((value) {
                        final snackBar = SnackBar(
                          duration: Duration(
                            seconds: 1,
                          ),
                          content: Text('Copied to Clipboard'),
                        );
                        Scaffold.of(context).showSnackBar(snackBar);
                      });
                    },
                  ),
                  if (widget.underReview == false)
                    IconButton(
                      splashColor: Colors.grey,
                      icon: Icon(
                        widget.isFavorite
                            ? Icons.favorite
                            : Icons.favorite_border,
                        semanticLabel: 'Save to Favorite',
                        size: 22,
                        color: widget.isFavorite
                            ? Colors.red[400]
                            : Colors.white54,
                      ),
                      onPressed: () {
                        toggleFavorite();
                      },
                    ),
                  if (widget.underReview == true)
                    IconButton(
                      splashColor: Colors.grey,
                      icon: Icon(
                        Icons.error_outline,
                        semanticLabel: 'Under Review',
                        size: 22,
                        color: Colors.yellow[600],
                      ),
                      onPressed: () {
                        final snackBar = SnackBar(
                          action: SnackBarAction(
                              label: 'Ok',
                              onPressed: () {
                                Scaffold.of(context).hideCurrentSnackBar();
                              }),
                          content:
                              Text('Your caption is under review process!'),
                        );
                        Scaffold.of(context).showSnackBar(snackBar);
                      },
                    ),
                  if (widget.deleteCaption == true)
                    IconButton(
                      splashColor: Colors.grey,
                      icon: Icon(
                        Icons.delete,
                        semanticLabel: 'Delete',
                        size: 22,
                        color: Colors.red[400],
                      ),
                      onPressed: () {
                        deleteCaption();
                      },
                    ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
