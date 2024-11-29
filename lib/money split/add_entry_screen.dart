import 'package:flutter/material.dart';
import 'package:intl/date_symbols.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:paisasplit/money%20split/user_screen.dart';

import 'home_screen.dart';

class add_screen extends StatelessWidget {
  const add_screen({super.key});

  @override
  Widget build(BuildContext context) {
    var _height = MediaQuery.of(context).size.height;
    var _width = MediaQuery.of(context).size.width;



    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: FittedBox(
          child: Text("Add bill",style: TextStyle(
              fontSize: _width*0.08,
              fontFamily: "Meme",
              fontWeight: FontWeight.w600
          ),),
        ),
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
        color: Colors.grey,
        child: Center(
          child: Column(
            children: [
              Expanded(
                child: Container(
                  color: Colors.green,
                  child: Center(
                    child: Lottie.asset("assets/gifs/iamge_add.json"),
                  ),
                )
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
