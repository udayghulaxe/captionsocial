import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:captionsocial/widgets/profile_body.dart';
import 'package:captionsocial/widgets/profile_image.dart';

class UserProfile extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        width: MediaQuery.of(context).size.width,
        child: Stack(
          children: [
            Container(
              height: 150,
              color: Theme.of(context).primaryColor,
            ),
            ProfileBody(),
            ProfileImage(),
          ],
        ),
      ),
    );
  }
}
