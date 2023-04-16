import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gallery_saver/gallery_saver.dart';
// import 'package:gallery_saver/gallery_saver.dart';
import 'package:webinarprime/screens/create_banner_screens/create_banner_drawer.dart';
import 'dart:io';
import 'package:screenshot/screenshot.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:webinarprime/utils/app_constants.dart';

class CreateBannerScreen extends StatefulWidget {
  bool customBanner;
  CreateBannerScreen(
      {required this.customBanner, required this.backgroundImage, super.key});
  String backgroundImage;

  @override
  State<CreateBannerScreen> createState() => _CreateBannerScreenState();
}

class _CreateBannerScreenState extends State<CreateBannerScreen> {
  final List<Widget> _widgets = [];
  ScreenshotController screenshotController = ScreenshotController();

  void addNewTextWidget(String text) {
    print('addNewTextWidget');
    print(widget.customBanner);
    print(text);
    setState(() {
      _widgets.add(DraggableTextWidget(
        text: text,
        key: UniqueKey(),
      ));
    });
    setState(() {});
    print(_widgets.length);
  }

  void removeWidget(key) {
    print('removeWidget in create banner screen');
    // print(key);
    setState(() {
      _widgets.removeWhere((widget) => widget.key == key);
    });
  }

  void addImageWidget(String imageURL, bool isURlImage) {
    print('addImageWidget');
    print(imageURL);
    setState(() {
      _widgets.add(DraggableImageWidget(
        key: UniqueKey(),
        imageURl: imageURL,
        isURLImage: isURlImage,
      ));
    });
    setState(() {});
    print(_widgets.length);
  }

