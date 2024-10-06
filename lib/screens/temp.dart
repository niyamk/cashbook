/*
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';

class Testing extends StatefulWidget {
  const Testing({Key? key, required this.list}) : super(key: key);
  final List list;

  @override
  State<Testing> createState() => _TestingState();
}

class _TestingState extends State<Testing> {
  Color selectedColor = Color(0xff00000);
  final GlobalKey<AnimatedListState> listKey = GlobalKey<AnimatedListState>();
  late List list;
  List item = [
    1,
    2,
  ];
  List<double> cashIn = [];
  List<double> cashOut = [];
  int counter = 0;

  @override
  void initState() {
    list = widget.list;
    print(list);
    cashInOutSep();
    print(list);
    super.initState();
  }

  cashInOutSep() {
    for (var i = 0; i < list.length; i++) {
      if (double.parse(list[i].toString().split('_')[1]) >= 0) {
        cashIn.add(double.parse(list[i].toString().split('_')[1]));
      } else {
        cashOut.add(double.parse(list[i].toString().split('_')[1]).abs());
      }
    }
    print(
        ' cashIn -->>${cashIn}  ${cashIn.isEmpty} \n cashOut -->> ${cashOut == []} ');
  }

  @override
  Widget build(BuildContext context) {
    // List list = widget.list;
    // log(list.toString());
    return Scaffold(
      // floatingActionButton: FloatingActionButton(
      //   onPressed: () {
      //     listKey.currentState
      //         ?.insertItem(0, duration: const Duration(milliseconds: 900));
      //     item = []
      //       ..add(counter++)
      //       ..addAll(item);
      //   },
      // ),
      appBar: AppBar(
        title: Text('Charts'),
      ),
      body: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Stack(
            children: [
              SizedBox(
                height: 300,
                width: 100.w,
                child: PieChart(
                  swapAnimationCurve: Curves.fastOutSlowIn,
                  swapAnimationDuration: Duration(seconds: 1),
                  PieChartData(
                    sections: [
                      PieChartSectionData(
                          value: cashIn.isNotEmpty
                              ? cashIn
                                  .reduce((value, element) => value + element)
                              : 0,
                          radius: selectedColor == Color(0xff00c853) ? 100 : 80,
                          color: Colors.greenAccent.shade700),
                      PieChartSectionData(
                          value: cashOut.isNotEmpty
                              ? cashOut
                                  .reduce((value, element) => value + element)
                              : 0,
                          radius: selectedColor == Color(0xffff5252) ? 100 : 80,
                          color: Colors.redAccent.shade200),
                    ],
                    centerSpaceRadius: 10,
                    borderData: FlBorderData(
                      border: Border.all(width: 5, color: Colors.black),
                    ),
                    pieTouchData: PieTouchData(
                      // enabled: true,
                      touchCallback: (p0, p1) {
                        setState(() {});
                        print(p1?.touchedSection?.touchedSection?.color);
                        if (p1 != null) {
                          if (p1.touchedSection!.touchedSection != null) {
                            selectedColor =
                                p1.touchedSection!.touchedSection!.color;
                          }
                        }
                        // print(
                        //     '${p0.isInterestedForInteractions},${p1!.touchedSection!}');
                      },
                    ),
                  ),
                ),
              ),
              Positioned(
                top: 3,
                left: 3,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    cashIn.isNotEmpty
                        ? Row(
                            children: [
                              Text('Cash In : '),
                              CircleAvatar(
                                radius: 5,
                                backgroundColor: Colors.greenAccent.shade400,
                              )
                            ],
                          )
                        : Container(),
                    cashOut.isNotEmpty
                        ? Row(
                            children: [
                              Text('Cash Out : '),
                              CircleAvatar(
                                radius: 5,
                                backgroundColor: Colors.redAccent.shade200,
                              )
                            ],
                          )
                        : Container(),
                  ],
                ),
              ),
            ],
          ),
          // Expanded(
          //   child: AnimatedList(
          //     key: listKey,
          //     shrinkWrap: true,
          //     scrollDirection: Axis.vertical,
          //     initialItemCount: item.length,
          //     itemBuilder: (context, index, animation) {
          //       return SlideTransition(
          //         position: Tween<Offset>(
          //           begin: Offset(1, 1),
          //           end: Offset(0, 0),
          //         ).animate(animation),
          //         child: SizedBox(
          //           // Actual widget to display
          //           height: 128.0,
          //           child: Card(
          //             color: Colors
          //                 .primaries[item[index] % Colors.primaries.length],
          //             child: Center(
          //               child: Text('Item ${item[index]}'),
          //             ),
          //           ),
          //         ),
          //       );
          //     },
          //   ),
          // ),
        ],
      ),
    );
  }
}
*/
