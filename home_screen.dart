// ignore_for_file: must_be_immutable

//import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
//import 'package:flutter/rendering.dart';
//import 'package:flutter/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:money_app/constant.dart';
import 'package:money_app/main.dart';
import 'package:money_app/models/money.dart';
import 'package:money_app/screens/new_transactions_screen.dart';
import 'package:searchbar_animation/searchbar_animation.dart';
import 'package:hive/hive.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  static List<Money> moneys = [
    //Money(id: 0, title: 'Test 1', price: '1000', data: '1400/01/01', isReceived: true),
    //Money(id: 1, title: 'Test 2', price: '2000', data: '1400/02/02', isReceived: false),
    //Money(id: 2, title: 'Test 3', price: '3000', data: '1400/03/03', isReceived: false),
  ];


  @override
  State<HomeScreen> createState() => _HomeScreenState();
}


class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController searchController = TextEditingController();
  Box<Money> hiveBox = Hive.box<Money>('moneyBox');

  @override
  void initState(){
    MyApp.getData();
    super.initState();
    //Hive.openBox('moneyBox');
  }

  @override
  void dispose() {
    Hive.box('moneyBox').close();
    super.dispose();
  }

  
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        floatingActionButton: fabWidget(),
        body: SizedBox(
          width:double.infinity,
          child:Column(children: [
            headerWidget(),
            //HeaderWidget(searchController: searchController),
            //const Expanded(child: EmptyWidget(),),
            Expanded(
              child: HomeScreen.moneys.isEmpty ? const EmptyWidget() :
               ListView.builder(itemCount: HomeScreen.moneys.length,itemBuilder: (context, index) {
                return GestureDetector(
                  //* Edit
                  onTap: () {
                    NewTransactionsScreen.date = HomeScreen.moneys[index].date;
                    NewTransactionsScreen.descriptionController.text = HomeScreen.moneys[index].title;
                    NewTransactionsScreen.priceController.text = HomeScreen.moneys[index].price;
                    NewTransactionsScreen.groupId = HomeScreen.moneys[index].isReceived ? 1 : 2;
                    NewTransactionsScreen.isEditing = true;
                    NewTransactionsScreen.id = HomeScreen.moneys[index].id;

                    Navigator.push(context, MaterialPageRoute(builder:(context)=> const NewTransactionsScreen())).
                    then((value) {
                      MyApp.getData();
                      setState(() {});
                    });
                  },

                  //* Delete
                  onLongPress: () {
                    setState(() {
                      //HomeScreen.moneys.removeAt(index);
                      showDialog(context: context, builder: (context) => AlertDialog(
                        title:const Text('آیا از حذف این آیتم مطمئن هستید؟',style: TextStyle(fontSize: 12.0),),
                        actionsAlignment: MainAxisAlignment.spaceBetween,
                        actions: [
                          TextButton(onPressed: (){
                            Navigator.pop(context);
                            }, child:const Text('خیر',style: TextStyle(color: Colors.black87),)),
                          TextButton(onPressed: (){
                            hiveBox.deleteAt(index);
                            MyApp.getData();
                            setState(() {
                              //HomeScreen.moneys.removeAt(index);
                            });
                            Navigator.pop(context);
                          }, child:const Text('بله',style: TextStyle(color: Colors.black87),)),
                        ],
                      ));
                    });
                  },
                  child: MyListTileWidget(index: index));
              },),
            )
            
          ],)
        ),
      ),
    );
  }

  //! FAB Widget
    Widget fabWidget(){
      return FloatingActionButton(
      backgroundColor: kPurpleColor,
      elevation: 0,
      onPressed: () {
        NewTransactionsScreen.date = 'تاریخ';
        NewTransactionsScreen.descriptionController.text = '';
        NewTransactionsScreen.priceController.text = '';
        NewTransactionsScreen.groupId = 0;
        NewTransactionsScreen.isEditing = false;
        Navigator.push(context,MaterialPageRoute(builder: (context) => const NewTransactionsScreen(),),).then(
          (value) {
            MyApp.getData();
            setState(() {
              //print('Refresh');
            });
          });
      },
      child:const Icon(Icons.add),
    );
  }
  //! Header Widget
  Widget headerWidget(){
    return Padding(
        padding: const EdgeInsets.only(right: 20,top: 10,left: 5),
        child: Row(children: [
        Expanded(
          child: SearchBarAnimation(
            hintText:'...جستجو کنید',
            buttonElevation: 0,
            buttonShadowColour: Colors.black26,
            buttonBorderColour: Colors.black26,
            //textEditingController: widget.searchController,
            // buttonIcon: Icons.search,
            onCollapseComplete: (){
              MyApp.getData();
              searchController.text = '';
              setState(() {});
            },
            onFieldSubmitted: (String text){
              List<Money> result = hiveBox.values.where((value) => value.title.contains(text) || value.date.contains(text),).toList();
              HomeScreen.moneys.clear();

              setState(() {
                for (var value in result) {
                  HomeScreen.moneys.add(value);
                }
              });
            },
            isOriginalAnimation: false,
            trailingWidget: const Icon(
                        Icons.search,
                        size: 20,
                        color: Colors.black,
                      ),secondaryButtonWidget: const Icon(
                        Icons.close,
                        size: 20,
                        color: Colors.black,
                      ),
                      buttonWidget: const Icon(
                        Icons.search,
                        size: 20,
                        color: Colors.black,
                      ),
            textEditingController:searchController,
         ),
       ),
        const SizedBox(width: 10,),
        const Text('تراکنش ها'),
      ],),
    );
  }
}