  Future<void> captureAndSaveScreenshot() async {
    try {
      final imageBytes = await screenshotController.capture();
      // final directory = await getTemporaryDirectory();
      final directory = await getApplicationDocumentsDirectory();

      final filePath = '${directory.path}/screenshot.png';

      if (imageBytes != null && imageBytes.isNotEmpty) {
        final file = File(filePath);
        await file.writeAsBytes(imageBytes);
        await GallerySaver.saveImage(filePath, albumName: 'MyApp');
        print('Screenshot saved to gallery');
        //alert a dialg that screenshot is saved
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Screenshot saved to gallery'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('OK'),
              ),
            ],
          ),
        );
      } else {
        print('Could not capture screenshot');
      }
    } catch (e) {
      print('Error capturing screenshot: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          actions: [
            IconButton(
              onPressed: () async {
                await captureAndSaveScreenshot();
              },
              icon: const Icon(
                Icons.save,
                color: Colors.white,
              ),
            )
          ],
          elevation: 0,
          backgroundColor: Colors.black,
          toolbarHeight: 40,
        ),
        drawer: CreateBannerDrawer(
          customBanner: widget.customBanner,
          addnewTextWidget: addNewTextWidget,
          addnewImageWidget: addImageWidget,
        ),
        body: Screenshot(
          controller: screenshotController,
          child: Container(
            width: double.infinity,
            height: double.infinity,
            decoration: BoxDecoration(
              image: DecorationImage(
                  image: NetworkImage(
                    widget.backgroundImage,
                  ),
                  fit: BoxFit.fill),
            ),
            child: Stack(
              children: [
                ..._widgets,
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class DraggableTextWidget extends StatefulWidget {
  DraggableTextWidget({required this.text, super.key});
  String text;

  @override
  _DraggableTextWidgetState createState() => _DraggableTextWidgetState();
}

class _DraggableTextWidgetState extends State<DraggableTextWidget> {
  @override
  void initState() {
    // TODO: implement initState
    _text = widget.text;
    print('gello');
    super.initState();
  }

  double _xPosition = 100;
  double _yPosition = 100;
  double _fontSize = 20;
  Color _color = Colors.black;
  String? _text;
  FontWeight _fontWeight = FontWeight.bold;

  void UpdateValues(double xPosition, double yPosition, double fontSize,
      Color color, String text, FontWeight fontWeight) {
    setState(() {
      _xPosition = xPosition;
      _yPosition = yPosition;
      _fontSize = fontSize;
      _color = color;
      _text = text;
      _fontWeight = fontWeight;
    });
  }

  void _removeWidget() {
    print('remove');
    print(super.widget.key);
    (context.findAncestorStateOfType<_CreateBannerScreenState>()
            as _CreateBannerScreenState)
        .removeWidget(super.widget.key!);
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: _xPosition,
      top: _yPosition,
      child: GestureDetector(
        onPanUpdate: (dragUpdateDetails) {
          setState(() {
            _xPosition += dragUpdateDetails.delta.dx;
            _yPosition += dragUpdateDetails.delta.dy;
          });
        },
        onTap: () {
          final textController = TextEditingController(text: _text);
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return StatefulBuilder(
                builder: (context, setState) {
                  return AlertDialog(
                    content: SingleChildScrollView(
                      physics: const NeverScrollableScrollPhysics(),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          TextField(
                            controller: textController,
                            onChanged: (text) {},
                            decoration: const InputDecoration(
                              hintText: 'Text',
                            ),
                          ),
                          const SizedBox(height: 16.0),
                          Text(
                            'Font Size : ${_fontSize.toString().split('.')[0]}',
                          ),
                          Slider(
                            min: 10,
                            max: 40,
                            value: _fontSize,
                            onChanged: (value) {
                              setState(() {
                                _fontSize = value;
                              });
                              UpdateValues(_xPosition, _yPosition, _fontSize,
                                  _color, _text!, _fontWeight);
                            },
                          ),
                          const SizedBox(height: 16.0),
                          DropdownButton(
                              value: _fontWeight,
                              items: [
                                //font weights
                                const DropdownMenuItem(
                                  value: FontWeight.bold,
                                  child: Text('Bold',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold)),
                                ),
                                DropdownMenuItem(
                                  onTap: () {
                                    print('normal');
                                    _fontWeight = FontWeight.normal;
                                  },
                                  value: FontWeight.normal,
                                  child: const Text('Normal',
                                      style: TextStyle(
                                          fontWeight: FontWeight.normal)),
                                ),
                                const DropdownMenuItem(
                                  value: FontWeight.w300,
                                  child: Text('Light',
                                      style: TextStyle(
                                          fontWeight: FontWeight.w300)),
                                ),
                                const DropdownMenuItem(
                                  value: FontWeight.w100,
                                  child: Text('Thin',
                                      style: TextStyle(
                                          fontWeight: FontWeight.w100)),
                                ),
                              ],
                              onChanged: (value) {
                                setState(() {
                                  print(value);
                                  _fontWeight = value as FontWeight;
                                });
                                UpdateValues(_xPosition, _yPosition, _fontSize,
                                    _color, _text!, _fontWeight);
                              }),
                          ColorPicker(
                            pickerColor: _color,
                            onColorChanged: (color) {
                              setState(() {
                                _color = color;
                              });
                              UpdateValues(_xPosition, _yPosition, _fontSize,
                                  _color, _text!, _fontWeight);
                            },
                            showLabel: true,
                            pickerAreaHeightPercent: 0.8,
                          ),
                        ],
                      ),
                    ),
                    actions: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          IconButton(
                              onPressed: () {
                                Navigator.pop(context);

                                _removeWidget();
                              },
                              icon: const Icon(
                                Icons.delete,
                                color: Colors.red,
                              )),
                          ElevatedButton(
                            onPressed: () => Navigator.pop(context),
                            child: const Text('Cancel'),
                          ),
                          ElevatedButton(
                            onPressed: () {
                              setState(() {
                                _text = textController.text;
                              });
                              UpdateValues(_xPosition, _yPosition, _fontSize,
                                  _color, _text!, _fontWeight);

                              Navigator.pop(context);
                            },
                            child: const Text('OK'),
                          ),
                        ],
                      ),

                      //remove button
                    ],
                  );
                },
              );
            },
          );
        },
        child: Container(
          constraints: BoxConstraints(
            maxWidth: 1.sw,
            maxHeight: 1.sh,
          ),
          child: AutoSizeText(
            _text!,
            style: TextStyle(
              fontSize: _fontSize,
              fontWeight: _fontWeight,
              color: _color,
              fontFamily: 'JosefinSans Regular',
            ),
            maxLines: 4,
          ),
        ),
      ),
    );
  }
}

class DraggableImageWidget extends StatefulWidget {
  String imageURl;
  bool isURLImage;

  DraggableImageWidget(
      {this.isURLImage = false, this.imageURl = '', super.key});

  @override
  _DraggableImageWidgetState createState() => _DraggableImageWidgetState();
}

