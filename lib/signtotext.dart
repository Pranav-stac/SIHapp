import 'dart:async';
import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'texttosign.dart';
import 'tutorials.dart';
import 'homescreen.dart';

List<CameraDescription> cameras = [];

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    cameras = await availableCameras();
    print('Cameras found: ${cameras.length}');
    for (var camera in cameras) {
      print('Camera: ${camera.name}, ${camera.lensDirection}');
    }
  } on CameraException catch (e) {
    print('Error in fetching cameras: ${e.code}, ${e.description}');
  } catch (e) {
    print('Unexpected error: $e');
  }

  runApp(MaterialApp(
    theme: ThemeData.dark(),
    home: SignToTextScreen(),
  ));
}

class SignToTextScreen extends StatefulWidget {
  const SignToTextScreen({Key? key}) : super(key: key);

  @override
  _SignToTextScreenState createState() => _SignToTextScreenState();
}

class _SignToTextScreenState extends State<SignToTextScreen> {
  final ImagePicker _picker = ImagePicker();
  XFile? _image;
  int _selectedIndex = 2;
  bool _camerasAvailable = false;

  @override
  void initState() {
    super.initState();
    _checkCameras();
  }

  Future<void> _checkCameras() async {
    try {
      final cameraPermission = await Permission.camera.status;
      if (!cameraPermission.isGranted) {
        final result = await Permission.camera.request();
        if (result.isGranted) {
          cameras = await availableCameras();
        }
      } else {
        cameras = await availableCameras();
      }
      setState(() {
        _camerasAvailable = cameras.isNotEmpty;
      });
      print('Cameras available: $_camerasAvailable');
    } catch (e) {
      print('Error checking cameras: $e');
    }
  }

  Future<void> _openCamera() async {
    print("Open Camera button pressed"); // Add this line
    if (!_camerasAvailable) {
      print("No cameras available");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('No cameras available on this device.')),
      );
      return;
    }

    try {
      print("Attempting to open camera");
      await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => TakePictureScreen(
            camera: cameras.first,
            cameras: cameras,
          ),
        ),
      );
      print("Camera screen closed");
    } catch (e) {
      print('Error opening camera: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to open camera: $e')),
      );
    }
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    switch (index) {
      case 0:
        _navigateToScreen(const HomeScreen());
        break;
      case 1:
        _navigateToScreen(const TextToSignScreen());
        break;
      case 2:
        _navigateToScreen(const SignToTextScreen());
        break;
      case 3:
        _navigateToScreen(const TutorialsScreen());
        break;
    }
  }

  void _navigateToScreen(Widget screen) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => screen),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sign to Text'),
        automaticallyImplyLeading: false,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton.icon(
              onPressed: () {
                print("Button pressed"); // Add this line
                _openCamera();
              },
              icon: Icon(Icons.camera_alt),
              label: Text('Open Camera'),
            ),
            if (!_camerasAvailable)
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text('No cameras available on this device.'),
              ),
            const SizedBox(height: 20),
            _image == null
                ? Text('No image captured.')
                : Image.file(File(_image!.path)),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.text_fields),
            label: 'Text to Sign',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.gesture),
            label: 'Sign to Text',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.book),
            label: 'Tutorials',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.green,
        unselectedItemColor:
            const Color.fromARGB(255, 0, 0, 0).withOpacity(0.6),
        onTap: _onItemTapped,
      ),
    );
  }
}

class TakePictureScreen extends StatefulWidget {
  final CameraDescription camera;
  final List<CameraDescription> cameras;

  const TakePictureScreen({
    Key? key,
    required this.camera,
    required this.cameras,
  }) : super(key: key);

  @override
  TakePictureScreenState createState() => TakePictureScreenState();
}

class TakePictureScreenState extends State<TakePictureScreen> {
  late CameraController _controller;
  Future<void>? _initializeControllerFuture;
  late CameraDescription _currentCamera;
  final TextEditingController _textController = TextEditingController();

  @override
  void initState() {
    super.initState();
    print("TakePictureScreen initialized");
    _currentCamera = widget.camera;
    _initializeCameraController(_currentCamera);
  }

  Future<void> _initializeCameraController(
      CameraDescription cameraDescription) async {
    print("Initializing camera controller");
    await Future.delayed(Duration(milliseconds: 100)); // Add a small delay
    _controller = CameraController(
      cameraDescription,
      ResolutionPreset.medium,
    );
    try {
      _initializeControllerFuture = _controller.initialize();
      await _initializeControllerFuture;
      print("Camera controller initialized");
      if (mounted) {
        setState(() {});
      }
    } catch (e) {
      print("Error initializing camera controller: $e");
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    _textController.dispose();
    super.dispose();
  }

  void _switchCamera() {
    final newCamera = widget.cameras.firstWhere(
      (camera) => camera.lensDirection != _currentCamera.lensDirection,
    );
    _initializeCameraController(newCamera);
    setState(() {
      _currentCamera = newCamera;
    });
  }

  void _updateText(String text) {
    setState(() {
      _textController.text = text;
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final double cameraHeight = size.height / 2;

    return Scaffold(
      appBar: AppBar(title: const Text('Take a picture')),
      body: Column(
        children: [
          if (_initializeControllerFuture != null)
            FutureBuilder<void>(
              future: _initializeControllerFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  return Center(
                    child: SizedBox(
                      width: size.width,
                      height: cameraHeight,
                      child: CameraPreview(_controller),
                    ),
                  );
                } else {
                  return const Center(child: CircularProgressIndicator());
                }
              },
            )
          else
            Center(child: Text('Initializing camera...')),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _textController,
              readOnly: true,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Word translated goes here',
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            onPressed: _switchCamera,
            child: const Icon(Icons.flip_camera_android),
          ),
          const SizedBox(height: 10),
          FloatingActionButton(
            onPressed: () async {
              try {
                if (_initializeControllerFuture != null) {
                  await _initializeControllerFuture;
                  final image = await _controller.takePicture();

                  if (!mounted) return;

                  await Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => DisplayPictureScreen(
                        imagePath: image.path,
                      ),
                    ),
                  );

                  _updateText('Picture taken');
                } else {
                  _updateText('Camera not initialized');
                }
              } catch (e) {
                print(e);
                _updateText('Error: ${e.toString()}');
              }
            },
            child: const Icon(Icons.camera_alt),
          ),
          const SizedBox(height: 10),
          FloatingActionButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Icon(Icons.close),
          ),
        ],
      ),
    );
  }
}

class DisplayPictureScreen extends StatelessWidget {
  final String imagePath;

  const DisplayPictureScreen({Key? key, required this.imagePath})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Display the Picture')),
      body: Image.file(File(imagePath)),
    );
  }
}
