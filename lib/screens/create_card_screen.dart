import 'dart:io';
import 'package:flutter/material.dart';

import 'package:captionsocial/widgets/create_card.dart';
import 'package:wc_flutter_share/wc_flutter_share.dart';
import 'package:screenshot/screenshot.dart';

class CreateCardScreen extends StatefulWidget {
  static const routeName = 'create-card-screen';

  @override
  _CreateCardScreenState createState() => _CreateCardScreenState();
}

class _CreateCardScreenState extends State<CreateCardScreen> {
  //Create an instance of ScreenshotController
  ScreenshotController screenshotController = ScreenshotController();

  @override
  Widget build(BuildContext context) {
    Map cardArgs =
        ModalRoute.of(context).settings.arguments as Map<String, String>;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text('Create Card'),
        actions: [
          FlatButton(
            onPressed: () {
              Future.delayed(const Duration(milliseconds: 20), () {
                screenshotController
                    .capture(pixelRatio: 1.5)
                    .then((File image) async {
                  //Capture Done
                  await WcFlutterShare.share(
                    sharePopupTitle: 'Share Caption',
                    fileName: 'share.png',
                    mimeType: 'image/png',
                    bytesOfFile: image.readAsBytesSync(),
                  );
                }).catchError((onError) {
                  print(onError);
                });
              });
            },
            child: Text(
              'Share',
              style: TextStyle(
                color: Colors.white,
              ),
            ),
          )
        ],
      ),
      body: CreateCard(cardArgs['captionTitle'], screenshotController),
    );
  }
}
