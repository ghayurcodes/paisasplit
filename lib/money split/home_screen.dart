import 'dart:convert';

import 'package:blurrycontainer/blurrycontainer.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive/hive.dart';
import 'package:paisasplit/money%20split/add_entry_screen.dart';
import 'package:paisasplit/money%20split/provider/moneysplit_provider.dart';
import 'package:paisasplit/money%20split/user_screen.dart';

import 'Hive data/Entry.dart';

class homepage extends StatefulWidget {
  homepage({super.key});

  @override
  State<homepage> createState() => _homepageState();
}

class _homepageState extends State<homepage> {



  var name = TextEditingController();
  var amount = TextEditingController();

  List<Entry>  owe_me =[];
   List<Entry> i_owe = [];

  @override
  getHiveData() async {

    var box = await Hive.openBox('data');
    // Check if the data exists in the box
    String? oweMeJson = box.get('oweMe');
    String? iOweJson = box.get('iOwe');

    if (oweMeJson != null) {
      List<dynamic> oweMeList = jsonDecode(oweMeJson);
      owe_me = oweMeList.map((e) => Entry.fromJson(e)).toList();
    }

    if (iOweJson != null) {
      List<dynamic> iOweList = jsonDecode(iOweJson);
      i_owe = iOweList.map((e) => Entry.fromJson(e)).toList();
    }

    setState(() {});
  }


  saveToHive() async {
    var box = await Hive.openBox('data');
    Entry temp = Entry(name.text.trim(), double.parse(amount.text.trim()), DateTime.now());
    owe_me.add(temp);
    String oweMeJson = jsonEncode(owe_me.map((e) => e.toJson()).toList());
    String iOweJson = jsonEncode(i_owe.map((e) => e.toJson()).toList());

    await box.put('oweMe', oweMeJson);
    await box.put('iOwe', iOweJson);
  }

  @override
  void initState() {
    super.initState();
    getHiveData();
  }


