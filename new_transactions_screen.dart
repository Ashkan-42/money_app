import 'dart:math';

//import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
//import 'package:flutter/rendering.dart';
//import 'package:flutter/widgets.dart';
//import 'package:flutter/src/material/colors.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:money_app/constant.dart';
import 'package:money_app/main.dart';
import 'package:money_app/models/money.dart';
//import 'package:money_app/screens/home_screen.dart';
import 'package:persian_datetime_picker/persian_datetime_picker.dart';
import 'package:hive/hive.dart';







class NewTransactionsScreen extends StatefulWidget {
  const NewTransactionsScreen({super.key});

  static int groupId = 0;

  static TextEditingController descriptionController = TextEditingController();
  static TextEditingController priceController = TextEditingController();

  static bool isEditing = false;
  static int id = 0;

  static String date='تاریخ';

  @override
  State<NewTransactionsScreen> createState() => _NewTransactionsScreenState();
}

class _NewTransactionsScreenState extends State<NewTransactionsScreen> {
  Box<Money> hiveBox = Hive.box<Money>('moneyBox');
  @override
  Widget build(BuildContext context) {
    //print(NewTransactionsScreen.id);
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Container(
          width: double.infinity,
          margin: const EdgeInsets.all(15.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children:[
                Text(NewTransactionsScreen.isEditing ? 'ویرایش تراکنش' : 'تراکنش جدید',style:const TextStyle(fontSize: 18.0),),
                MyTextField(hintText: 'توضیحات',controller: NewTransactionsScreen.descriptionController,),
                MyTextField(hintText: 'مبلغ',type: TextInputType.number,controller: NewTransactionsScreen.priceController,),
                const TypeAndDateWidget(),
                MyButton(text: NewTransactionsScreen.isEditing ? 'ویرایش کردن' : 'اضافه کردن',onPressed: () {
                  //HomeScreen.moneys.add();
                  Money item = Money(
                      id: Random().nextInt(99999999),
                      title: NewTransactionsScreen.descriptionController.text,
                      price: NewTransactionsScreen.priceController.text,
                      date: NewTransactionsScreen.date,
                      isReceived: NewTransactionsScreen.groupId == 1 ? true : false,
                      );
                    if(NewTransactionsScreen.isEditing){
                      //HomeScreen.moneys[NewTransactionsScreen.index] = item;
                      int index = 0 ;
                      MyApp.getData();
                      for(int i = 0; i < hiveBox.values.length; i++){
                        if(hiveBox.values.elementAt(i).id == NewTransactionsScreen.id){
                          index = i;
                        }
                      }
                      hiveBox.putAt(index, item);
                    }
                    else{
                      //HomeScreen.moneys.add(item);
                      hiveBox.add(item);
                    }
                    Navigator.pop(context);
                },),
            ],
          ),
        ),
      ),
    );
  }
}

class MyButton extends StatelessWidget {
  final String text;
  final Function() onPressed;
  const MyButton({super.key, required this.text,required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
     width: double.infinity,
     child: ElevatedButton(
       style: TextButton.styleFrom(
         backgroundColor:kPurpleColor,
         elevation:0,
       ),
       onPressed: onPressed, child: Text(text,style:const TextStyle(color: Colors.black87) ,)
       ),
     );
  }
}

class TypeAndDateWidget extends StatefulWidget {
  const TypeAndDateWidget({
    super.key,
  });

  @override
  State<TypeAndDateWidget> createState() => _TypeAndDataWidgetState();
}

class _TypeAndDataWidgetState extends State<TypeAndDateWidget> {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: MyRadioButton(value: 1,groupValue: NewTransactionsScreen.groupId,onChanged: (value){setState(() {
            NewTransactionsScreen.groupId = value!;
          });},text: 'دریافتی',),
        ),
        const SizedBox(width: 10,),
        Expanded(
          child: MyRadioButton(value: 2,groupValue: NewTransactionsScreen.groupId,onChanged: (value){setState(() {
            NewTransactionsScreen.groupId = value!;
          });},text: 'پرداختی',),
        ),
        const SizedBox(width: 10.0,),
        Expanded(
          child: OutlinedButton(
            onPressed:() async {
            var pickedDate = await showPersianDatePicker(context: context, initialDate: Jalali.now(), firstDate: Jalali(1403), lastDate: Jalali(1499));
            setState(() {
              String year = pickedDate!.year.toString();
              String month = pickedDate.month.toString().length == 1 ? '0 ${pickedDate.month.toString()}' : pickedDate.month.toString();
              String day = pickedDate.day.toString().length == 1 ? '0 ${pickedDate.day.toString()}' : pickedDate.day.toString();
              NewTransactionsScreen.date = '$year/$month/$day';
            });
          }, child: Text(NewTransactionsScreen.date == 'تاریخ' ? 'تاریخ' : NewTransactionsScreen.date,
          style:const TextStyle(color: Colors.black,fontSize: 12),)
          ),
        ),
      ],
    );
  }
}



class MyRadioButton extends StatelessWidget {
  final int value;
  final int groupValue;
  final Function(int?) onChanged;
  final String text;

  const MyRadioButton({super.key, required this.value,required this.groupValue,required this.onChanged,required this.text});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Expanded(child: Radio(activeColor: kPurpleColor,value: value, groupValue: groupValue, onChanged:onChanged)),
        Text(text),
    ],
    );
  }
}



class MyTextField extends StatelessWidget {
  final String hintText;
  final TextInputType type;
  final TextEditingController controller;
  const MyTextField({super.key,required this.controller,required this.hintText,this.type = TextInputType.text});

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      keyboardType: type,
      cursorColor: Colors.black38,
      decoration: InputDecoration(
      border:const UnderlineInputBorder(
      borderSide: BorderSide(color:Colors.blueGrey),
     ),
      enabledBorder:const UnderlineInputBorder(
        borderSide: BorderSide(color:Colors.blueGrey),
     ),
      focusedBorder:const UnderlineInputBorder(
        borderSide: BorderSide(color:Colors.blueGrey),
     ),
     hintText: hintText,
      ),
    );
  }
}




















