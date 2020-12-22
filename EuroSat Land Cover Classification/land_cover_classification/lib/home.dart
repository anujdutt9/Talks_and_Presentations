// Import Packages
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:tflite/tflite.dart';
import 'package:image_picker/image_picker.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  // Variables
  bool _loading = true;
  // variable to store loaded image
  File _image;
  // variable to store tflite results
  List _output;
  // variable to load image
  final picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    // load TFLite Model
    loadModel().then((value) {
      setState(() {});
    });
  }

  // Function to perform TFLite Inference
  classifyImage(File image) async {
    var output = await Tflite.runModelOnImage(
        path: image.path, numResults: 10, threshold: 0.5, asynch: true);
    setState(() {
      // set our global variable equal to local variable
      _output = output;
      _loading = false;
    });
    print("prediction: $_output");
  }

  // Function to Load Model
  loadModel() async {
    // define model path and labels path
    await Tflite.loadModel(
        model: 'assets/eurosat_model_dynamic_range.tflite',
        labels: 'assets/labels.txt',
        numThreads: 1);
  }

  // Function to dispose and clear mmemory once done inferring
  @override
  void dispose() {
    super.dispose();
    // helps avoid memory leaks
    Tflite.close();
  }

  // Function to pick image - using camera
  pickImage() async {
    // load image from source - camera/gallery
    var image = await picker.getImage(source: ImageSource.camera);
    // check if error laoding image
    if (image == null) return null;
    setState(() {
      _image = File(image.path);
    });

    // classify image
    classifyImage(_image);
  }

  // Function to pick image - using gallery
  pickGalleryImage() async {
    // load image from source - camera/gallery
    var image = await picker.getImage(source: ImageSource.gallery);
    // check if error laoding image
    if (image == null) return null;
    setState(() {
      _image = File(image.path);
    });

    // classify image
    classifyImage(_image);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF101010),
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            SizedBox(height: 80),
            Center(
              child: Text(
                'EuroSat Land Cover Classification',
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: Color(0xFFE99600),
                    fontWeight: FontWeight.w500,
                    fontSize: 28),
              ),
            ),
            SizedBox(
              height: 40,
            ),
            Center(
              child: _loading
                  ? Container(
                      width: 280,
                      child: Column(
                        children: [
                          Image.asset('assets/photo.jpeg'),
                          SizedBox(
                            height: 50,
                          )
                        ],
                      ),
                    )
                  : Container(
                      child: Column(
                        children: [
                          Container(
                            height: 250,
                            child: Image.file(
                              _image,
                              width: 450,
                              height: 450,
                              scale: 0.8,
                            ),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          _output != null
                              ? Text(
                                  'Predicted Label: ${_output[0]['label']}',
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 20),
                                )
                              : Container(),
                          SizedBox(
                            height: 10,
                          )
                        ],
                      ),
                    ),
            ),
            Container(
              width: MediaQuery.of(context).size.width,
              child: Column(
                children: [
                  GestureDetector(
                    onTap: pickImage,
                    child: Container(
                      width: MediaQuery.of(context).size.width - 150,
                      alignment: Alignment.center,
                      padding:
                          EdgeInsets.symmetric(horizontal: 24, vertical: 17),
                      decoration: BoxDecoration(
                        color: Color(0xFFE99600),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        'Take a Photo',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  GestureDetector(
                    onTap: pickGalleryImage,
                    child: Container(
                      width: MediaQuery.of(context).size.width - 150,
                      alignment: Alignment.center,
                      padding:
                          EdgeInsets.symmetric(horizontal: 24, vertical: 17),
                      decoration: BoxDecoration(
                        color: Color(0xFFE99600),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        'Camera Roll',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