class _DraggableImageWidgetState extends State<DraggableImageWidget> {
  // final GlobalKey _key = GlobalKey();
  double _xPosition = 150;
  double _yPosition = 200;
  double _height = 150;
  double _width = 150;
  double _borderRadius = 0;
  File? _image;

  Future _getImage() async {
    final imagePicker = ImagePicker();
    final pickedFile = await imagePicker.getImage(source: ImageSource.gallery);
    setState(() {
      _image = File(pickedFile!.path);
    });
  }

  void updateValues(double height, double width, double borderRadius) {
    setState(() {
      _height = height;
      _width = width;
      _borderRadius = borderRadius;
    });
  }

  void _removeWidget() {
    print('remove');
    print(super.widget.key);
    // var renderBox = _key.currentContext!.findRenderObject() as RenderBox;
    // final offset = renderBox.localToGlobal(Offset.zero);
    // final size = renderBox.size;
    // final boxRect =
    // Rect.fromLTWH(offset.dx, offset.dy, size.width, size.height);
    (context.findAncestorStateOfType<_CreateBannerScreenState>()
            as _CreateBannerScreenState)
        .removeWidget(super.widget.key!);
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: _xPosition,
      top: _yPosition,
      child: GestureDetector(
        onPanUpdate: (dragUpdateDetails) {
          setState(() {
            _xPosition += dragUpdateDetails.delta.dx;
            _yPosition += dragUpdateDetails.delta.dy;
          });
        },
        child: GestureDetector(
          onTap: () {
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return StatefulBuilder(
                  builder: (context, setState) {
                    return AlertDialog(
                      // title: const Text('Add Image'),
                      content: SingleChildScrollView(
                        physics: const NeverScrollableScrollPhysics(),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            if (!widget.isURLImage)
                              ElevatedButton(
                                onPressed: () async {
                                  await _getImage();
                                  setState(() {});
                                },
                                child: const Text('Select Image'),
                              ),
                            const SizedBox(height: 16),
                            Text('Height:${_height.toString().split('.')[0]}'),
                            Slider(
                              min: 50,
                              max: 300,
                              value: _height,
                              onChanged: (value) {
                                setState(() {
                                  _height = value;
                                });
                                updateValues(_height, _width, _borderRadius);
                              },
                            ),
                            const SizedBox(height: 16),
                            Text('Width:${_width.toString().split('.')[0]}'),
                            Slider(
                              min: 50,
                              max: 1.sw,
                              value: _width,
                              onChanged: (value) {
                                setState(
                                  () {
                                    _width = value;
                                  },
                                );
                                updateValues(_height, _width, _borderRadius);
                              },
                            ),
                            const SizedBox(height: 16),
                            Text(
                                'Border Radius:${_borderRadius.toString().split('.')[0]}'),
                            Slider(
                              min: 0,
                              max: 100,
                              value: _borderRadius,
                              onChanged: (value) {
                                setState(() {
                                  _borderRadius = value;
                                });
                                updateValues(_height, _width, _borderRadius);
                              },
                            ),
                            //remove button
                            IconButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                  _removeWidget();

                                  // updateValues(_height, _width, _borderRadius);
                                },
                                icon: const Icon(
                                  Icons.delete,
                                  color: Colors.red,
                                )),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
            );
          },
          child: widget.isURLImage
              ? Container(
                  height: _height,
                  width: _width,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(_borderRadius),
                    image: DecorationImage(
                      image:
                          NetworkImage(AppConstants.baseURL + widget.imageURl),
                      fit: BoxFit.cover,
                    ),
                  ),
                )
              : Container(
                  constraints: BoxConstraints(
                    maxWidth: 1.sw,
                    maxHeight: 1.sh,
                  ),
                  height: _height,
                  width: _width,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(_borderRadius),
                    // image: DecorationImage(
                    // image: _image == null
                    // ?
                    // : FileImage(_image),
                    // fit: BoxFit.cover,
                  ),
                  child: _image == null
                      ? const IconButton(
                          icon: Icon(
                            Icons.add_a_photo,
                            size: 100,
                          ),
                          onPressed: null,
                        )
                      : ClipRRect(
                          borderRadius: BorderRadius.circular(_borderRadius),
                          child: Image.file(
                            _image!,
                            fit: BoxFit.cover,
                          ),
                        ),
                ),
        ),
      ),
    );
  }
}
