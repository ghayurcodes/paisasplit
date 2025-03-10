import 'dart:convert';
import 'dart:io';
import 'package:blurrycontainer/blurrycontainer.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gemini/flutter_gemini.dart';
import 'package:hive/hive.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import '../Hive_model/Entry.dart';


class data_provider with ChangeNotifier{
  List<Entry>  i_take =[];
  List<Entry> i_give = [];
  List<double> current_month_data=[0,0];
  List<double> prev_month_data=[0,0];
  String name="";
  File? imageFile;
  File? chatimg;
  bool chatInitiated = true;
  List<String> promts = [];
  List<String> responses = [];
  final ScrollController scrollController = ScrollController();
  final TextEditingController promptController = TextEditingController();
  bool aityping = false;
  var source;
  bool showErrorHint = false;
  final Gemini gemini = Gemini.instance;


  getHiveData() async {
    var box = await Hive.openBox('data');
    String? oweMeJson = box.get('oweMe');
    String? iOweJson = box.get('iOwe');
    name=box.get('name',defaultValue: "");
    final savedImageData = box.get('profileImage');
    if (savedImageData != null) {
      decode(savedImageData);
    }

    if (oweMeJson != null) {
      List<dynamic> oweMeList = jsonDecode(oweMeJson);
      i_take = oweMeList.map((e) => Entry.fromJson(e)).toList();

    }

    if (iOweJson != null) {
      List<dynamic> iOweList = jsonDecode(iOweJson);
      i_give = iOweList.map((e) => Entry.fromJson(e)).toList();

    }
    current_month_data=[0,0];
    prev_month_data=[0,0];

    for(var i in i_take) {
      if (i.dateTime.month == DateTime
          .now()
          .month) {
        current_month_data[1] += i.amount;
      }
      if (i.dateTime.month == DateTime
          .now()
          .month - 1) {
        prev_month_data[1] += i.amount;
      }
    }
      for (var i in i_give) {
        if (i.dateTime.month == DateTime
            .now()
            .month) {
          current_month_data[0] += i.amount;
        }
        if (i.dateTime.month == DateTime
            .now()
            .month - 1) {
          prev_month_data[0] += i.amount;
        }
      }



  notifyListeners();

  }
  saveToHive(String name,double amount,DateTime time,int opt) async {
    var box = await Hive.openBox('data');
    Entry temp = Entry(name,amount,time);

    if(opt==0){
      i_give.add(temp);
      String iOweJson = jsonEncode(i_give.map((e) => e.toJson()).toList());
      await box.put('iOwe', iOweJson);

    }

    else if(opt==1){
      i_take.add(temp);
      String oweMeJson = jsonEncode(i_take.map((e) => e.toJson()).toList());
      await box.put('oweMe', oweMeJson);


    }
    current_month_data=[0,0];
    prev_month_data=[0,0];

    for(var i in i_take) {
      if (i.dateTime.month == DateTime
          .now()
          .month) {
        current_month_data[1] += i.amount;
      }
      if (i.dateTime.month == DateTime
          .now()
          .month - 1) {
        prev_month_data[1] += i.amount;
      }
    }
    for (var i in i_give) {
      if (i.dateTime.month == DateTime
          .now()
          .month) {
        current_month_data[0] += i.amount;
      }
      if (i.dateTime.month == DateTime
          .now()
          .month - 1) {
        prev_month_data[0] += i.amount;
      }
    }


    notifyListeners();
  }
  void deleteEntry(Entry entry, int opt, BuildContext context) async {
    var box = await Hive.openBox('data');

    // Text controllers to edit the entry
    final TextEditingController nameController = TextEditingController(text: entry.name);
    final TextEditingController amountController = TextEditingController(text: entry.amount.toString());


    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Edit or Delete Entry'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: InputDecoration(labelText: 'Name'),
              ),
              TextField(
                controller: amountController,
                decoration: InputDecoration(labelText: 'Amount'),
                keyboardType: TextInputType.number,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close dialog
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                // Update the entry
                if (nameController.text.isNotEmpty && amountController.text.isNotEmpty) {
                  entry.name = nameController.text.trim();
                  entry.amount = double.tryParse(amountController.text.trim()) ?? entry.amount;

                  // Update Hive storage
                  if (opt == 0) {
                    String iOweJson = jsonEncode(i_give.map((e) => e.toJson()).toList());
                    await box.put('iOwe', iOweJson);
                  } else if (opt == 1) {
                    String oweMeJson = jsonEncode(i_take.map((e) => e.toJson()).toList());
                    await box.put('oweMe', oweMeJson);
                  }

                  updateMonthlyData();
                  notifyListeners();
                }
                Navigator.of(context).pop(); // Close dialog
              },
              child: Text('Edit'),
            ),
            TextButton(
              onPressed: () async {
                // Delete the entry
                if (opt == 0) {
                  i_give.remove(entry);
                  String iOweJson = jsonEncode(i_give.map((e) => e.toJson()).toList());
                  await box.put('iOwe', iOweJson);
                } else if (opt == 1) {
                  i_take.remove(entry);
                  String oweMeJson = jsonEncode(i_take.map((e) => e.toJson()).toList());
                  await box.put('oweMe', oweMeJson);
                }

                updateMonthlyData();
                notifyListeners();
                Navigator.of(context).pop(); // Close dialog
              },

              child: Text('Delete'),
            ),
          ],
        );
      },
    );
  }


