import 'package:flutter/material.dart';
//import 'package:flutter/widgets.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:money_app/models/money.dart';
import 'package:money_app/screens/home_screen.dart';
import 'package:money_app/screens/main_screen.dart';
//import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final directory =await getApplicationDocumentsDirectory();
  Hive.init(directory.path);
  //await Hive.initFlutter();
  Hive.registerAdapter(MoneyAdapter());
  //Hive.box('moneyBox').add();
  await Hive.openBox<Money>('moneyBox');
  runApp(const MyApp());
}




class MyApp extends StatelessWidget {
  const MyApp({super.key});

  static void getData(){
    HomeScreen.moneys.clear();
    Box<Money> hiveBox = Hive.box<Money>('hiveBox');
    for (var value in hiveBox.values) {
      HomeScreen.moneys.add(value);
     }
    }


  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      // theme: ThemeData(fontFamily: 'SourceSansPro-Regular'),
      debugShowCheckedModeBanner: false,
      title: 'اپلیکیشن مدیریت مالی',
      home: MainScreen(
        
      ),
    );
  }
}








