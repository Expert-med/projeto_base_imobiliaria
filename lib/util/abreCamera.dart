import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:permission_handler/permission_handler.dart';

class CameraScreen extends StatefulWidget {
  final List<CameraDescription> cameras;

  const CameraScreen({Key? key, required this.cameras}) : super(key: key);

  @override
  _CameraScreenState createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> {
  late CameraController _controller;
  late Future<void> _cameraInitializer;
  int _currentCameraIndex = 0; // Index of the currently selected camera

  @override
  void initState() {
    super.initState();
    _initializeCamera();
  }

  Future<void> _initializeCamera() async {
    _controller = CameraController(widget.cameras[_currentCameraIndex], 
     /// 480p (640x480 on iOS, 720x480 on Android)
    ResolutionPreset.medium);
    _cameraInitializer = _controller.initialize();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _toggleCamera() async {
    // Switch to the other camera
    _currentCameraIndex = (_currentCameraIndex + 1) % widget.cameras.length;

    await _controller.dispose(); // Dispose of the current controller
    _initializeCamera(); // Initialize a new controller with the updated camera index
    setState(() {}); // Trigger a rebuild
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Camera'),
      ),
      body: FutureBuilder<void>(
        future: _cameraInitializer,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return Center(
              child: CameraPreview(_controller),
            );
          } else {
            return Center(child: CircularProgressIndicator());
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.camera),
        onPressed: () async {
          if (_controller.value.isInitialized) {
            final XFile takenImage = await _controller.takePicture();
            Navigator.pop(context, takenImage);
          }
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      // Add a button to toggle between front and rear cameras
      persistentFooterButtons: [
        ElevatedButton(
          onPressed: _toggleCamera,
          child: Icon(Icons.switch_camera),
        ),
      ],
    );
  }
}