// Helper function to update monthly data
  void updateMonthlyData() {
    current_month_data = [0, 0];
    prev_month_data = [0, 0];

    for (var i in i_take) {
      if (i.dateTime.month == DateTime.now().month) {
        current_month_data[1] += i.amount;
      }
      if (i.dateTime.month == DateTime.now().month - 1) {
        prev_month_data[1] += i.amount;
      }
    }
    for (var i in i_give) {
      if (i.dateTime.month == DateTime.now().month) {
        current_month_data[0] += i.amount;
      }
      if (i.dateTime.month == DateTime.now().month - 1) {
        prev_month_data[0] += i.amount;
      }
    }
  }

  double calculate_total(List<Entry> s){
    double total=0;
    for(int i=0;i<s.length;i++){
      total+=s[i].amount;
    }

    return total;
  }
  void save_name(BuildContext context) {
    final TextEditingController namecontroler = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Edit name"),
          content: TextField(
            controller: namecontroler,
            decoration: InputDecoration(
              hintText: "Enter name",
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: Text("Cancel"),
            ),
            TextButton(
              onPressed: () async {
                String namee = namecontroler.text;
                if(namee.isNotEmpty){
                  var box = await Hive.openBox('data');
                  name=namee;
                  box.put("name", name);
                }else{
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("please enter something")));
                }
                Navigator.of(context).pop(); // Close the dialog
              },
              child: Text("Save"),
            ),
          ],
        );
      },
    );
    notifyListeners();
  }
  void delall()async{
    var box = await Hive.openBox('data');
    i_give.clear();
    i_take.clear();

    String iOweJson = jsonEncode(i_give.map((e) => e.toJson()).toList());
    await box.put('iOwe', iOweJson);
    String oweMeJson = jsonEncode(i_take.map((e) => e.toJson()).toList());
    await box.put('oweMe', oweMeJson);
    notifyListeners();

  }
  Future<void> decode(String base64String) async {
    try {
      // Decode base64 string to bytes
      var bytes = base64Decode(base64String);

      // Create a temporary file to store the image
      final tempDir = await getTemporaryDirectory();
      final tempFile = File('${tempDir.path}/profile_image.png');

      await tempFile.writeAsBytes(bytes);//storing image on local storage
      imageFile = tempFile;
      notifyListeners();

    } catch (e) {
      print('Error loading image: $e');
    }
  }
  Future<void> pickImage() async {//for pfp
    var box = await Hive.openBox('data');
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      final imageFilee = File(pickedFile.path);

      // Read image file as bytes and convert to base64
      var imageBytes = await imageFilee.readAsBytes();
      String base64Image = base64Encode(imageBytes);
        imageFile = imageFilee;
      box.put('profileImage', base64Image);//styoring encoded string in hive
    }
    notifyListeners();
  }


  Future<void> selectImage() async {//for gemeni
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: source, imageQuality: 50);
    if (pickedFile != null) {
      chatimg = File(pickedFile.path);
      notifyListeners();
    }
  }



  void setsource(var i){
    source=i;
    notifyListeners();
  }
  void setSource(ImageSource s) {
    source = s;
    notifyListeners();
  }
  void setimage(){
    chatimg=null;
    notifyListeners();
  }
  void seterror( bool g){
    showErrorHint = g;
    notifyListeners();
  }
  void chatinatalized( bool g){
    chatInitiated = g;
    notifyListeners();
  }
  void aitypingg(bool x){
    aityping=x;
    notifyListeners();
  }
  Future<void> getResponse() async {
    var igive=calculate_total(i_give).toString();
    var itake=calculate_total(i_take).toString();
     var systemInstructions = "Hi, your name is Fynn! You are a friendly and knowledgeable finance assistant in a loan management app. You help users manage their finances by: "
        "1. Providing clear summaries of how much they owe (currently ${igive} dollars) and how much they are owed (currently ${itake} dollars). "
        "2. Offering actionable financial advice to help them save money, pay off debts, and make smarter financial decisions. "
        "3. Suggesting ways to earn more money when asked for help with increasing income. "
        "4. Sharing relatable jokes or motivational quotes to keep the conversation light and engaging. "
        "When responding, keep your tone friendly and conversational, as if you’re a helpful friend who happens to know a lot about finances. "
        "Always balance concise explanations with enough detail to be helpful. If the user asks for a joke, make it relevant and funny—but keep it light and suitable for everyone.";
    final combinedPrompt = "$systemInstructions\n\n${promptController.text}";

    aityping = true;
    notifyListeners();

    if (chatimg != null) {
      var imageBytes = chatimg!.readAsBytesSync();

      await gemini.textAndImage(text: combinedPrompt, images: [imageBytes]).then((value) {
        responses.add(value?.output ?? '...');
        aityping = false;
        scroll();
      }).onError((error, stackTrace) {
        print('Error: ${error.toString()}');
      });
    } else {
      await gemini.text(combinedPrompt).then((value) {
        responses.add(value?.output ?? '...');
        aityping = false;
        scroll();
      }).onError((error, stackTrace) {
        print('Error: ${error.toString()}');
      });
    }
    notifyListeners();
  }
  void scroll() {
    Future.delayed(Duration(milliseconds: 100), () {
      scrollController.animateTo(
        scrollController.position.maxScrollExtent,
        duration: Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    });
  }
}