  @override
  Widget build(BuildContext context) {
    var _height=MediaQuery.of(context).size.height;
    var _width=MediaQuery.of(context).size.width;




    double calculate_total(List<Entry> s){
        double total=0;
        for(int i=0;i<s.length;i++){
          total+=s[i].amount;
        }

        return total;
    }



popup_add(){
      return showDialog(
        context: context,
        builder: (context) {
          return Center(
            child: BlurryContainer(
                height: _height*0.35,
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
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          height: _height*0.09,
                          width: _width*0.18,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15),
                            color: Colors.red.withOpacity(0.8)
                          ),
                          child: Center(
                            child: Text("I Owe",style: TextStyle(
                                fontWeight: FontWeight.bold
                            ),),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            if(name.text.isNotEmpty && amount.text.isNotEmpty ){
                              saveToHive();
                              Navigator.pop(context);
                            }
                            else{
                              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Please enter something")));
                            }

                          },
                          child: Container(
                            height: _height*0.09,
                            width: _width*0.13,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15),
                                color: Colors.yellow.withOpacity(0.8)
                            ),
                            child: Center(
                              child: Text("Cancel",style: TextStyle(
                                  fontWeight: FontWeight.bold
                              ),),
                            ),
                          ),
                        ),
                        Container(
                          height: _height*0.09,
                          width: _width*0.18,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15),
                              color: Colors.green.withOpacity(0.8)
                          ),
                          child: Center(
                            child: Text("Owe me",style: TextStyle(
                              fontWeight: FontWeight.bold
                            ),),
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              )
            ),
          );
        },
      );
    }

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        forceMaterialTransparency: true,
            backgroundColor: Colors.transparent,
          title: FittedBox(child: Text("Money Split",style: TextStyle(
            fontSize: _width*0.09,
            fontFamily: "Meme",
            fontWeight: FontWeight.w600
          ),),),
        centerTitle: true,
      ),
      body: Container(
        width: double.maxFinite,
        height: double.maxFinite,
        color: Colors.black.withOpacity(0.1),
        // decoration: BoxDecoration(
        //     image: DecorationImage(
        //       image: AssetImage('assets/images/bg_blue.jpg'),
        //       fit: BoxFit.fill,
        //       opacity: 0.6
        //     )
        // ),
        child: Center(
          child: Column(
            children: [
              Expanded(child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                       children: [
                         Container(
                           width: _width*0.4,
                           height: _width*0.4,
                           decoration: BoxDecoration(
                             color: Colors.redAccent,
                              shape: BoxShape.circle
                           ),
                           child: Center(
                             child: Padding(
                               padding: const EdgeInsets.all(8.0),
                               child: Column(
                                 mainAxisAlignment: MainAxisAlignment.center,
                                 children: [
                                   Text("YOU OWE",style: TextStyle(
                                     color: Colors.white,fontSize: _width*0.05
                                   ),),
                                   FittedBox(
                                     child: Text('\$${calculate_total(owe_me)}',style: TextStyle(
                                         color: Colors.white,fontSize: _width*0.1
                                     ),),
                                   ),
                                 ],
                               ),
                             ),
                           ),
                         ),
                         Container(
                           width: _width*0.4,
                           height: _width*0.4,
                           decoration: BoxDecoration(
                               color: Colors.green,
                               shape: BoxShape.circle
                           ),
                           child: Center(
                             child: Padding(
                               padding: const EdgeInsets.all(8.0),
                               child: Column(
                                 mainAxisAlignment: MainAxisAlignment.center,
                                 children: [
                                   Text("OWE YOU",style: TextStyle(
                                       color: Colors.white,fontSize: _width*0.05
                                   ),),
                                   FittedBox(
                                     child: Text('\$${calculate_total(i_owe)}',style: TextStyle(
                                         color: Colors.white,fontSize: _width*0.1
                                     ),),
                                   ),
                                 ],
                               ),
                             ),
                           ),
                         ),
                       ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10),
                    child: Text('People you owe',style: TextStyle(
                      fontSize: _width*0.06,
                      fontWeight: FontWeight.w500

                    ),),
                  ),
                  Divider(
                    endIndent: 10,
                    indent: 10,
                    color: Colors.black,
                    thickness: 1,
                    height: 1,

                  ),
                  Expanded(
                    flex: 2,
                      child:ListView.builder(itemBuilder:  (context, index) {
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ListTile(
                        leading: CircleAvatar(
                          radius: 25,
                          backgroundColor: Colors.redAccent,
                        ),
                        title: Text(owe_me[index].name,style: TextStyle(
                          fontSize: _width*0.05,

                        ),),
                        trailing: FittedBox(
                          child: Text("\$${owe_me[index].amount}",style: TextStyle(
                            fontSize: _width*0.09,
                              fontFamily: "splash",
                            color: Colors.redAccent

                          ),),
                        ),
                      ),

                    );
                  },itemCount: owe_me.length,) ),
                  Padding(
                    padding: const EdgeInsets.all(10),
                    child: Text('People who owe you',style: TextStyle(
                        fontSize: _width*0.06,
                        fontWeight: FontWeight.w500

                    ),),
                  ),
                  Divider(
                    endIndent: 10,
                    indent: 10,
                    color: Colors.black,
                    thickness: 1,
                    height: 1,

                  ),
                  Expanded(
                      flex: 2,
                      child:ListView.builder(itemBuilder:  (context, index) {
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ListTile(
                        leading: CircleAvatar(
                          radius: 25,
                          backgroundColor: Colors.red,
                        ),
                        title: Text(i_owe[index].name,style: TextStyle(
                          fontSize: _width*0.05,

                        ),),
                        trailing: FittedBox(
                          child: Text("\$${i_owe[index].amount}",style: TextStyle(
                            fontSize: _width*0.09,
                            fontFamily: "splash",
                            color: Colors.green

                          ),),
                        ),
                      ),

                    );
                  },itemCount: i_owe.length,) ),
                ],
              )),
              Container(
                margin: EdgeInsets.only(bottom: 10,right: 10,left: 10),
                width: _width,
                height: _height*0.1,
                decoration: BoxDecoration(
                  color: Colors.grey.withOpacity(0.5),
                  borderRadius: BorderRadius.circular(25)
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Icon(Icons.history,size: _width*0.1,),
                    InkWell(child: FittedBox(child: Icon(Icons.add_circle_rounded,size: _width*0.2,color: Colors.green,)),
                    onTap: (){
                      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => add_screen(),));
                    },),

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
