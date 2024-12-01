import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:google_ml_kit/google_ml_kit.dart';
import 'package:lottie/lottie.dart';
import 'package:page_transition/page_transition.dart';
import 'package:paisasplit/money%20split/user_screen.dart';

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
        final XFile? image =
        await picker.pickImage(source: ImageSource.gallery);
        if (image == null) {
          // User canceled the image picker
          return;
        }

        // Step 2: Initialize Text Recognition
        final inputImage = InputImage.fromFilePath(image.path);
        final textDetector = GoogleMlKit.vision.textRecognizer();

        // Step 3: Process the image for text recognition
        final RecognizedText recognizedText =
        await textDetector.processImage(inputImage);

        // Step 4: Extract price from recognized text
        final priceRegex = RegExp(r'\d+\.\d{2}'); // Matches patterns like 12.34
        String? extractedPrice;
        for (TextBlock block in recognizedText.blocks) {
          for (TextLine line in block.lines) {
            if (priceRegex.hasMatch(line.text)) {
              extractedPrice = priceRegex.firstMatch(line.text)?.group(0);
              break;
            }
          }
          if (extractedPrice != null) break;
        }

        // Notify user
        if (extractedPrice != null) {
          print('Extracted Price: $extractedPrice');
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Price extracted: $extractedPrice')),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('No price found on the receipt.')),
          );
        }

        // Dispose of the text detector
        textDetector.close();
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
        title: FittedBox(
          child: Text(
            "Add bill",
            style: TextStyle(
                fontSize: _width * 0.09,
                fontFamily: "Meme",
                fontWeight: FontWeight.w600),
          ),
        ),
        centerTitle: true,
        actions: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: Text(
              "SAVE",
              style: TextStyle(
                  fontSize: _width * 0.04, fontWeight: FontWeight.w600),
            ),
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
                      child: Lottie.asset(
                        "assets/gifs/iamge_add.json",
                        fit: BoxFit.cover,
                        height: _height * 0.25,
                      ),
                    ),
                  )),
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
                    InkWell(
                      child: Image.asset('assets/images/home-page.png',width:  _width*0.09),
                      onTap: () {
                        Navigator.pushReplacement(
                            context,
                            PageTransition(
                                child: homepage(),
                                type: PageTransitionType.leftToRight));
                      },
                    ),
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
                    InkWell(
                      child: Image.asset('assets/images/person.png',width:  _width*0.09),
                      onTap: () {
                        Navigator.pushReplacement(
                            context,
                            PageTransition(
                                child: user_screen(),
                                type: PageTransitionType.rightToLeft));
                      },
                    ),
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
