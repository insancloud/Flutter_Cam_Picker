import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/rendering.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
// import 'package:path_provider/path_provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final ImagePicker picker = ImagePicker();
  XFile? photo;
   GlobalKey _globalKey = GlobalKey();


  saveLocalImage() async {
    RenderRepaintBoundary boundary =
        _globalKey.currentContext!.findRenderObject() as RenderRepaintBoundary;
    ui.Image image = await boundary.toImage();
    ByteData? byteData =
        await (image.toByteData(format: ui.ImageByteFormat.png));
    if (byteData != null) {
      final result =
          await ImageGallerySaver.saveImage(byteData.buffer.asUint8List());
      print(result);
      // Utils.toast(result.toString());
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Save Succesfully")));
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          "Gallery Picker",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        elevation: 3,
        backgroundColor: Colors.blue[800],
        actions: const [
          Icon(
            Icons.person,
            color: Colors.white,
          ),
          SizedBox(
            width: 8,
          ),
          Icon(
            Icons.settings,
            color: Colors.white,
          ),
          SizedBox(
            width: 8,
          ),
        ],
        leading: const Icon(
          Icons.menu,
          color: Colors.white,
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              RepaintBoundary(
                key: _globalKey,
                child: Container(
                  alignment: Alignment.center,
                  // width: 300,
                  height: 300,
                  color: Colors.blue,
                  child: photo == null
                    ? const SizedBox()
                    : Image.file(File(photo!.path)),
                ),
              ),
              
            ],
          ),
          const SizedBox(
            height: 16,
          ),
          ElevatedButton(
            onPressed: () {
              saveLocalImage();
            },
            child: const Text(
              "Save to Gallery",
              style: TextStyle(color: Colors.blue),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          photo = await picker.pickImage(source: ImageSource.camera);
          setState(() {});
        },
        backgroundColor: Colors.blue[800],
        child: const Icon(
          Icons.camera,
          color: Colors.white,
        ),
      ),
    );
  }
}
