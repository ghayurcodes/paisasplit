import 'dart:io';
import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:paisasplit/money%20split/add_entry_screen.dart';
import 'package:paisasplit/money%20split/home_screen.dart';
import 'package:paisasplit/money%20split/provider/moneysplit_provider.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pie_chart/pie_chart.dart';
import 'package:provider/provider.dart';

class user_screen extends StatefulWidget {
  const user_screen({super.key});

  @override
  State<user_screen> createState() => _user_screenState();
}

class _user_screenState extends State<user_screen> {
  final Box pfp = Hive.box('data');
  File? _imageFile;

  @override
  void initState() {
    super.initState();

    final savedImageData = pfp.get('profileImage');
    if (savedImageData != null) {
      _loadImageFromBase64(savedImageData);
    }
  }

  Future<void> _loadImageFromBase64(String base64String) async {
    try {
      // Decode base64 string to bytes
      var bytes = base64Decode(base64String);

      // Create a temporary file to store the image
      final tempDir = await getTemporaryDirectory();
      final tempFile = File('${tempDir.path}/profile_image.png');

      await tempFile.writeAsBytes(bytes);

      setState(() {
        _imageFile = tempFile;
      });
    } catch (e) {
      print('Error loading image: $e');
    }
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      final imageFile = File(pickedFile.path);

      // Read image file as bytes and convert to base64
      List<int> imageBytes = await imageFile.readAsBytes();
      String base64Image = base64Encode(imageBytes);

      setState(() {
        _imageFile = imageFile;
      });

      // Save the image as base64 encoded string in Hive
      pfp.put('profileImage', base64Image);
    }
  }

  @override
  Widget build(BuildContext context) {
    var _height = MediaQuery.of(context).size.height;
    var _width = MediaQuery.of(context).size.width;
    final previousMonth =
        DateTime(DateTime.now().year, DateTime.now().month - 1);
    TextEditingController change_name = TextEditingController();

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        forceMaterialTransparency: true,
        backgroundColor: Colors.white,
        title: FittedBox(
          child: Text(
            "user",
            style: TextStyle(
                fontSize: _width * 0.09,
                fontFamily: "Meme",
                fontWeight: FontWeight.w600),
          ),
        ),
        centerTitle: true,
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
        color: Colors.white,
        child: Center(
          child: Column(
            children: [
              Expanded(
                child: Column(
                  children: [
                    Expanded(
                      flex: 3,
                      child: Container(
                        color: Colors.white,
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
                              child: _imageFile == null
                                  ? InkWell(
                                      onTap: () {
                                        _pickImage();
                                      },
                                      child: CircleAvatar(
                                        backgroundColor: Colors.white,
                                        radius: _width * 0.15,
                                        child: Icon(
                                          Icons.add_circle_rounded,
                                          size: 50,
                                          color: Colors.black,
                                        ),
                                      ),
                                    )
                                  : CircleAvatar(
                                      radius: _width * 0.15,
                                      backgroundImage: FileImage(_imageFile!)
                                          as ImageProvider,
                                    ),
                            ),
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Consumer<data_provider>(
                                  builder: (context, value, child) {
                                    return Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        FittedBox(
                                          child: InkWell(
                                      onLongPress: (){
                                        value.save_name(context);
                                      }
                                            ,
                                            child: Text(
                                              value.name==""?"Hold to edit":value.name,
                                              style: TextStyle(
                                                fontSize: _width * 0.1,
                                                fontWeight: FontWeight.bold,
                                                color: Color(0xfff94c61),
                                              ),
                                              textAlign: TextAlign.left,
                                            ),
                                          ),
                                        ),
                                        SizedBox(height: 5),
                                        FittedBox(
                                          child: Text(
                                            "you owe ${value.calculate_total(value.i_give)}\$",
                                            style: TextStyle(
                                              fontSize: _width * 0.05,
                                              color: Color(0xfff94c61),
                                            ),
                                          ),
                                        ),
                                        SizedBox(height: 10),
                                        InkWell(
                                          onTap: () {
                                            value.delall();
                                          },
                                          child: Container(
                                            width: 70,
                                            height: 30,
                                            decoration: BoxDecoration(
                                                color: Colors.white,
                                                border: Border.all(
                                                    color: Colors.red,
                                                    width: 2),
                                                borderRadius:
                                                    BorderRadius.circular(10)),
                                            child: Center(
                                              child: Text('Clear all'),
                                            ),
                                          ),
                                        )
                                      ],
                                    );
                                  },
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Divider(
                      color: Colors.grey,
                      height: 1,
                      thickness: 2,
                    ),
                    Expanded(
                      flex: 7,
                      child: Container(
                        color: Colors.white,
                        child: Column(
                          children: [
                            Expanded(
                              child: Container(
                                color: Colors.white,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Align(
                                      alignment: Alignment.centerLeft,
                                      child: Padding(
                                        padding: const EdgeInsets.all(15),
                                        child: Text(
                                          DateFormat('MMMM')
                                              .format(DateTime.now()),
                                          style: TextStyle(
                                            fontSize: _width * 0.06,
                                            fontWeight: FontWeight.w700,
                                            color: Color(0xff2d3032),
                                          ),
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      child: Consumer<data_provider>(
                                        builder: (context, value, child) {
                                          return (value.current_month_data[0]==0 && value.current_month_data[1]==0)? Center(
                                          child: FittedBox(
                                          child: Column(
                                          children: [
                                          Lottie.asset(
                                          "assets/gifs/empty.json",
                                          fit: BoxFit.fill,
                                          height:
                                          _height * 0.2),
                                          Text(
                                          "No records found!",
                                          style: TextStyle(
                                          fontSize: 29),
                                          )
                                          ],
                                          ),
                                          )):PieChart(
                                            dataMap: {
                                              "Recived":
                                                  value.current_month_data[1],
                                              "Sent":
                                                  value.current_month_data[0]
                                            },
                                            colorList: [
                                              Color(0xff529854),
                                              Color(0xfff94c61),
                                            ],
                                          );
                                        },
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                            Divider(
                              color: Colors.grey,
                              height: 1,
                              thickness: 2,
                            ),
                            Expanded(
                              child: Container(
                                color: Colors.white,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Align(
                                      alignment: Alignment.centerLeft,
                                      child: Padding(
                                        padding: const EdgeInsets.all(15),
                                        child: Text(
                                          '${DateFormat('MMMM').format(previousMonth)}',
                                          style: TextStyle(
                                              fontSize: _width * 0.06,
                                              fontWeight: FontWeight.w700,
                                              color: Color(0xff2d3032)),
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      child: Consumer<data_provider>(
                                        builder: (context, value, child) {
                                          return value.prev_month_data[1] == 0
                                              ? Center(
                                                  child: FittedBox(
                                                  child: Column(
                                                    children: [
                                                      Lottie.asset(
                                                          "assets/gifs/empty.json",
                                                          fit: BoxFit.fill,
                                                          height:
                                                              _height * 0.2),
                                                      Text(
                                                        "No records found!",
                                                        style: TextStyle(
                                                            fontSize: 29),
                                                      )
                                                    ],
                                                  ),
                                                ))
                                              : PieChart(
                                                  dataMap: {
                                                    "Recived": value
                                                        .prev_month_data[1],
                                                    "Sent":
                                                        value.prev_month_data[0]
                                                  },
                                                  colorList: [
                                                    Color(0xff529854),
                                                    Color(0xfff94c61),
                                                  ],
                                                );
                                        },
                                      ),
                                    )
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
                    InkWell(
                      child: Icon(
                        Icons.history,
                        size: _width * 0.1,
                      ),
                      onTap: () {
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => homepage(),
                            ));
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
                      onTap: () {
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => add_screen(),
                            ));
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
