import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
import 'package:flutter/material.dart';
//import 'package:hive_flutter/hive_flutter.dart';
//import 'package:money_app/models/money.dart';
import 'package:money_app/screens/home_screen.dart';
import 'package:money_app/screens/info_screen.dart';
//import 'package:hive/hive.dart';


class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int currentIndex = 0;
  Widget body = const HomeScreen();
  //Box<Money> hiveBox = Hive.box<Money>('moneyBox');
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        bottomNavigationBar: AnimatedBottomNavigationBar(
          inactiveColor: Colors.black54,
          icons:const [Icons.home,Icons.info],
          activeIndex: currentIndex,
          gapLocation: GapLocation.center,
          notchSmoothness: NotchSmoothness.smoothEdge,
          onTap: (index){
            if(index == 0) {
              body = const HomeScreen();
            }
            else{
              body = const InfoScreen();
            }
            setState(() {
              currentIndex = index;
            });
          },
        ),
        body: body,
      ),
    );
  }
}










