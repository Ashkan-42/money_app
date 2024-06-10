//import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
//import 'package:flutter/widgets.dart';

class InfoScreen extends StatefulWidget {
  const InfoScreen({super.key});

  @override
  State<InfoScreen> createState() => _InfoScreenState();
}

class _InfoScreenState extends State<InfoScreen> {
  @override
  Widget build(BuildContext context) {
    return const SafeArea(
      child: Scaffold(
        body: SizedBox(width: double.infinity,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Padding(
              padding: EdgeInsets.only(right: 15.0,top: 15.0,left: 5.0),
              child: Text('مدیریت تراکنش ها به تومان'),
            ),
            MoneyInfoWidget(firstText: ': دریافتی امروز',firstPrice: '0',secondText: ': پرداختی امروز',secondPrice: '0'),
            MoneyInfoWidget(firstText: ': دریافتی این ماه',firstPrice: '0',secondText: ': پرداختی این ماه',secondPrice: '0'),
            MoneyInfoWidget(firstText: ': دریافتی امسال',firstPrice: '0',secondText: ': پرداختی امسال',secondPrice: '0'),
          ],
        ),),
      ),
    );
  }
}
// Money Info Widget
class MoneyInfoWidget extends StatelessWidget {
  final String firstText;
  final String secondText;
  final String firstPrice;
  final String secondPrice;

  const MoneyInfoWidget({super.key, required this.firstText,required this.secondText,required this.firstPrice,required this.secondPrice});

  // const MoneyInfoWidget({
  //   super.key,
  // });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:const EdgeInsets.only(right: 20.0,top: 20.0,left: 20.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Expanded(child: Text(secondPrice,textAlign: TextAlign.right,style:const TextStyle(fontSize: 12.0),)),
          Text(secondText,textAlign: TextAlign.right,style:const TextStyle(fontSize: 12.0),),
          Expanded(child: Text(firstPrice,textAlign: TextAlign.right,style:const TextStyle(fontSize: 12.0),)),
          Text(firstText,style:const TextStyle(fontSize: 12.0),),
        ],
      ),
    );
  }
}





