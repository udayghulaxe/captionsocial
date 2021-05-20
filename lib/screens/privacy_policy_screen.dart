import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class PrivacyPolicyScreen extends StatelessWidget {
  static const routeName = 'privacy-policy-screen';

  _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('About'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: MediaQuery.of(context).size.width * 0.6,
              height: 50,
              child: RaisedButton(
                color: Theme.of(context).primaryColor,
                onPressed: () {
                  const url =
                      'https://udayghulaxe.me/captioncards/about-us.html';
                  _launchURL(url);
                },
                child: Text(
                  'About',
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Container(
              width: MediaQuery.of(context).size.width * 0.6,
              height: 50,
              child: RaisedButton(
                color: Theme.of(context).primaryColor,
                onPressed: () {
                  const url =
                      'https://udayghulaxe.me/captioncards/about-us.html';
                  _launchURL(url);
                },
                child: Text(
                  'Contact',
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Container(
              width: MediaQuery.of(context).size.width * 0.6,
              height: 50,
              child: RaisedButton(
                color: Theme.of(context).primaryColor,
                onPressed: () {
                  const url =
                      'https://udayghulaxe.me/captioncards/terms-of-use.html';
                  _launchURL(url);
                },
                child: Text(
                  'Terms Of Use',
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Container(
              width: MediaQuery.of(context).size.width * 0.6,
              height: 50,
              child: RaisedButton(
                color: Theme.of(context).primaryColor,
                onPressed: () {
                  const url =
                      'https://udayghulaxe.me/captioncards/privacy-policy.html';
                  _launchURL(url);
                },
                child: Text(
                  'Privacy Policy',
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 40,
            ),
            Text(
              'Version 1.0.0',
              style: TextStyle(color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }
}
