import 'package:flutter/material.dart';
import 'package:flutter_tesseract_ocr/android_ios.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/date_symbols.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:paisasplit/money%20split/user_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'home_screen.dart';

class add_screen extends StatelessWidget {
  const add_screen({super.key});






  @override
  Widget build(BuildContext context) {
    var _height = MediaQuery.of(context).size.height;
    var _width = MediaQuery.of(context).size.width;

    Future<void> scanReceiptAndExtractPrice() async {
      final picker = ImagePicker();

      try {
        // Step 1: Capture Image
        final XFile? image = await picker.pickImage(source: ImageSource.gallery);
        if (image == null) {
          // User canceled the image picker
          return;
        }

        // Step 2: Extract Text from Image
        String extractedText = await FlutterTesseractOcr.extractText(image.path);

        // Step 3: Parse the Price
        final priceRegex = RegExp(r'(\d+\.\d{2})'); // Matches patterns like 12.34
        final match = priceRegex.firstMatch(extractedText);
        if (match != null) {
          String price = match.group(0)!;

          // Step 4: Save Price Locally
          SharedPreferences prefs = await SharedPreferences.getInstance();
          await prefs.setString('extractedPrice', price);

          // Step 5: Notify User
          print('Extracted Price: $price');
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Price extracted: $price')),
          );
        } else {
          // Notify user if no price is found
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('No price found on receipt.')),
          );
        }
      } catch (e) {
        print('Error: $e');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('An error occurred while scanning.')),
        );
      }
    }

    return Scaffold(
      appBar: AppBar(
        forceMaterialTransparency: true,
        backgroundColor: Colors.white,
        title: FittedBox(child: Text("Add bill",style: TextStyle(
            fontSize: _width*0.09,
            fontFamily: "Meme",
            fontWeight: FontWeight.w600
        ),),),
        centerTitle: true,
        actions: [
          Padding(
            padding: const EdgeInsets.all(12),
            child:Text("SAVE",style: TextStyle(
                fontSize: _width*0.04,
                fontWeight: FontWeight.w600
            ),),
          )
        ],
      ),
      body: Container(
        width: _width,
        height: _height,

        child: Center(
          child: Column(
            children: [
              Expanded(
                child: Container(
                  color: Colors.green,
                  child: Center(
                    child: Lottie.asset("assets/gifs/iamge_add.json",fit: BoxFit.cover,height: _height*0.25,),
                  ),
                )
              ),
              ElevatedButton(
                onPressed: () async {
                  await scanReceiptAndExtractPrice();
                },
                child: Text('Scan Receipt'),
              ),

              Container(
                margin: EdgeInsets.only(bottom: 10, right: 10, left: 10),
                width: _width,
                height: _height * 0.1,
                decoration: BoxDecoration(
                  color: Colors.grey.withOpacity(0.5),
                  borderRadius: BorderRadius.circular(25),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    InkWell(child: Icon(Icons.history,size: _width*0.1,),onTap: () {
                      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => homepage(),));
                    },),
                    InkWell(
                      child: FittedBox(
                        child: Icon(
                          Icons.add_circle_rounded,
                          size: _width * 0.2,
                          color: Colors.green,
                        ),
                      ),
                      onTap: () {},
                    ),
                    InkWell(child: Icon(Icons.person,size: _width*0.1,),onTap: () {
                      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => user_screen(),));
                    },),

                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
