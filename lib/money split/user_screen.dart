
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:page_transition/page_transition.dart';
import 'package:paisasplit/money%20split/add_entry_screen.dart';
import 'package:paisasplit/money%20split/home_screen.dart';
import 'package:paisasplit/money%20split/provider/moneysplit_provider.dart';
import 'package:pie_chart/pie_chart.dart';
import 'package:provider/provider.dart';

class user_screen extends StatefulWidget {
  const user_screen({super.key});

  @override
  State<user_screen> createState() => _user_screenState();
}

class _user_screenState extends State<user_screen> {



  @override
  Widget build(BuildContext context) {
    var _height = MediaQuery.of(context).size.height;
    var _width = MediaQuery.of(context).size.width;
    final previousMonth = DateTime(DateTime.now().year, DateTime.now().month - 1);
    var valuee=Provider.of<data_provider>(context, listen: false);

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(

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
            child: InkWell(child: Icon(Icons.more_vert_rounded),
            onTap: (){
              showDialog(context: context, builder: (context) {
                return AlertDialog(
                  title: Center(child: Text("Group Members")),
                  content: Container(
                    width: 300,
                     height: 200,
                     decoration: BoxDecoration(
                        color: Colors.grey,
                       borderRadius: BorderRadius.circular(25),
                     ),
                    child: Center(
                       child: Column(
                         mainAxisAlignment: MainAxisAlignment.center,
                         
                         children: [
                           Text("Syed Gahyur Hussain",style: stylee(),),
                           Text("M.saad",style: stylee(),),
                           Text("abdul Ahad",style: stylee(),),


                         ],
                       ),
                    ),
                  ),
                );
              },);
            },),
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
                            Consumer<data_provider>(builder: (context, value, child) {
                              return Container(
                                margin: EdgeInsets.all(20),
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Color(0xfff94c61),
                                ),
                                padding: EdgeInsets.all(3),
                                child: value.imageFile == null
                                    ? InkWell(
                                  onTap: () {
                                    value.pickImage();
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
                                    : InkWell(
                                  onLongPress: (){
                                    value.pickImage();
                                  },
                                      child: CircleAvatar(
                                        radius: _width * 0.15,
                                        backgroundImage: FileImage(value.imageFile!,)
                                        as ImageProvider,

                                      ),
                                    ),
                              );
                            },),
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
                      child:Image.asset('assets/images/home-page.png',width:  _width*0.09),
                      onTap: () {
                        Navigator.pushReplacement(context, PageTransition(child: homepage(), type: PageTransitionType.leftToRight));
                      },
                    ),
                    InkWell(
                      child: Image.asset('assets/images/technical-support.png',width:  _width*0.2,),
                      onTap: () {
                        Navigator.pushReplacement(context, PageTransition(child: add_screen(), type: PageTransitionType.leftToRight));
                      },
                    ),
                    Image.asset('assets/images/person.png',width:  _width*0.09),
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
