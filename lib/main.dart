import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';
import 'package:flutter/services.dart';

import 'package:captionsocial/providers/categories.dart';
import 'package:captionsocial/providers/posts.dart';
import 'package:captionsocial/providers/user.dart';

import 'package:captionsocial/screens/auth_screen.dart';
import 'package:captionsocial/screens/home_screen.dart';
import 'package:captionsocial/screens/user_favourites_screen.dart';
import 'package:captionsocial/screens/category_detail_screen.dart';
import 'package:captionsocial/screens/create_card_screen.dart';
import 'package:captionsocial/screens/add_caption_screen.dart';
import 'package:captionsocial/screens/my_caption_screen.dart';
import 'package:captionsocial/screens/search_screen.dart';
import 'package:captionsocial/screens/privacy_policy_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (ctx) => Categories(),
        ),
        ChangeNotifierProvider(
          create: (ctx) => Posts(),
        ),
        ChangeNotifierProvider(
          create: (ctx) => Users(),
        ),
      ],
      child: MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Caption Cards',
          theme: ThemeData(
            primaryColor: Colors.indigo[700],
            accentColor: Colors.indigoAccent,
            toggleableActiveColor: Colors.amber[300],
            visualDensity: VisualDensity.adaptivePlatformDensity,
          ),
          home: StreamBuilder(
            stream: FirebaseAuth.instance.authStateChanges(),
            builder: (ctx, userSnapshot) {
              if (userSnapshot.connectionState == ConnectionState.waiting) {
                return Scaffold(
                  body: Center(
                    child: CircularProgressIndicator(),
                  ),
                );
              }
              if (userSnapshot.hasData) {
                return HomeScreen();
              }
              return AuthScreen();
            },
          ),
          routes: {
            CategoryDetailScreen.routeName: (ctx) => CategoryDetailScreen(),
            CreateCardScreen.routeName: (ctx) => CreateCardScreen(),
            UserFavouritesScreen.routeName: (ctx) => UserFavouritesScreen(),
            AddCaptionScreen.routeName: (ctx) => AddCaptionScreen(),
            MyCaptionScreen.routeName: (ctx) => MyCaptionScreen(),
            SearchScreen.routeName: (ctx) => SearchScreen(),
            PrivacyPolicyScreen.routeName: (ctx) => PrivacyPolicyScreen(),
          }),
    );
  }
}
