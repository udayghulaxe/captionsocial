import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

import 'package:captionsocial/providers/posts.dart';

import '../widgets/app_drawer.dart';
import 'package:captionsocial/screens/categories_screen.dart';
import 'package:captionsocial/screens/suggestions_screen.dart';
import 'package:captionsocial/screens/userprofile_screen.dart';
import 'package:captionsocial/screens/search_screen.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  int _currentIndex = 0;

  final _tab = [
    CategoryScreen(),
    SuggestionsScreen(),
    UserProfileScreen(),
  ];

  @override
  void initState() {
    final fbm = FirebaseMessaging();
    fbm.configure(
      onMessage: (message) {
        print(message);
        return;
      },
      onLaunch: (message) {
        print(message);
        return;
      },
      onResume: (message) {
        print(message);
        return;
      },
    );
    super.initState();
  }

  gotoPage(tabIndex) {
    setState(() {
      _currentIndex = tabIndex;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.white,
      drawer: AppDrawer(gotoPage),
      appBar: _currentIndex == 2
          ? null
          : AppBar(
              centerTitle: true,
              title: Text(
                'Caption Cards',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.black,
                ),
              ),
              actions: <Widget>[
                IconButton(
                  icon: Icon(
                    Icons.search,
                    color: Theme.of(context).primaryColor,
                  ),
                  onPressed: () {
                    Provider.of<Posts>(context, listen: false)
                        .userSearchedPosts = [];
                    Navigator.of(context).pushNamed(
                      SearchScreen.routeName,
                    );
                  },
                ),
              ],
              leading: IconButton(
                  icon: Icon(
                    Icons.menu,
                    color: Theme.of(context).primaryColor,
                  ),
                  onPressed: () => _scaffoldKey.currentState.openDrawer()),
              backgroundColor: Colors.white,
              elevation: 0,
            ),
      body: _tab[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.white38,
        backgroundColor: Theme.of(context).primaryColor.withOpacity(0.9),
        iconSize: 24,
        elevation: 10,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        currentIndex: _currentIndex,
        items: [
          BottomNavigationBarItem(
            title: Text('Categories'),
            icon: Icon(
              Icons.view_list,
            ),
          ),
          BottomNavigationBarItem(
            title: Text('Suggestions'),
            icon: Icon(
              Icons.camera_enhance,
            ),
          ),
          BottomNavigationBarItem(
            title: Text('Profile'),
            icon: Icon(
              Icons.account_circle,
            ),
          ),
        ],
      ),
    );
  }
}
