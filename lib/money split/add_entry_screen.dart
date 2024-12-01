import 'package:adaptive_action_sheet/adaptive_action_sheet.dart';
import 'package:blurrycontainer/blurrycontainer.dart';
import 'package:chat_bubbles/bubbles/bubble_special_three.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:google_ml_kit/google_ml_kit.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:lottie/lottie.dart';
import 'package:page_transition/page_transition.dart';
import 'package:paisasplit/money%20split/provider/moneysplit_provider.dart';
import 'package:paisasplit/money%20split/user_screen.dart';
import 'package:provider/provider.dart';

import 'home_screen.dart';

class add_screen extends StatelessWidget {
  const add_screen({super.key});

  @override
  Widget build(BuildContext context) {
    var _height = MediaQuery.of(context).size.height;
    var _width = MediaQuery.of(context).size.width;

 

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
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/red-blue-background.jpg',),
            fit: BoxFit.fill
          )
        ),
        child: Center(
          child: Column(
            children: [
              Consumer<data_provider>(builder: (context, chatProvider, child) {
                return Expanded(
                  child: Column(
                    children: [
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(right: 10, left: 10, top: 20),
                          child: BlurryContainer(
                            borderRadius: BorderRadius.all(Radius.circular(25)),
                            width: double.maxFinite,
                            blur: 7,
                            elevation: 1,
                            color: Colors.white.withOpacity(0.2),
                            child: chatProvider.promts.isEmpty
                                ? Container(
                              child: Stack(
                                children: [
                                  // Position the robot image
                                  Positioned(
                                    bottom:
                                    5, // Position near the bottom of the container
                                    left:
                                    10, // Adjust the left position to align with the bubble
                                    child: Image.asset(
                                      'assets/images/person.png',
                                      fit: BoxFit.fill,
                                      height: 270,
                                    ),
                                  ),
                                  // Position the speech bubble next to the robot
                                  const Positioned(
                                    bottom:
                                    200, // Adjust the bottom position to align the bubble with the robot
                                    left:
                                    163, // Adjust the left position to place the bubble beside the robot
                                    child: BubbleSpecialThree(
                                      text:
                                      'Ask away any\nfinance related stuff!!',
                                      color: Colors.white,
                                      isSender: false,
                                      textStyle: TextStyle(
                                        color: Colors.black,
                                        fontSize: 16,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            )
                                : ListView.builder(
                              controller: chatProvider.scrollController,
                              reverse: chatProvider.chatInitiated, // true
                              itemCount: chatProvider.promts.length, // Number of prompts
                              itemBuilder: (context, index) {
                                // If this is the last prompt and Gemini is still typing, show the loading indicator
                                if (index == chatProvider.promts.length - 1 &&
                                    chatProvider.aityping &&
                                    (chatProvider.responses.length < chatProvider.promts.length)) {
                                  return Column(
                                    children: [
                                      BubbleSpecialThree(
                                        text: chatProvider.promts[index],
                                        color: Colors.white.withOpacity(0.5),
                                        tail: true,
                                        isSender: true,
                                        textStyle: const TextStyle(
                                            color: Colors.black, fontSize: 16),
                                      ),
                                      Container(
                                        width: 50,
                                        child: Center(
                                          child: LoadingAnimationWidget.waveDots(
                                            color: Colors.black,
                                            size: 40,
                                          ),
                                        ),
                                      ),
                                    ],
                                  );
                                } else {
                                  return Column(
                                    children: [
                                      BubbleSpecialThree(
                                        text: chatProvider.promts[index],
                                        color: Colors.white.withOpacity(0.5),
                                        tail: true,
                                        isSender: true,
                                        textStyle: const TextStyle(
                                            color: Colors.black, fontSize: 16),
                                      ),
                                      if (index <
                                          chatProvider.responses
                                              .length) // Ensure response exists for this prompt
                                        BubbleSpecialThree(
                                          text: chatProvider.responses[index],
                                          color: Colors.black.withOpacity(0.3),
                                          tail: true,
                                          isSender: false,
                                          textStyle: const TextStyle(
                                              color: Colors.white, fontSize: 16),
                                        ),
                                    ],
                                  );
                                }
                              },
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding:
                        const EdgeInsets.only(top: 10, right: 14, left: 14, bottom: 10),
                        child: BlurryContainer(
                          elevation: 1,
                          blur: 2,
                          borderRadius: const BorderRadius.all(Radius.circular(25)),
                          color: Colors.white.withOpacity(0.2),
                          child: Row(
                            children: [
                              InkWell(
                                enableFeedback: true,
                                borderRadius: BorderRadius.circular(25),
                                onTap: () {
                                  showAdaptiveActionSheet(
                                    context: context,
                                    androidBorderRadius: 30,
                                    actions: <BottomSheetAction>[
                                      BottomSheetAction(
                                          title: const Text(
                                            'Camera',
                                            style: TextStyle(),
                                          ),
                                          onPressed: (context) {
                                            chatProvider.setSource(ImageSource.camera);
                                            chatProvider.selectImage();
                                            Navigator.pop(context);
                                          },
                                          leading: Icon(CupertinoIcons.camera)),
                                      BottomSheetAction(
                                          title: const Text('Gallery'),
                                          onPressed: (context) {
                                            chatProvider.setSource(ImageSource.gallery);
                                            chatProvider.selectImage();
                                            Navigator.pop(context);
                                          },
                                          leading: const Icon(Icons.image)),
                                    ],
                                    cancelAction: CancelAction(title: const Text('Cancel')),
                                  );
                                },
                                child: Container(
                                  width: 40,
                                  height: 40,
                                  decoration: const BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Color(0xffe1cccc),
                                  ),
                                  child: const Icon(
                                    Icons.add,
                                    size: 28,
                                    color: Color(0xff907878),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: TextFormField(
                                  controller:  chatProvider.promptController,
                                  cursorHeight: 20,
                                  cursorColor: Colors.black.withOpacity(0.7),
                                  maxLines: null,
                                  decoration: InputDecoration(
                                    prefixIcon:  chatProvider.chatimg != null
                                        ? Padding(
                                      padding: EdgeInsets.symmetric(horizontal: 7),
                                      child: Stack(
                                        children: [
                                          // Image
                                          ClipRRect(
                                            borderRadius: BorderRadius.circular(
                                                50), // Ensure circular shape
                                            child: Image.file(
                                              chatProvider.chatimg!,
                                              width: 50, // Set a fixed width
                                              height: 50, // Set a fixed height
                                              fit: BoxFit
                                                  .cover, // Ensure the image covers the area
                                            ),
                                          ),
                                          // Circular Background for the Cancel Icon
                                          Positioned(
                                            top: 0,
                                            right: 0,
                                            child: Center(
                                              child: IconButton(
                                                icon: Icon(Icons.cancel,
                                                    color: Colors.red, size: 25),
                                                onPressed: () {
                                                  // Handle the cancel button press
                  
                                                  chatProvider.setimage(); // Clear the image when the cancel button is pressed
                  
                                                },
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    )
                                        : null, // Remove the prefix if no image
                                    suffixIcon: InkWell(
                                      child: const Icon(Icons.send_rounded,
                                          color: Color(0xff907878)),
                                      enableFeedback: true,
                                      onTap: () {
                  
                                        if ( chatProvider.promptController.text.isEmpty) {
                                          chatProvider.seterror(true);
                                        } else {
                                          chatProvider.aitypingg(true);
                                          if (chatProvider.responses.length == 1) {
                                            chatProvider.chatinatalized(false);
                                          }
                                          chatProvider.scroll();
                                          chatProvider.seterror(false);
                                          chatProvider.promts.add( chatProvider.promptController.text);
                                          chatProvider.getResponse();
                                        }
                  
                                      },
                                    ),
                                    contentPadding: const EdgeInsets.symmetric(
                                        vertical: 8, horizontal: 15),
                                    fillColor: const Color(0xffe1cccc),
                                    filled: true,
                                    hintText:  chatProvider.showErrorHint
                                        ? 'Please write something'
                                        : 'Type Here...',
                                    hintStyle: TextStyle(
                                      color: chatProvider.showErrorHint
                                          ? Colors.red
                                          : const Color(0xff907878),
                                      fontSize: 15,
                                    ),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(30),
                                      borderSide: BorderSide.none,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },),

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
                        child: Image.asset('assets/images/home-page.png',width:  _width*0.09,height: 30,),
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
