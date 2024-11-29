import 'package:blurrycontainer/blurrycontainer.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive/hive.dart';


import 'Hive data/entry.dart';

class homepage extends StatefulWidget {
   homepage({super.key});

  @override
  State<homepage> createState() => _homepageState();
}

class _homepageState extends State<homepage> {
final _mybox=Hive.box<List<Entry>>('MoneySplit');

var name=TextEditingController();
var time;
var amount=TextEditingController();

List<Entry> owe_me=[];

List<Entry> i_owe=[];

  @override
  Widget build(BuildContext context) {
    var _height=MediaQuery.of(context).size.height;
    var _width=MediaQuery.of(context).size.width;

void store(){
  Entry temp=new Entry(name.text.trim(),double.parse(amount.text.trim()),DateTime.now());
  owe_me.add(temp);
  _mybox.put("entries", owe_me);
  print(owe_me.length);
  owe_me=_mybox.get("entries")!;
  // print(owe_me[0].name);

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
                              store();
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
            backgroundColor: Colors.white,
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
                                     child: Text('\$80',style: TextStyle(
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
                                     child: Text('\$240',style: TextStyle(
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

                  ),
                  Expanded(
                    flex: 3,
                      child:ListView.builder(itemBuilder:  (context, index) {
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ListTile(
                        leading: CircleAvatar(
                          radius: 25,
                          backgroundColor: Colors.redAccent,
                        ),
                        title: Text("Alex Trump",style: TextStyle(
                          fontSize: _width*0.05,

                        ),),
                        trailing: FittedBox(
                          child: Text("\$30",style: TextStyle(
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

                  ),
                  Expanded(
                      flex: 1,
                      child:ListView.builder(itemBuilder:  (context, index) {
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ListTile(
                        leading: CircleAvatar(
                          radius: 25,
                          backgroundColor: Colors.red,
                        ),
                        title: Text("Chris porter",style: TextStyle(
                          fontSize: _width*0.05,

                        ),),
                        trailing: FittedBox(
                          child: Text("\$30",style: TextStyle(
                            fontSize: _width*0.09,
                            fontFamily: "splash",
                            color: Colors.green

                          ),),
                        ),
                      ),

                    );
                  },itemCount: 1,) ),
                ],
              )),
              Container(
                margin: EdgeInsets.only(bottom: 10,right: 10,left: 10),
                width: _width,
                height: _height*0.1,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(25)
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Icon(Icons.history,size: _width*0.1,),
                    InkWell(child: FittedBox(child: Icon(Icons.add_circle_rounded,size: _width*0.2,color: Colors.green,)),
                    onTap: (){popup_add();},),

                    Icon(Icons.person,size: _width*0.1,),


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
