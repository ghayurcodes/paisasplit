import 'package:flutter/material.dart';
import 'package:intl/date_symbols.dart';
import 'package:intl/intl.dart';
import 'package:paisasplit/money%20split/home_screen.dart';

class user_screen extends StatelessWidget {
  const user_screen({super.key});

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
                              child: CircleAvatar(
                                backgroundColor: Colors.redAccent,
                                radius:_width*0.15,
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
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(25),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    InkWell(child: Icon(Icons.history,size: _width*0.1,),onTap: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => homepage(),));
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
