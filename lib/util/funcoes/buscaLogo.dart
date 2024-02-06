import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

class FirebaseImage extends StatefulWidget {
  final String imagePath;
  
  FirebaseImage({
    required this.imagePath,
    
  });

  @override
  _FirebaseImageState createState() => _FirebaseImageState();
}

class _FirebaseImageState extends State<FirebaseImage> {
  String imageUrl = '';

  @override
  void initState() {
    super.initState();
    loadImage();
  }

  Future<void> loadImage() async {
    final storage = firebase_storage.FirebaseStorage.instance;
    var reference = storage.ref().child(widget.imagePath);
    final url = await reference.getDownloadURL();
    setState(() {
      imageUrl = url;
    });
  }

  @override
  Widget build(BuildContext context) {
 return Container(
  height: MediaQuery.of(context).size.width * 0.15,
          width: MediaQuery.of(context).size.width * 0.15,
  child: imageUrl.isNotEmpty
      ? Image.network(
          imageUrl,
          fit: BoxFit.cover,
        )
      : CircularProgressIndicator(),
);

  }
}
