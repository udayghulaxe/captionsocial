import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:provider/provider.dart';

import 'package:captionsocial/providers/posts.dart';

import 'package:captionsocial/screens/my_caption_screen.dart';
import 'package:captionsocial/screens/add_caption_screen.dart';
import 'package:captionsocial/screens/user_favourites_screen.dart';
import 'package:captionsocial/screens/search_screen.dart';
import 'package:captionsocial/screens/privacy_policy_screen.dart';

class AppDrawer extends StatelessWidget {
  final FirebaseAuth auth = FirebaseAuth.instance;
  final GoogleSignIn googleSignIn = GoogleSignIn();
  final Function gotoPage;
  AppDrawer(this.gotoPage);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: <Widget>[
          AppBar(
            title: Text('Hi, ${auth.currentUser.displayName}'),
            automaticallyImplyLeading: false,
          ),
          ListTile(
            leading: Icon(
              Icons.search,
              color: Theme.of(context).primaryColor,
            ),
            title: Text(
              'Search',
              style: TextStyle(
                fontSize: 16,
                color: Theme.of(context).primaryColor,
              ),
            ),
            onTap: () {
              Scaffold.of(context).openEndDrawer();
              Provider.of<Posts>(context, listen: false).userSearchedPosts = [];
              Navigator.of(context).pushNamed(SearchScreen.routeName);
            },
          ),
          ListTile(
            leading: Icon(
              Icons.camera_enhance,
              color: Theme.of(context).primaryColor,
            ),
            title: Text(
              'Suggestions',
              style: TextStyle(
                fontSize: 16,
                color: Theme.of(context).primaryColor,
              ),
            ),
            onTap: () {
              Scaffold.of(context).openEndDrawer();
              gotoPage(1);
            },
          ),
          ListTile(
            leading: Icon(
              Icons.account_circle,
              color: Theme.of(context).primaryColor,
            ),
            title: Text(
              'Profile',
              style: TextStyle(
                fontSize: 16,
                color: Theme.of(context).primaryColor,
              ),
            ),
            onTap: () {
              Scaffold.of(context).openEndDrawer();
              gotoPage(2);
            },
          ),
          ListTile(
            leading: Icon(
              Icons.favorite,
              color: Theme.of(context).primaryColor,
            ),
            title: Text(
              'Favourite Captions',
              style: TextStyle(
                fontSize: 16,
                color: Theme.of(context).primaryColor,
              ),
            ),
            onTap: () {
              Scaffold.of(context).openEndDrawer();
              Navigator.of(context).pushNamed(
                UserFavouritesScreen.routeName,
                arguments: {
                  'userId': auth.currentUser.uid,
                },
              );
            },
          ),
          ListTile(
            leading: Icon(
              Icons.chrome_reader_mode,
              color: Theme.of(context).primaryColor,
            ),
            title: Text(
              'My Captions',
              style: TextStyle(
                fontSize: 16,
                color: Theme.of(context).primaryColor,
              ),
            ),
            onTap: () {
              Scaffold.of(context).openEndDrawer();
              Navigator.of(context).pushNamed(
                MyCaptionScreen.routeName,
                arguments: {
                  'userId': auth.currentUser.uid,
                },
              );
            },
          ),
          ListTile(
            leading: Icon(
              Icons.add_circle,
              color: Theme.of(context).primaryColor,
            ),
            title: Text(
              'Add Captions',
              style: TextStyle(
                fontSize: 16,
                color: Theme.of(context).primaryColor,
              ),
            ),
            onTap: () {
              Scaffold.of(context).openEndDrawer();
              Navigator.of(context).pushNamed(
                AddCaptionScreen.routeName,
              );
            },
          ),
          Spacer(),
          ListTile(
            leading: Icon(
              Icons.contact_phone,
              color: Theme.of(context).primaryColor,
            ),
            title: Text(
              'About',
              style: TextStyle(
                fontSize: 16,
                color: Theme.of(context).primaryColor,
              ),
            ),
            onTap: () {
              Scaffold.of(context).openEndDrawer();
              Navigator.of(context).pushNamed(PrivacyPolicyScreen.routeName);
            },
          ),
          ListTile(
            leading: Icon(
              Icons.exit_to_app,
              color: Theme.of(context).primaryColor,
            ),
            title: Text(
              'Logout',
              style: TextStyle(
                fontSize: 16,
                color: Theme.of(context).primaryColor,
              ),
            ),
            onTap: () {
              auth.signOut().then((value) {
                googleSignIn.signOut();
              });
            },
          ),
          SizedBox(
            height: 20,
          ),
        ],
      ),
    );
  }
}
