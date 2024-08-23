import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  File? _image;
  Uint8List? _serverImage;
  String? _disease;

  Future<void> _captureImage() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.camera);

    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
        _serverImage = null;
      });
    }
  }

  Future<void> _selectImageFromGallery() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
        _serverImage = null;
      });
    }
  }

  Future<void> _uploadImage(File imageFile) async {
    final uri = Uri.parse('http://192.168.100.57:5000/image');
    final request = http.MultipartRequest('POST', uri)
      ..files.add(await http.MultipartFile.fromPath('image', imageFile.path));

    try {
      final response = await request.send();

      if (response.statusCode == 200) {
        final bytes = await response.stream.toBytes();
        setState(() {
          _serverImage = bytes;
        });
        print('Berhasil kirim ke server');
      } else {
        print('Gagal, status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error $e');
    }
  }

  Future<void> detectDisease() async {
    try {
      final uri = Uri.parse('http://192.168.100.57:5000/detections/');
      final response = await http.post(uri);
      if (response.statusCode == 200) {
        final result = jsonDecode(response.body);
        setState(() {
          _disease = result['detection']['class'];
        });
      } else {
        print('Gagal, status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF34a203),
        title: const Text(
          'LeafGuru',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (_serverImage != null)
              Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 20),
                    child: Image.memory(
                      _serverImage!,
                      height: 300,
                      width: 300,
                      fit: BoxFit.cover,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: Text(_disease!),
                  )
                ],
              )
            else if (_image != null)
              Padding(
                padding: const EdgeInsets.only(top: 20),
                child: Image.file(
                  _image!,
                  height: 300,
                  width: 300,
                  fit: BoxFit.cover,
                ),
              )
            else
              Padding(
                padding: const EdgeInsets.only(top: 20),
                child: Column(
                  children: [
                    Image.asset(
                      'assets/image/notfound.png',
                      height: 300,
                      width: 300,
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    const Text(
                      'Belum ada yang di-upload!',
                      style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 16,
                          color: Color(0xFF34a203)),
                    ),
                  ],
                ),
              ),
            const Spacer(),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(
                    height: 50,
                    width: 150,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF34a203)),
                      onPressed: _captureImage,
                      child: const Row(
                        children: [
                          Icon(
                            Icons.camera,
                            size: 20,
                            color: Colors.white,
                          ),
                          SizedBox(width: 8),
                          Text(
                            'Camera',
                            style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: Colors.white),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 50,
                    width: 150,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF34a203)),
                      onPressed: _selectImageFromGallery,
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.photo_library,
                            size: 20,
                            color: Colors.white,
                          ),
                          SizedBox(width: 8),
                          Text(
                            'Gallery',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            if (_image != null)
              SizedBox(
                height: 50,
                width: 150,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF34a203)),
                  onPressed: () {
                    _uploadImage(_image!);
                  },
                  child: const Row(
                    children: [
                      Icon(
                        Icons.search,
                        size: 20,
                        color: Colors.white,
                      ),
                      SizedBox(width: 8),
                      Text(
                        'Deteksi',
                        style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Colors.white),
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
