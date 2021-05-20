import 'dart:io';
import 'dart:ui';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:image_picker/image_picker.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:screenshot/screenshot.dart';

class CreateCard extends StatefulWidget {
  String title;
  final ScreenshotController screenshotController;

  CreateCard(this.title, this.screenshotController);

  @override
  _CreateCardState createState() => _CreateCardState();
}

class _CreateCardState extends State<CreateCard> {
  int _currentSettingIndex = 0;
  double _opacitySliderValue = 0.3;
  double _blurSliderValue = 0.0;
  File _imageFile;
  final picker = ImagePicker();
  Color firstColor = Colors.blueGrey;
  Color secondColor = Colors.blueGrey;
  Color firstBgColor = Colors.blueGrey;
  Color secondBgColor = Colors.blueGrey;
  Color firstGradientColor = Color(0xFF61045f);
  Color secondGradientColor = Color(0xFFaa076b);
  Color pickerColor = Colors.blueGrey;
  Color textColor = Colors.white;
  String _font = 'Roboto';
  FontWeight _fontWeight = FontWeight.normal;
  FontStyle _isItalic = FontStyle.normal;
  static const _fonts = [
    'Aclonica',
    'Bungee Inline',
    'Bungee Shade',
    'Cabin Sketch',
    'Caesar Dressing',
    'Caveat',
    'Domine',
    'Faster One',
    'Italianno',
    'Lato',
    'Lobster',
    'Monoton',
    'Montserrat Subrayada',
    'Norican',
    'Parisienne',
    'Quantico',
    'Racing Sans One',
    'Roboto',
    'Sacramento',
    'Tangerine',
    'Teko',
    'Ubuntu',
    'Zilla Slab Highlight',
  ];

  Offset offset = Offset.zero;
  double scale = 0.0;
  double _scaleFactor = 1.0;
  double _baseScaleFactor = 1.0;

  bool _isEditingText = false;
  bool stroke = false;
  TextEditingController _editingController;
  @override
  void initState() {
    super.initState();
    _editingController = TextEditingController(text: widget.title);
  }

  @override
  void dispose() {
    _editingController.dispose();
    super.dispose();
  }

// ValueChanged<Color> callback
  void changeBgColor(Color color) {
    setState(() {
      pickerColor = color;
      firstColor = pickerColor;
      secondColor = pickerColor;
      firstBgColor = pickerColor;
      secondBgColor = pickerColor;
    });
  }

  void changeFirstGradientColor(Color color) {
    setState(() {
      firstGradientColor = color;
      firstColor = firstGradientColor;
    });
  }

  void changeSecondGradientColor(Color color) {
    setState(() {
      secondGradientColor = color;
      secondColor = secondGradientColor;
    });
  }

  void changeTextColor(Color color) {
    setState(() {
      textColor = color;
    });
  }

  Future getImage(source) async {
    final pickedFile = await picker.getImage(source: source);

    setState(() {
      _imageFile = File(pickedFile.path);
      _currentSettingIndex = 2;
      firstColor = Color(0xFF000000);
      secondColor = Color(0xFF000000);
      firstBgColor = Color(0xFF000000);
      secondBgColor = Color(0xFF000000);
    });
  }

  List<bool> isSelected = [true, false];

