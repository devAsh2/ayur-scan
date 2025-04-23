import 'dart:convert';
import 'dart:typed_data';
import 'output_page.dart';

import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        elevation: 0.0,
        actions: [],
      ),
      body: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          Container(
            padding: const EdgeInsets.only(left: 50, right: 50, bottom: 80),
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: NetworkImage(
                  'https://i.pinimg.com/736x/39/6f/9a/396f9af5242c0be0373139d8657cbb7c.jpg',
                ),
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  height: 300,
                  child: Lottie.network(
                    'https://assets8.lottiefiles.com/private_files/lf30_8exlgvzr.json',
                  ),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () async {
                    var responseData = await _openImagePicker(context);
                    print(responseData);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => OutputPage(responseData: responseData),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    primary: Colors.green,
                    textStyle: const TextStyle(
                      fontSize: 20,
                      fontStyle: FontStyle.normal,
                      color: Colors.black,
                    ),
                    elevation: 25,
                    shadowColor: Colors.black,
                    shape: const BeveledRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(20)),
                    ),
                  ),
                  child: const Text('Upload Image'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<dynamic> _callAPI(Uint8List image) async {
    // Construct the API URL
    var apiUrl = 'http://192.168.0.102:5000/predict'; // Replace with your API endpoint URL

    // Prepare the request body
    var requestBody = jsonEncode({'image': base64Encode(image)});

    // Set the content type header
    var headers = {'Content-Type': 'application/json'};

    // Make the API request
    var response = await http.post(Uri.parse(apiUrl), headers: headers, body: requestBody);

    // Handle the API response
    if (response.statusCode == 200) {
      // API call was successful, process the response
      var responseData = jsonDecode(response.body);
      // Do something with the response data
      return responseData;
    } else {
      // API call failed
      print('API request failed with status code: ${response.body}');
    }
  }

  Future<dynamic> _openImagePicker(BuildContext context) async {
    final picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      final imageBytes = await image.readAsBytes();
      return await _callAPI(imageBytes);
    }
  }
}