//! My ListTile Widget
class MyListTileWidget extends StatelessWidget {
  // const MyListTileWidget({
  //   super.key,
  // });

  final int index;
  const MyListTileWidget({super.key, required this.index});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(children: [
        Container(
          width: 50.0,
          height: 50.0,
          decoration: BoxDecoration(
            color: HomeScreen.moneys[index].isReceived ? kGreenColor : kRedColor,
            borderRadius: BorderRadius.circular(15.0),
          ),
          child: Center(
            child: Icon(
              HomeScreen.moneys[index].isReceived ? Icons.add : Icons.remove,
              color: Colors.white,
              size: 30.0,
            ),
          )
        ),
         Padding(
          padding:const EdgeInsets.only(left: 15.0),
          child: Text(HomeScreen.moneys[index].title),
          ),
        const Spacer(),  
       Column(
          children: [
            Row(
              children: [
                const Text('تومان',style: TextStyle(fontSize: 14.0,color:kRedColor),),
                Text(HomeScreen.moneys[index].price,style:const TextStyle(fontSize:14.0,color:kRedColor),),
              ],
            ),
            Text(HomeScreen.moneys[index].date),
          ],
        )
      ],),
    );
  }
}
//! Floating Action Button

// class MyFloatingActionButton extends StatefulWidget {
//   const MyFloatingActionButton({
//     super.key,
//   });

//   @override
//   State<MyFloatingActionButton> createState() => _MyFloatingActionButtonState();
// }

// class _MyFloatingActionButtonState extends State<MyFloatingActionButton> {
//   @override
//   Widget build(BuildContext context) {
//     return FloatingActionButton(
//       backgroundColor: kPurpleColor,
//       elevation: 0,
//       onPressed: () {
//         NewTransactionsScreen.descriptionController.text = '';
//         NewTransactionsScreen.priceController.text = '';
//         NewTransactionsScreen.groupId = 0;
//         Navigator.push(context,MaterialPageRoute(builder: (context) => const NewTransactionsScreen(),),).then(
//           (value) {
//             setState(() {
//               print('Refresh');
//             });
//           });
//       },
//       child:const Icon(Icons.add),
//     );
//   }
// }
//! Header Widget
// class HeaderWidget extends StatefulWidget {
//    const HeaderWidget({
//     super.key,
//     required this.searchController,
//   });

//   final TextEditingController searchController;

//   @override
//   State<HeaderWidget> createState() => _HeaderWidgetState();
// }

// class _HeaderWidgetState extends State<HeaderWidget> {
//   Box<Money> hiveBox = Hive.box<Money>('moneyBox');

//   @override
//   Widget build(BuildContext context) {
//     return 
//   }
// }

//! Empty Widget
class EmptyWidget extends StatelessWidget {
  const EmptyWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Spacer(),
        SvgPicture.asset('assets/images/undraw_savings_re_eq4w.svg',height: 280,width: 240,),
        const SizedBox(height: 20,),
        const Text('! تراکنشی موجود نیست '),
        const Spacer(),
      ],
    );
  }
}




















