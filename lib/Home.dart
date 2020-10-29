import 'dart:convert';
import 'dart:io' as Io;

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  var uploading = false;
  var parsedText = '';

  parsethetext() async {
    //pick a image
    setState(() {
      uploading = true;
    });
    final imageFile = await ImagePicker()
        .getImage(source: ImageSource.gallery, maxWidth: 670, maxHeight: 970);
    //prepare the image
    var bytes = Io.File(imageFile.path.toString()).readAsBytesSync();
    String img64 = base64Encode(bytes);
    // print(img64.toString());
    //send to api
    var url = 'https://api.ocr.space/parse/image';
    var payload = {'base64Image': 'data:image/jpg;base64,${img64.toString()}'};
    var header = {"apikey": "ad77048b9488957"};
    var post = await http.post(url, body: payload, headers: header);
    //get results from api
    var result = jsonDecode(post.body);
    //  print(result['ParsedResults'][0]['ParsedText']);
    setState(() {
      uploading = false;
      parsedText = result['ParsedResults'][0]['ParsedText'];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          backgroundColor: Colors.green,
          title: Center(
              child: Text(
            'Optical Character Recognition',
            style: GoogleFonts.montserrat(
                fontWeight: FontWeight.w700, fontSize: 20),
          ))),
      body: Column(
        children: [
          SizedBox(
            height: 30,
          ),
          Center(
            child: GestureDetector(
              onTap: () {
                parsethetext();
              },
              child: Container(
                width: MediaQuery.of(context).size.width / 2,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20.0),
                  color: Colors.lightGreen,
                ),
                height: 70,
                child: Center(
                  child: Text(
                    'Upload a Image',
                    style: GoogleFonts.montserrat(
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                      fontSize: 20,
                    ),
                  ),
                ),
              ),
            ),
          ),
          SizedBox(
            height: 10.0,
          ),
          Center(
            child: Text(
              'The text in the image is: ',
              style: GoogleFonts.montserrat(
                fontWeight: FontWeight.bold,
                color: Colors.black,
                fontSize: 20.0,
              ),
            ),
          ),
          SizedBox(
            height: 10.0,
          ),
          Center(
            child: Text(
              parsedText,
              style: GoogleFonts.montserrat(
                fontWeight: FontWeight.bold,
                color: Colors.black,
                fontSize: 20.0,
              ),
            ),
          )
        ],
      ),
    );
  }
}
