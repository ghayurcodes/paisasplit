import 'dart:math';
import 'package:hive/hive.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:paisasplit/money%20split/add_entry_screen.dart';
import 'package:paisasplit/money%20split/home_screen.dart';
import 'package:paisasplit/money%20split/provider/moneysplit_provider.dart';
import 'package:provider/provider.dart';

import 'money split/Hive data/entry.dart';

void main() async {
  await Hive.initFlutter();


   Hive.registerAdapter(EntryAdapter());

  // Open the box only once, and keep it open throughout the app
  var entryBox = await Hive.openBox<List<Entry>>('MoneySplit');

  // Now run the app
  runApp(MyApp());
}


class MyApp extends StatelessWidget {
  const MyApp({super.key});


  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
      ChangeNotifierProvider(create: (context) => data_provider(),)
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: homepage(),
      ),
    );
  }
}

