import 'dart:io';

import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/date_symbols.dart';
import 'package:intl/intl.dart';
import 'package:paisasplit/money%20split/add_entry_screen.dart';
import 'package:paisasplit/money%20split/home_screen.dart';

class user_screen extends StatefulWidget {
  const user_screen({super.key});

  @override
  State<user_screen> createState() => _user_screenState();
}

class _user_screenState extends State<user_screen> {
  final Box pfp = Hive.box('data'); // Hive box instance
  File? _imageFile;
  @override
  void initState() {
    super.initState();
    // Load saved image if available
    final imagePath = pfp.get('profileImagePath');
    if (imagePath != null) {
      _imageFile = File(imagePath);
    }
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      final imageFile = File(pickedFile.path);
      setState(() {
        _imageFile = imageFile;
      });

      // Save the image path to Hive
      pfp.put('profileImagePath', pickedFile.path);
    }
  }

  @override
  Widget build(BuildContext context) {
    var _height = MediaQuery.of(context).size.height;
    var _width = MediaQuery.of(context).size.width;
    final previousMonth = DateTime(DateTime.now().year, DateTime.now().month - 1);


    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Icon(Icons.more_vert_rounded),
          )
        ],
      ),
      body: Container(
        width: _width,
        height: _height,
        color: Colors.grey,
        child: Center(
          child: Column(
            children: [
              Expanded(
                child: Column(
                  children: [
                    Expanded(
                      flex: 3,
                      child: Container(
                        color: Colors.lightBlueAccent,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Container(
                              margin: EdgeInsets.all(20),
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.black,
                              ),
                              padding: EdgeInsets.all(3),
                              child: _imageFile==null?InkWell(
                                onTap: () {
                                  _pickImage();
                                },
                                child: CircleAvatar(
                                  backgroundColor: Colors.white,
                                  radius:_width*0.15,
                                  child: Icon(Icons.add_circle_rounded,size: 50,color: Colors.black,),
                                ),
                              ):CircleAvatar(
                                radius:_width*0.15,
                                backgroundImage: FileImage(_imageFile!) as ImageProvider,

                              ),
                            ),
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    FittedBox(
                                      child: Text(
                                        "dan abraham",
                                        style: TextStyle(
                                          fontSize: _width * 0.1,
                                          fontWeight: FontWeight.bold,
                                        ),
                                        textAlign: TextAlign.left,
                                      ),
                                    ),
                                    SizedBox(height: 5),
                                    FittedBox(
                                      child: Text(
                                        "you owe 50\$",
                                        style: TextStyle(
                                          fontSize: _width * 0.05,
                                          color: Colors.red,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),

                          ],
                        ),
                      ),
                    ),
                    Divider(
                       color: Colors.grey,height: 1,thickness: 2,
                    ),

                    Expanded(
                      flex: 7,
                      child: Container(
                        color: Colors.white,
                        child: Column(
                          children: [
                            Expanded(
                              child: Container(
                                color: Colors.red,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Align(
                                      alignment: Alignment.centerLeft,
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Text(DateFormat('MMMM').format(DateTime.now()),style: TextStyle(
                                        fontSize: _width*0.08,
                                        fontWeight: FontWeight.w700,
                                        color: Colors.black,
                                      ),),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Divider(
                              color: Colors.grey,height: 1,thickness: 2,
                            ),
                            Expanded(
                              child: Container(
                                color: Colors.pinkAccent,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Align(
                                      alignment: Alignment.centerLeft,
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Text(
                                          '${DateFormat('MMMM').format(previousMonth)}',
                                          style: TextStyle(
                                            fontSize: _width * 0.08,
                                            fontWeight: FontWeight.w700,
                                            color: Colors.black,
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
                      ),
                    ),
                  ],
                ),
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
                      onTap: () {
                        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => add_screen(),));
                      },
                    ),
                    Icon(Icons.person, size: _width * 0.1),
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
