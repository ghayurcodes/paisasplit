import 'dart:convert';

import 'package:blurrycontainer/blurrycontainer.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:provider/provider.dart';

import '../Hive data/Entry.dart';

class data_provider with ChangeNotifier{

  List<Entry>  i_take =[];
  List<Entry> i_give = [];
   double? recived;
  double? sent;
  List<double> current_month_data=[0,0];
  List<double> prev_month_data=[0,0];

  getHiveData() async {
    var box = await Hive.openBox('data');
    // Check if the data exists in the box
    String? oweMeJson = box.get('oweMe');
    String? iOweJson = box.get('iOwe');

    if (oweMeJson != null) {
      List<dynamic> oweMeList = jsonDecode(oweMeJson);
      i_take = oweMeList.map((e) => Entry.fromJson(e)).toList();
      print(i_take.length);
    }

    if (iOweJson != null) {
      List<dynamic> iOweList = jsonDecode(iOweJson);
      i_give = iOweList.map((e) => Entry.fromJson(e)).toList();
      print(i_give.length);
    }
    current_month_data=[0,0];
    List<double> prev_month_data=[0,0];
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
      print('i owe added');
    }

    else if(opt==1){
      i_take.add(temp);
      String oweMeJson = jsonEncode(i_take.map((e) => e.toJson()).toList());
      await box.put('oweMe', oweMeJson);
      print('owe mee added');

    }

    notifyListeners();
  }
  deleteEntry(Entry entry, int opt) async {
    var box = await Hive.openBox('data');

    if (opt == 0) {
      i_give.remove(entry);
      String iOweJson = jsonEncode(i_give.map((e) => e.toJson()).toList());
      await box.put('iOwe', iOweJson);
    } else if (opt == 1) {
      i_take.remove(entry);
      String oweMeJson = jsonEncode(i_take.map((e) => e.toJson()).toList());
      await box.put('oweMe', oweMeJson);
    }

    notifyListeners();
  }
  double calculate_total(List<Entry> s){
    double total=0;
    for(int i=0;i<s.length;i++){
      total+=s[i].amount;
    }

    return total;
  }

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
                            _provider.saveToHive(name.text.trim(), double.parse(amount.text.trim()), DateTime.now(),opt);
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