TextStyle stylee(){
  return TextStyle(
      fontSize: 20,
      fontFamily: "splash"
  );

}
popup_add(
    var context,
    var _height,
    var _width,
    var name,
    var amount,
    var opt

    ){
  return showDialog(
    context: context,
    builder: (context) {
      var _provider=Provider.of<data_provider>(context,listen: false);
      return Center(
        child: BlurryContainer(
            height: _height*0.30,
            width: _width*0.6,
            color: Colors.black.withOpacity(0.1),
            child:Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                    style: TextStyle(color: Colors.white.withOpacity(0.7)),
                    cursorColor: Colors.white,
                    controller: name,
                    decoration: InputDecoration(
                      hintText:"Name",
                      contentPadding: EdgeInsets.all(10),
                      hintStyle: TextStyle(color: Colors.white.withOpacity(0.7)),
                      focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                          borderSide: BorderSide(
                              color: Colors.white,
                              width: 2
                          )
                      ),
                      enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                          borderSide: BorderSide(
                              color: Colors.white,
                              width: 1
                          )
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                    cursorColor: Colors.white,
                    controller: amount,
                    style: TextStyle(color: Colors.white.withOpacity(0.7)),
                    decoration: InputDecoration(
                      hintText:"Amount",
                      contentPadding: EdgeInsets.all(10),
                      hintStyle: TextStyle(color: Colors.white.withOpacity(0.7)),
                      focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                          borderSide: BorderSide(
                              color: Colors.white,
                              width: 2
                          )
                      ),
                      enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                          borderSide: BorderSide(
                              color: Colors.white,
                              width: 1
                          )
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8),
                  child: Center(
                    child: Row(
                      children: [
                        Expanded(
                          flex: 5,
                          child: InkWell(
                            onTap: (){
                              Navigator.pop(context);
                            },
                            child: Container(
                              height: _height*0.06,
                              width: _width*0.18,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(15),
                                  color: Colors.red.withOpacity(0.8)
                              ),
                              child: Center(
                                child: Text("Cancel",style: TextStyle(
                                    fontWeight: FontWeight.bold
                                ),),
                              ),
                            ),
                          ),
                        ),
                        Expanded(child: Container(
                            height: _height*0.06,
                            width: 2
                        ),flex: 1,),
                        Expanded(
                          flex: 5,
                          child: GestureDetector(
                            onTap: () {

                              if(name.text.isNotEmpty && amount.text.isNotEmpty ){
                                try{
                                  _provider.saveToHive(name.text.trim(), double.parse(amount.text.trim()), DateTime.now(),opt);
                                  name.clear();
                                  amount.clear();
                                  Navigator.pop(context);
                                }
                                catch(e){
                                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString())));

                                }
                              }
                              else{
                                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Please enter something")));
                              }

                            },
                            child: Container(
                              height: _height*0.06,
                              width: _width*0.18,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(15),
                                  color: Colors.green.withOpacity(0.8)
                              ),
                              child: Center(
                                child: Text("Save",style: TextStyle(
                                    fontWeight: FontWeight.bold
                                ),),
                              ),
                            ),
                          ),
                        ),

                      ],
                    ),
                  ),
                ),
              ],
            )
        ),
      );
    },
  );
}