  Widget getCurrentSetting() {
    if (_currentSettingIndex == 0) {
      return Container(
        height: 40,
        width: MediaQuery.of(context).size.width,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: _fonts.length,
          itemBuilder: (ctx, i) => InkWell(
            onTap: () {
              setState(() {
                _font = _fonts[i];
              });
            },
            child: Container(
              alignment: Alignment.center,
              decoration: BoxDecoration(
                border:
                    _fonts[i] == _font ? null : Border.all(color: Colors.black),
                borderRadius: BorderRadius.circular(6),
                color: _fonts[i] == _font ? Colors.black : Colors.white,
              ),
              padding: EdgeInsets.only(
                left: 10,
                right: 10,
              ),
              margin: EdgeInsets.only(
                right: 10,
              ),
              child: Text(
                _fonts[i],
                style: GoogleFonts.getFont(
                  _fonts[i],
                  textStyle: TextStyle(
                    color: _fonts[i] == _font ? Colors.white : Colors.black,
                    fontSize: 14,
                  ),
                ),
              ),
            ),
          ),
        ),
      );
    } else if (_currentSettingIndex == 1) {
      return Container(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              height: 40,
              child: ToggleButtons(
                color: Theme.of(context).primaryColor,
                fillColor: Theme.of(context).primaryColor,
                selectedColor: Colors.white,
                children: <Widget>[
                  Text('Fill'),
                  Text('Stroke'),
                ],
                onPressed: (int index) {
                  setState(() {
                    stroke = !(index == 0);
                    for (int buttonIndex = 0;
                        buttonIndex < isSelected.length;
                        buttonIndex++) {
                      if (buttonIndex == index) {
                        isSelected[buttonIndex] = true;
                      } else {
                        isSelected[buttonIndex] = false;
                      }
                    }
                  });
                },
                isSelected: isSelected,
              ),
            ),
            ClipOval(
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(width: 1, color: Colors.black54),
                  borderRadius: BorderRadius.circular(50),
                  // color: Colors.blue,
                ),
                child: Container(
                  height: 39,
                  width: 39,
                  decoration: BoxDecoration(
                    border: Border.all(width: 0.1, color: Colors.black54),
                    borderRadius: BorderRadius.circular(50),
                  ),
                  margin: EdgeInsets.all(0),
                  child: IconButton(
                    iconSize: 22,
                    color: Colors.black87,
                    icon: Icon(Icons.colorize),
                    onPressed: () {
                      showTextColorDialog();
                    },
                  ),
                ),
              ),
            ),
            ClipOval(
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(width: 1, color: Colors.black54),
                  borderRadius: BorderRadius.circular(50),
                  // color: Colors.blue,
                ),
                child: Container(
                  height: 39,
                  width: 39,
                  decoration: BoxDecoration(
                    border: Border.all(width: 0.1, color: Colors.black54),
                    borderRadius: BorderRadius.circular(50),
                    color: _fontWeight == FontWeight.bold
                        ? Colors.black
                        : Colors.white,
                  ),
                  margin: EdgeInsets.all(0),
                  child: IconButton(
                    iconSize: 22,
                    color: _fontWeight == FontWeight.bold
                        ? Colors.white
                        : Colors.black,
                    icon: Icon(
                      Icons.format_bold,
                    ),
                    onPressed: () {
                      setState(() {
                        _fontWeight = _fontWeight == FontWeight.normal
                            ? FontWeight.bold
                            : FontWeight.normal;
                      });
                    },
                  ),
                ),
              ),
            ),
            ClipOval(
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(width: 1, color: Colors.black54),
                  borderRadius: BorderRadius.circular(50),
                  // color: Colors.blue,
                ),
                child: Container(
                  height: 39,
                  width: 39,
                  decoration: BoxDecoration(
                    border: Border.all(width: 0.1, color: Colors.black54),
                    borderRadius: BorderRadius.circular(50),
                    color: _isItalic == FontStyle.italic
                        ? Colors.black
                        : Colors.white,
                  ),
                  margin: EdgeInsets.all(0),
                  child: IconButton(
                    iconSize: 22,
                    color: _isItalic == FontStyle.italic
                        ? Colors.white
                        : Colors.black,
                    icon: Icon(
                      Icons.format_italic,
                    ),
                    onPressed: () {
                      setState(() {
                        _isItalic = _isItalic == FontStyle.normal
                            ? FontStyle.italic
                            : FontStyle.normal;
                      });
                    },
                  ),
                ),
              ),
            ),
            ClipOval(
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(width: 1, color: Colors.black54),
                  borderRadius: BorderRadius.circular(50),
                  // color: Colors.blue,
                ),
                child: Container(
                  height: 39,
                  width: 39,
                  decoration: BoxDecoration(
                    border: Border.all(width: 0.1, color: Colors.black54),
                    borderRadius: BorderRadius.circular(50),
                    color: _isEditingText == true ? Colors.black : Colors.white,
                  ),
                  margin: EdgeInsets.all(0),
                  child: IconButton(
                    iconSize: 22,
                    color: _isEditingText == true ? Colors.white : Colors.black,
                    icon: Icon(Icons.edit),
                    onPressed: () {
                      setState(() {
                        _isEditingText = !_isEditingText;
                      });
                    },
                  ),
                ),
              ),
            )
          ],
        ),
      );
    } else if (_currentSettingIndex == 2) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            children: [
              ClipOval(
                child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(width: 1, color: Colors.black54),
                    borderRadius: BorderRadius.circular(50),
                    // color: Colors.blue,
                  ),
                  child: Container(
                    height: 39,
                    width: 39,
                    margin: EdgeInsets.all(0),
                    child: IconButton(
                      iconSize: 22,
                      color: Colors.black87,
                      icon: Icon(Icons.close),
                      onPressed: () {
                        setState(() {
                          _imageFile = null;
                          _currentSettingIndex = 0;
                        });
                      },
                    ),
                  ),
                ),
              ),
            ],
          ),
          Spacer(),
          Container(
            width: 130,
            child: Slider(
              activeColor: Theme.of(context).primaryColor,
              inactiveColor: Theme.of(context).primaryColor.withOpacity(0.5),
              value: _opacitySliderValue,
              min: 0,
              max: 1,
              divisions: 10,
              onChanged: (double value) {
                setState(() {
                  _opacitySliderValue = value;
                });
              },
            ),
          ),
          Container(
            width: 130,
            child: Slider(
              activeColor: Colors.red,
              inactiveColor: Colors.red.withOpacity(0.5),
              value: _blurSliderValue,
              min: 0,
              max: 1,
              divisions: 10,
              onChanged: (double value) {
                setState(() {
                  _blurSliderValue = value;
                });
              },
            ),
          ),
        ],
      );
    } else if (_currentSettingIndex == 3) {
      return Container(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              width: MediaQuery.of(context).size.width * 0.75,
              child: BlockPicker(
                pickerColor: pickerColor,
                onColorChanged: changeBgColor,
                layoutBuilder: (context, colors, child) {
                  return Container(
                    width: double.infinity,
                    height: 40,
                    child: ListView(
                      physics: BouncingScrollPhysics(),
                      scrollDirection: Axis.horizontal,
                      children: colors
                          .map((Color color) => child(color))
                          .toList()
                          .reversed
                          .toList(),
                    ),
                  );
                },
                itemBuilder: (color, isCurrentColor, changeColor) {
                  return Container(
                    margin: EdgeInsets.only(
                      right: 8,
                    ),
                    width: 40,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20.0),
                      color: color,
                    ),
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: changeColor,
                        borderRadius: BorderRadius.circular(20.0),
                        child: AnimatedOpacity(
                          duration: const Duration(milliseconds: 210),
                          opacity: isCurrentColor ? 1.0 : 0.0,
                          child: Icon(
                            Icons.done,
                            color: useWhiteForeground(color)
                                ? Colors.white
                                : Colors.black,
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            ClipOval(
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(width: 1, color: Colors.black54),
                  borderRadius: BorderRadius.circular(50),
                  // color: Colors.blue,
                ),
                child: Container(
                  height: 39,
                  width: 39,
                  margin: EdgeInsets.all(0),
                  child: IconButton(
                    iconSize: 22,
                    color: Colors.black87,
                    icon: Icon(Icons.format_color_fill),
                    onPressed: () {
                      showBgDialog();
                    },
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    } else if (_currentSettingIndex == 4) {
      return Container(
        height: 65,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      width: MediaQuery.of(context).size.width * 0.75,
                      child: BlockPicker(
                        pickerColor: pickerColor,
                        onColorChanged: changeFirstGradientColor,
                        layoutBuilder: (context, colors, child) {
                          return Container(
                            width: double.infinity,
                            height: 30,
                            child: ListView(
                              physics: BouncingScrollPhysics(),
                              scrollDirection: Axis.horizontal,
                              children: colors
                                  .map((Color color) => child(color))
                                  .toList()
                                  .reversed
                                  .toList(),
                            ),
                          );
                        },
                        itemBuilder: (color, isCurrentColor, changeColor) {
                          return Container(
                            margin: EdgeInsets.only(
                              right: 8,
                            ),
                            width: 30,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20.0),
                              color: color,
                            ),
                            child: Material(
                              color: Colors.transparent,
                              child: InkWell(
                                onTap: changeColor,
                                borderRadius: BorderRadius.circular(20.0),
                                child: AnimatedOpacity(
                                  duration: const Duration(milliseconds: 210),
                                  opacity: isCurrentColor ? 1.0 : 0.0,
                                  child: Icon(
                                    Icons.done,
                                    color: useWhiteForeground(color)
                                        ? Colors.white
                                        : Colors.black,
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
                Spacer(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      width: MediaQuery.of(context).size.width * 0.75,
                      child: BlockPicker(
                        pickerColor: pickerColor,
                        onColorChanged: changeSecondGradientColor,
                        layoutBuilder: (context, colors, child) {
                          return Container(
                            width: double.infinity,
                            height: 30,
                            child: ListView(
                              physics: BouncingScrollPhysics(),
                              scrollDirection: Axis.horizontal,
                              children: colors
                                  .map((Color color) => child(color))
                                  .toList(),
                            ),
                          );
                        },
                        itemBuilder: (color, isCurrentColor, changeColor) {
                          return Container(
                            margin: EdgeInsets.only(
                              right: 8,
                            ),
                            width: 30,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20.0),
                              color: color,
                            ),
                            child: Material(
                              color: Colors.transparent,
                              child: InkWell(
                                onTap: changeColor,
                                borderRadius: BorderRadius.circular(20.0),
                                child: AnimatedOpacity(
                                  duration: const Duration(milliseconds: 210),
                                  opacity: isCurrentColor ? 1.0 : 0.0,
                                  child: Icon(
                                    Icons.done,
                                    color: useWhiteForeground(color)
                                        ? Colors.white
                                        : Colors.black,
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ],
            ),
            ClipOval(
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(width: 1, color: Colors.black54),
                  borderRadius: BorderRadius.circular(50),
                  // color: Colors.blue,
                ),
                child: Container(
                  height: 39,
                  width: 39,
                  margin: EdgeInsets.all(0),
                  child: IconButton(
                    iconSize: 22,
                    color: Colors.black87,
                    icon: Icon(Icons.format_color_fill),
                    onPressed: () {
                      showGradientDialog();
                    },
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    }
    return Container(
      child: Text('Setting'),
    );
  }

  void showBgDialog() {
    showDialog(
      context: context,
      child: AlertDialog(
        title: const Text('Pick a color!'),
        content: SingleChildScrollView(
          child: ColorPicker(
            pickerColor: pickerColor,
            onColorChanged: changeBgColor,
            displayThumbColor: true,
            pickerAreaHeightPercent: 0.5,
            showLabel: false,
          ),
        ),
        actions: <Widget>[
          FlatButton(
            child: _imageFile == null
                ? Text('Set Background')
                : Text('Set Opacity Color'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      ),
    );
  }

  showTextColorDialog() {
    showDialog(
      context: context,
      child: AlertDialog(
        title: const Text('Pick a color!'),
        content: SingleChildScrollView(
          child: ColorPicker(
            pickerColor: textColor,
            onColorChanged: changeTextColor,
            displayThumbColor: true,
            pickerAreaHeightPercent: 0.5,
            showLabel: false,
          ),
        ),
        actions: <Widget>[
          FlatButton(
            child: Text('Set Text Color'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      ),
    );
  }

  void showGradientDialog() {
    showDialog(
      context: context,
      child: AlertDialog(
        title: const Text(
          'Pick first color',
          textAlign: TextAlign.left,
          style: TextStyle(
            color: Colors.black,
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
        content: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: MediaQuery.of(context).size.height * 0.3,
                child: ColorPicker(
                  pickerColor: firstGradientColor,
                  onColorChanged: changeFirstGradientColor,
                  displayThumbColor: true,
                  pickerAreaHeightPercent: 0.25,
                  showLabel: false,
                ),
              ),
              Container(
                margin: EdgeInsets.symmetric(vertical: 10),
                child: Text(
                  'Pick second color',
                  textAlign: TextAlign.left,
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              Container(
                height: MediaQuery.of(context).size.height * 0.3,
                child: ColorPicker(
                  pickerColor: secondGradientColor,
                  onColorChanged: changeSecondGradientColor,
                  displayThumbColor: true,
                  pickerAreaHeightPercent: 0.25,
                  showLabel: false,
                ),
              )
            ],
          ),
        ),
        actions: <Widget>[
          FlatButton(
            child: const Text('Cancel'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          FlatButton(
            child: const Text('Set Gradient'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Screenshot(
          controller: widget.screenshotController,
          child: Stack(
            children: [
              Container(
                height: MediaQuery.of(context).size.height - 240,
                margin: EdgeInsets.only(
                  top: 10,
                  left: 20,
                  right: 20,
                  bottom: 0,
                ),
                decoration: BoxDecoration(
                  image: _imageFile != null
                      ? DecorationImage(
                          fit: BoxFit.cover,
                          image: FileImage(_imageFile),
                        )
                      : null,
                  borderRadius: BorderRadius.circular(10),
                  gradient: LinearGradient(
                    colors: [firstColor, secondColor],
                    begin: const FractionalOffset(0.0, 0.0),
                    end: const FractionalOffset(1.0, 0.0),
                    stops: [0.0, 1.0],
                    tileMode: TileMode.clamp,
                  ),
                ),
                child: _imageFile == null
                    ? null
                    : ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: BackdropFilter(
                          filter: ImageFilter.blur(
                              sigmaX: _blurSliderValue * 5,
                              sigmaY: _blurSliderValue * 5),
                          child: Container(
                            alignment: Alignment.center,
                            color:
                                firstBgColor.withOpacity(_opacitySliderValue),
                          ),
                        ),
                      ),
              ),
              Container(
                child: Positioned(
                  left: offset.dx,
                  top: offset.dy,
                  child: GestureDetector(
                      behavior: HitTestBehavior.translucent,
                      onScaleStart: (details) {
                        _baseScaleFactor = _scaleFactor;
                      },
                      onScaleUpdate: (details) {
                        setState(() {
                          _scaleFactor = _baseScaleFactor * details.scale;
                        });
                      },
                      onLongPressMoveUpdate: (details) {
                        setState(() {
                          offset = Offset(details.offsetFromOrigin.dx,
                              details.offsetFromOrigin.dy);
                        });
                      },
                      onTap: () {
                        setState(() {
                          _isEditingText = false;
                        });
                      },
                      onDoubleTap: () {
                        setState(() {
                          _isEditingText = !_isEditingText;
                        });
                      },
                      child: SizedBox(
                        width: MediaQuery.of(context).size.width - 20,
                        height: MediaQuery.of(context).size.height - 200,
                        child: Padding(
                          padding: EdgeInsets.only(
                            top: 20,
                            left: 40,
                            right: 40,
                            bottom: 55,
                          ),
                          child: Center(
                            child: (_isEditingText)
                                ? Center(
                                    child: TextField(
                                      //expands: true,
                                      keyboardType: TextInputType.multiline,
                                      minLines: 2,
                                      maxLines: 5,
                                      style: TextStyle(
                                        fontSize: 20,
                                        color: Colors.white,
                                      ),
                                      onChanged: (val) {
                                        widget.title = val;
                                      },
                                      onSubmitted: (newValue) {
                                        setState(() {
                                          widget.title = newValue;
                                          _isEditingText = false;
                                        });
                                      },
                                      autofocus: true,
                                      controller: _editingController,
                                    ),
                                  )
                                : AutoSizeText.rich(
                                    TextSpan(
                                      text: widget.title,
                                    ),
                                    minFontSize: 16,
                                    textScaleFactor: _scaleFactor,
                                    style: GoogleFonts.getFont(_font,
                                        textStyle: TextStyle(
                                          // shadows: <Shadow>[
                                          //   Shadow(
                                          //     offset: Offset(-5.0, 0.0),
                                          //     blurRadius: 3.0,
                                          //     color: Color.fromARGB(255, 0, 0, 0),
                                          //   ),
                                          // ],
                                          fontSize: 30,
                                          fontWeight: _fontWeight,
                                          fontStyle: _isItalic,
                                          foreground: Paint()
                                            ..style = stroke == true
                                                ? PaintingStyle.stroke
                                                : PaintingStyle.fill
                                            ..strokeWidth = 1
                                            ..color = textColor,
                                        )),
                                  ),
                          ),
                        ),
                      )),
                ),
              ),
              Positioned(
                bottom: MediaQuery.of(context).size.height -
                    (MediaQuery.of(context).size.height - 10),
                right: 35,
                child: Text(
                  'Caption Cards',
                  style: TextStyle(
                    fontSize: 14,
                    fontStyle: FontStyle.italic,
                    color: Colors.white38,
                  ),
                ),
              ),
            ],
          ),
        ),
        Container(
          margin: EdgeInsets.only(
            bottom: 0,
            left: 20,
            right: 20,
          ),
          child: getCurrentSetting(),
        ),
        Container(
          margin: EdgeInsets.only(
            left: 20,
            right: 20,
            bottom: 10,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ClipOval(
                child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(
                      width: 1,
                      color: _currentSettingIndex == 0
                          ? Theme.of(context).primaryColor
                          : Colors.black,
                    ),
                    borderRadius: BorderRadius.circular(50),
                    // color: Colors.blue,
                  ),
                  child: Container(
                    height: 39,
                    width: 39,
                    margin: EdgeInsets.all(0),
                    child: IconButton(
                      iconSize: 22,
                      color: _currentSettingIndex == 0
                          ? Theme.of(context).primaryColor
                          : Colors.black,
                      icon: Icon(Icons.text_format),
                      onPressed: () {
                        setState(() {
                          _currentSettingIndex = 0;
                        });
                      },
                    ),
                  ),
                ),
              ),
              ClipOval(
                child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(
                      width: 1,
                      color: _currentSettingIndex == 1
                          ? Theme.of(context).primaryColor
                          : Colors.black,
                    ),
                    borderRadius: BorderRadius.circular(50),
                    // color: Colors.blue,
                  ),
                  child: Container(
                    height: 39,
                    width: 39,
                    margin: EdgeInsets.all(0),
                    child: IconButton(
                      iconSize: 22,
                      color: _currentSettingIndex == 1
                          ? Theme.of(context).primaryColor
                          : Colors.black,
                      icon: Icon(Icons.font_download),
                      onPressed: () {
                        setState(() {
                          _currentSettingIndex = 1;
                        });
                      },
                    ),
                  ),
                ),
              ),
              ClipOval(
                child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(
                      width: 1,
                      color: _currentSettingIndex == 2
                          ? Theme.of(context).primaryColor
                          : Colors.black,
                    ),
                    borderRadius: BorderRadius.circular(50),
                    // color: Colors.blue,
                  ),
                  child: _imageFile == null
                      ? Container(
                          height: 39,
                          width: 39,
                          margin: EdgeInsets.all(0),
                          child: IconButton(
                            iconSize: 22,
                            padding: EdgeInsets.all(0),
                            color: _currentSettingIndex == 2
                                ? Theme.of(context).primaryColor
                                : Colors.black,
                            icon: Icon(Icons.insert_photo),
                            onPressed: () {
                              getImage(ImageSource.gallery);
                            },
                          ),
                        )
                      : Container(
                          height: 39,
                          width: 39,
                          margin: EdgeInsets.all(0),
                          child: IconButton(
                            iconSize: 22,
                            color: _currentSettingIndex == 2
                                ? Theme.of(context).primaryColor
                                : Colors.black,
                            icon: Icon(Icons.insert_photo),
                            onPressed: () {
                              setState(() {
                                _currentSettingIndex = 2;
                              });
                            },
                          ),
                        ),
                ),
              ),
              InkWell(
                onTap: () {
                  setState(() {
                    _currentSettingIndex = 3;
                  });
                  // showBgDialog();
                },
                child: Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(50),
                    gradient: LinearGradient(
                      colors: [
                        firstBgColor,
                        secondBgColor,
                      ],
                      begin: const FractionalOffset(0.0, 0.0),
                      end: const FractionalOffset(1.0, 0.0),
                      stops: [0.0, 1.0],
                      tileMode: TileMode.clamp,
                    ),
                  ),
                ),
              ),
              InkWell(
                onTap: () {
                  if (_imageFile == null) {
                    setState(() {
                      _currentSettingIndex = 4;
                    });
                    // showGradientDialog();
                  } else {
                    final snackBar = SnackBar(
                      duration: Duration(
                        seconds: 2,
                      ),
                      content: Text('Remove image to apply gradient!'),
                    );
                    Scaffold.of(context).showSnackBar(snackBar);
                  }
                },
                child: Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(50),
                    gradient: LinearGradient(
                      colors: [
                        firstGradientColor,
                        secondGradientColor,
                      ],
                      begin: const FractionalOffset(0.0, 0.0),
                      end: const FractionalOffset(1.0, 0.0),
                      stops: [0.0, 1.0],
                      tileMode: TileMode.clamp,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
