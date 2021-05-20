import 'package:captionsocial/screens/my_caption_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:captionsocial/providers/categories.dart';
import 'package:captionsocial/providers/posts.dart';

class AddCaptionScreen extends StatefulWidget {
  static const routeName = 'add-caption_screen';

  @override
  _AddCaptionScreenState createState() => _AddCaptionScreenState();
}

class _AddCaptionScreenState extends State<AddCaptionScreen> {
  final FirebaseAuth auth = FirebaseAuth.instance;

  List<CategoryItem> _categories = [];
  var captionText = '';
  var categoryId = '';
  final _form = GlobalKey<FormState>();
  final _focusNode = FocusNode();

  @override
  void initState() {
    _categories = Provider.of<Categories>(context, listen: false).categories;
    super.initState();
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  void _saveForm() {
    var isValid = _form.currentState.validate();
    if (!isValid) {
      return;
    }
    _form.currentState.save();

    if (captionText.isNotEmpty) {
      categoryId = categoryId.isNotEmpty ? categoryId : _categories[0].id;
      var categorySlug =
          _categories.firstWhere((element) => element.id == categoryId).slug;
      Provider.of<Posts>(context, listen: false)
          .addUserCaption(
              captionText, categoryId, categorySlug, auth.currentUser.uid)
          .then((value) {
        categoryId = '';
        _form.currentState.reset();
        FocusScope.of(context).requestFocus(new FocusNode());
        showDialog(
          barrierDismissible: false,
          context: context,
          builder: (ctx) => AlertDialog(
            title: Text('Caption Added'),
            content: Text(
                'Thanks for your contribution. Your caption is submitted for review.'),
            actions: <Widget>[
              FlatButton(
                  onPressed: () {
                    //Navigator.of(context).pop();
                    Navigator.of(context).pushReplacementNamed(
                      MyCaptionScreen.routeName,
                      arguments: {
                        'userId': auth.currentUser.uid,
                      },
                    );
                  },
                  child: Text('Okay'))
            ],
          ),
        );
      }).catchError((error) {
        showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
            title: Text('An error occurred!'),
            content: Text('Something went wrong!'),
            actions: <Widget>[
              FlatButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text('Okay'))
            ],
          ),
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          'Add Captions',
        ),
      ),
      body: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () {
          FocusScope.of(context).requestFocus(new FocusNode());
        },
        child: Container(
          margin: EdgeInsets.only(
            top: 40,
            right: 20,
            left: 20,
          ),
          child: Form(
            key: _form,
            child: Column(
              children: <Widget>[
                TextFormField(
                  decoration: InputDecoration(
                    labelText: 'Caption',
                    floatingLabelBehavior: FloatingLabelBehavior.always,
                    border: OutlineInputBorder(),
                    hintText: 'Enter your caption here',
                  ),
                  onFieldSubmitted: (value) {
                    FocusScope.of(context).requestFocus(new FocusNode());
                  },
                  maxLines: 4,
                  keyboardType: TextInputType.multiline,
                  onSaved: (newValue) {
                    captionText = newValue;
                  },
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'Please enter caption';
                    }
                    return null;
                  },
                ),
                SizedBox(
                  height: 30,
                ),
                _categories.length > 0
                    ? DropdownButtonFormField(
                        isDense: true,
                        items: _categories.map((dynamic category) {
                          return new DropdownMenuItem(
                            value: category.id,
                            child: Row(
                              children: <Widget>[
                                Text(category.name),
                              ],
                            ),
                          );
                        }).toList(),
                        onChanged: (newValue) {
                          categoryId = newValue;
                          FocusScope.of(context).requestFocus(new FocusNode());
                        },
                        value: _categories[0].id,
                        decoration: InputDecoration(
                          contentPadding: EdgeInsets.fromLTRB(10, 20, 10, 20),
                          border: OutlineInputBorder(),
                          hintText: 'Select Category',
                          labelText: 'Select Category',
                          floatingLabelBehavior: FloatingLabelBehavior.always,
                        ),
                      )
                    : Container(),
                SizedBox(
                  height: 30,
                ),
                MaterialButton(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  minWidth: MediaQuery.of(context).size.width * 0.30,
                  color: Theme.of(context).primaryColor,
                  height: 45,
                  onPressed: () {
                    //save form
                    _saveForm();
                  },
                  child: Container(
                    width: double.infinity,
                    child: Text(
                      'Submit',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.white,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
