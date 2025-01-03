import 'dart:convert';

import 'package:blurrycontainer/blurrycontainer.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive/hive.dart';
import 'package:page_transition/page_transition.dart';
import 'package:paisasplit/money%20split/add_entry_screen.dart';
import 'package:paisasplit/money%20split/provider/moneysplit_provider.dart';
import 'package:paisasplit/money%20split/user_screen.dart';
import 'package:provider/provider.dart';
import 'package:swipeable_tile/swipeable_tile.dart';


class homepage extends StatefulWidget {
  homepage({super.key});

  @override
  State<homepage> createState() => _homepageState();
}

class _homepageState extends State<homepage> {
  var name = TextEditingController();
  var amount = TextEditingController();





  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      Provider.of<data_provider>(context, listen: false).getHiveData();
    });
  }


  @override
  Widget build(BuildContext context) {
    var _height=MediaQuery.of(context).size.height;
    var _width=MediaQuery.of(context).size.width;


    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
          title: FittedBox(child: Text("Money Mate",style: TextStyle(
            fontSize: _width*0.09,
            fontFamily: "Meme",
            fontWeight: FontWeight.w600
          ),),),
        centerTitle: true,

      ),
      body: Container(
        width: double.maxFinite,
        height: double.maxFinite,
        color: Colors.white,
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
                         InkWell(
                           onTap: (){
                             popup_add(context, _height, _width, name, amount,0);
                           },
                           child: Consumer<data_provider>(builder: (context, value, child) {
                             return Container(
                               width: _width*0.4,
                               height: _width*0.4,
                               decoration: BoxDecoration(
                                   color: Color(0xfff94c61),
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
                                         child: Text('\$${value.calculate_total(value.i_give)}',style: TextStyle(
                                             color: Colors.white,fontSize: _width*0.1
                                         ),),
                                       ),
                                     ],
                                   ),
                                 ),
                               ),
                             );
                           },),
                         ),
                         InkWell(
                           onTap: (){
                             popup_add(context, _height, _width, name, amount,1);
                           },
                           child: Consumer<data_provider>(builder: (context, value, child) {
                             return Container(
                               width: _width*0.4,
                               height: _width*0.4,
                               decoration: BoxDecoration(
                                   color: Color(0xff529854),
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
                                         child: Text('\$${value.calculate_total(value.i_take)}',style: TextStyle(
                                             color: Colors.white,fontSize: _width*0.1
                                         ),),
                                       ),
                                     ],
                                   ),
                                 ),
                               ),
                             );

                           },),
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
                      child:Consumer<data_provider>(builder: (context, value, child) {
                        return ListView.builder(itemBuilder:  (context, index) {
                          return Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: SwipeableTile(
                              key: UniqueKey(),
                              backgroundBuilder: (context, direction, progress) {
                                return Container(
                                );
                              },
                               color: Colors.transparent,
                              swipeThreshold: 0.3,
                              isElevated: true,
                              direction: SwipeDirection.horizontal,
    onSwiped: (direction) {
    if (direction == SwipeDirection.endToStart) {
    // Show edit confirmation before deletion
    value.deleteEntry(value.i_give[index], 0, context);
    } else if (direction == SwipeDirection.startToEnd) {
    // Show edit confirmation before deletion for this case as well
    value.deleteEntry(value.i_give[index], 0, context);
    // Add functionality for "remove in upper part" if needed
    }
    },
                              borderRadius: 10,



                              child: ListTile(
                                leading: CircleAvatar(
                                  radius: 25,
                                  child: Image.asset('assets/images/give_moneyy.png',fit: BoxFit.contain,height: 40,),
                                  backgroundColor: Colors.transparent,
                                ),
                                title: Text(value.i_give[index].name,style: TextStyle(
                                  fontSize: _width*0.05,

                                ),),
                                trailing: FittedBox(
                                  child: Text("\$${value.i_give[index].amount}",style: TextStyle(
                                      fontSize: _width*0.09,
                                      color: Colors.redAccent

                                  ),),
                                ),
                              ),
                            ),

                          );
                        },itemCount: value.i_give.length??0,);
                      },) ),
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
                      child:Consumer<data_provider>(builder: (context, value, child) {
                        return ListView.builder(itemBuilder:  (context, index) {
                          return Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: SwipeableTile(
                              backgroundBuilder: (context, direction, progress) {
                                return Container();
                              },
                              color: Colors.transparent,
                              borderRadius: 10,
                              swipeThreshold: 0.3,
                              isElevated: true,
                              direction: SwipeDirection.horizontal,
                              onSwiped: (direction) {
                                if (direction == SwipeDirection.endToStart) {
                                  // Show edit confirmation before deletion
                                  value.deleteEntry(value.i_take[index], 1, context);
                                } else if (direction == SwipeDirection.startToEnd) {
                                  // Show edit confirmation before deletion for this case as well
                                  value.deleteEntry(value.i_take[index], 1, context);
                                  // Add functionality for "remove in upper part" if needed
                                }
                              },



                              key: UniqueKey(),
                              child: ListTile(
                                leading: CircleAvatar(
                                  radius: 25,
                                  child: Image.asset('assets/images/take_money.png',fit: BoxFit.contain,height: 100,),
                                  backgroundColor: Colors.transparent,
                                ),
                                title: Text(value.i_take[index].name,style: TextStyle(
                                  fontSize: _width*0.05,
                              
                                ),),
                                trailing: FittedBox(
                                  child: Text("\$${value.i_take[index].amount}",style: TextStyle(
                                      fontSize: _width*0.09,
                                      color: Colors.green
                              
                                  ),),
                                ),
                              ),
                            ),

                          );
                        },itemCount: value.i_take.length??0,);
                      },) ),
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
                    Image.asset('assets/images/home-page.png',width:  _width*0.09),
                    InkWell(child: Image.asset('assets/images/technical-support.png',width:  _width*0.2,),
                    onTap: (){
                      Navigator.pushReplacement(context, PageTransition(child: add_screen(), type: PageTransitionType.rightToLeft));
                    },),

                    InkWell(child: Image.asset('assets/images/person.png',width:  _width*0.09),onTap: () {
                      Navigator.pushReplacement(context, PageTransition(child: user_screen(), type: PageTransitionType.rightToLeft));
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
