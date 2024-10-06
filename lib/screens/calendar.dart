import 'dart:convert';
import 'dart:developer';

import 'package:cashbook/sharedPref.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';

class pCalendar extends StatefulWidget {
  const pCalendar({Key? key, required this.list1}) : super(key: key);
  final List list1;

  @override
  State<pCalendar> createState() => _pCalendarState();
}

class _pCalendarState extends State<pCalendar> {
  CalendarFormat cf = CalendarFormat.month;
  var _selectedDay = DateTime.now();
  var _focusedDay = DateTime.now().subtract(Duration(days: 2));
  Map<String, List> eventsAccDate = {};

  /*List list = [
    'niyam_100_2023-04-26 00:00:00.000z',
    'phoenix_200_2023-04-09 00:00:00.000Z',
    'phoenix_200_2023-04-27 00:00:00.000Z'
  ];*/

  GettingData() {
    String? date;
    for (var i = 0; i < list.length; i++) {
      date = list[i].toString().split('_')[2].split(' ')[0];
      log(date);
      if (eventsAccDate[date] == null) {
        eventsAccDate[date] = [
          {
            'name': list[i].toString().split('_')[0],
            'amount': list[i].toString().split('_')[1],
          }
        ];
        print(eventsAccDate);
      } else {
        eventsAccDate[date]?.add({
          'name': list[i].toString().split('_')[0],
          'amount': list[i].toString().split('_')[1],
        });
      }
    }
  }

  late List list;

  @override
  void initState() {
    list = widget.list1;
    GettingData();

    super.initState();
  }

  // late List list;
  //
  // Future GetList() async {
  //   List<String>? _list = await SharedPref.getList();
  //   _list == null ? list = [] : list = _list;
  //   print('phoenix pro------ $_list');
  // }

  List _listOfDayEvents(DateTime dateTime) {
    if (eventsAccDate[DateFormat('yyyy-MM-dd').format(dateTime)] != null) {
      return eventsAccDate[DateFormat('yyyy-MM-dd').format(dateTime)]!;
    } else {
      return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    // print('selected date --->>> $_selectedDay');
    log('selected dte --->>> ${_selectedDay}');
    List dateList = [];
    for (var i = 0; i < list.length; i++) {
      if (_selectedDay.toString().split(' ')[0] ==
          list[i].toString().split('_')[2].split(' ')[0]) {
        dateList.add(list[i].toString().split('_')[2].split(' ')[0]);
      }
    }

    /* String? date;
    for (var i = 0; i < list.length; i++) {
      date = list[i].toString().split('_')[2].split(' ')[0];
      log(date);
      if (eventsAccDate[date] == null) {
        eventsAccDate[date] = [
          {
            'name': list[i].toString().split('_')[0],
            'amount': list[i].toString().split('_')[1],
          }
        ];
        print(eventsAccDate);
      } else {
        eventsAccDate[date]?.add({
          'name': list[i].toString().split('_')[0],
          'amount': list[i].toString().split('_')[1],
        });
      }
    }

    List _listOfDayEvents(DateTime dateTime) {
      if (eventsAccDate[DateFormat('yyyy-MM-dd').format(dateTime)] != null) {
        return eventsAccDate[DateFormat('yyyy-MM-dd').format(dateTime)]!;
      } else {
        return [];
      }
    }
*/
    print('phoenix bro --->> ${eventsAccDate.length}');
    return Scaffold(
      appBar: AppBar(
        title: Text('Calendar'),
      ),
      body: Column(
        children: [
          TableCalendar(
            pageAnimationCurve: Curves.easeIn,
            pageAnimationDuration: Duration(milliseconds: 500),
            calendarStyle:
                CalendarStyle(markersAlignment: Alignment.bottomRight),
            calendarBuilders: CalendarBuilders(
              markerBuilder: (context, day, events) {
                log(events.toString());
                if (events.isEmpty) {
                  return Container();
                } else {
                  return Container(
                    width: 15,
                    height: 15,
                    decoration: BoxDecoration(
                      color: Colors.blue.withOpacity(.6),
                      borderRadius: BorderRadius.circular(3),
                    ),
                    child: Center(
                      child: Text(
                        events.length.toString(),
                        style: TextStyle(color: Colors.white, fontSize: 10),
                      ),
                    ),
                  );
                }
              },
              /* singleMarkerBuilder: (context, day, event) {
                return CircleAvatar(
                  backgroundColor: Colors.purple.shade200,
                  radius: 20,
                );
              },*/
            ),
            focusedDay: DateTime.utc(2023, 04, 26),
            firstDay: DateTime.utc(2000),
            lastDay: DateTime.utc(2080),
            calendarFormat: cf,
            formatAnimationCurve: Curves.fastLinearToSlowEaseIn,
            formatAnimationDuration: Duration(seconds: 2),
            onFormatChanged: (value) {
              cf = value;
              setState(() {});
            },
            selectedDayPredicate: (day) {
              return isSameDay(_selectedDay, day);
            },
            onDaySelected: (selectedDay, focusedDay) {
              setState(() {
                _selectedDay = selectedDay;
                _focusedDay = focusedDay; // update `_focusedDay` here as well
              });
            },
            eventLoader: _listOfDayEvents,
          ),
          ..._listOfDayEvents(_selectedDay).map((myEvents) => ListTile(
                // tileColor: Colors.,
                title: Text(
                  myEvents['name'],
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                trailing: Text(
                  '₹ ${double.parse(myEvents['amount']).abs()}',
                  style: TextStyle(
                    color: double.parse(myEvents['amount']) >= 0
                        ? Colors.greenAccent.shade700
                        : Colors.redAccent.shade100,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ))
          /*Flexible(
            child: ListView.builder(
              itemCount: dateList.length,
              itemBuilder: (BuildContext context, int index) {
                return ListTile(
                  title: Text('olla'),
                  tileColor: Colors.red,
                );
              },
            ),
          ),*/
        ],
      ),
    );
  }
}
