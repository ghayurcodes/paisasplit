import 'package:flutter_gemini/flutter_gemini.dart';
import 'package:hive/hive.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:paisasplit/money%20split/home_screen.dart';
import 'package:paisasplit/money%20split/provider/moneysplit_provider.dart';
import 'package:provider/provider.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  Gemini.init(apiKey: 'AIzaSyAA3pcD0vpvzej9k9ar5OA2Ek35EYiv15k');

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

