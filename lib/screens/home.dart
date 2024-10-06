/*
import 'dart:developer';
import 'dart:ui';
import 'package:cashbook/main.dart';
import 'package:cashbook/screens/splash.dart';
import 'package:cashbook/screens/temp.dart';
import 'package:cashbook/screens/calendar.dart';
import 'package:cashbook/sharedPref.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:sizer/sizer.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({
    Key? key,
  }) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _cashInCash = TextEditingController();
  final _cashInName = TextEditingController();

  final _cashOutCash = TextEditingController();
  final _cashOutName = TextEditingController();

  final _formKey = GlobalKey<FormState>();
  final _globalKey = GlobalKey<ScaffoldState>();

  // late bool dark;

  @override
  void initState() {
    SharedPref.setNewUser();
    print('state called ---- $dark');
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        final value = await showDialog<bool>(
            context: context,
            builder: (context) {
              return AlertDialog(
                content: Text('Are you sure you want to exit?'),
                actions: <Widget>[
                  TextButton(
                    child: Text('No'),
                    onPressed: () {
                      Navigator.of(context).pop(false);
                    },
                  ),
                  TextButton(
                    child: Text('Yes'),
                    onPressed: () {
                      Navigator.of(context).pop(true);
                      SharedPref.setTheme(theme: dark ? 'dark' : 'light');
                    },
                  ),
                ],
              );
            });
        return value == true;
      },
      child: StatefulBuilder(
        builder:
            (BuildContext context, void Function(void Function()) newSetState) {
          double netCash = 0;
          for (var i = 0; i < list.length; i++) {
            netCash = netCash + double.parse(list[i].toString().split('_')[1]);
          }
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            theme: ThemeData(
              // useMaterial3: true,

              primaryColor: Color(0xffb100cd),
              inputDecorationTheme: InputDecorationTheme(
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(width: 2, color: themeColor()),
                  borderRadius: BorderRadius.circular(10),
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ).copyWith(
              colorScheme: ThemeData().colorScheme.copyWith(
                    primary: themeColor(),
                  ),
            ),
            darkTheme: ThemeData(
              brightness: Brightness.dark,
              inputDecorationTheme: InputDecorationTheme(
                // labelStyle: TextStyle(color: Color(0xFF212121)),
                // focusColor: Color(0xFF212121),
                floatingLabelStyle: TextStyle(color: Colors.grey),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(width: 2, color: Colors.grey),
                  borderRadius: BorderRadius.circular(10),
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            themeMode: dark ? ThemeMode.dark : ThemeMode.light,
            home: Scaffold(
              key: _globalKey,
              drawer: pDrawer(),
              backgroundColor:
                  // MediaQuery.of(context).platformBrightness == Brightness.light
                  !dark ? Colors.white.withOpacity(.95) : Color(0xFF212121),
              appBar: pAppBar(netCash),
              body: SafeArea(
                child: ListView.builder(
                  itemCount: list.length,
                  itemBuilder: (BuildContext context, int index) {
                    var x = list[index].toString().split('_');

                    return Padding(
                      padding: EdgeInsets.only(bottom: 10),
                      child: ListTile(
                        onTap: () {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              final amount = TextEditingController();
                              amount.text = double.parse(x[1]).abs().toString();
                              amount.selection = TextSelection.fromPosition(
                                  TextPosition(offset: amount.text.length));

                              final name = TextEditingController();
                              name.text = x[0];
                              name.selection = TextSelection.fromPosition(
                                  TextPosition(offset: name.text.length));
                              DateTime date = DateTime.parse(x[2]);

                              String? cashRadio = double.parse(x[1]) >= 0
                                  ? 'CashIn'
                                  : 'CashOut';
                              return StatefulBuilder(
                                builder: (BuildContext context,
                                    void Function(void Function()) setState) {
                                  return Dialog(
                                    backgroundColor: Colors.transparent,
                                    child: ClipRRect(
                                      child: BackdropFilter(
                                        filter: ImageFilter.blur(
                                            sigmaX: 3, sigmaY: 3),
                                        child: Container(
                                          decoration: BoxDecoration(
                                            color: Colors.white.withOpacity(.2),
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(10)),
                                            border: Border.all(
                                              width: 1.5,
                                              color:
                                                  Colors.white.withOpacity(0.2),
                                            ),
                                          ),
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .height *
                                              .5,
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              .8,
                                          child: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Column(
                                              children: [
                                                Spacer(flex: 1),
                                                Row(
                                                  children: [
                                                    Text(
                                                      'Edit Entry',
                                                      style: TextStyle(
                                                        fontSize: 20,
                                                        color: Colors.white,
                                                      ),
                                                    ),
                                                    Spacer(),
                                                    GestureDetector(
                                                      onTap: () {
                                                        DateTime chossenDate =
                                                            DateTime.now();
                                                        showDatePicker(
                                                          context: context,
                                                          initialDate: date,
                                                          firstDate:
                                                              DateTime(2000),
                                                          lastDate:
                                                              DateTime(2080),
                                                        ).then((value) {
                                                          if (value != null) {
                                                            chossenDate = value;
                                                            date = chossenDate;
                                                          }
                                                          setState(() {});
                                                        });
                                                      },
                                                      child: Container(
                                                          height: 40,
                                                          width: 100,
                                                          decoration: BoxDecoration(
                                                              borderRadius: BorderRadius
                                                                  .all(Radius
                                                                      .circular(
                                                                          20)),
                                                              color: Colors
                                                                  .purple
                                                                  .shade100
                                                                  .withOpacity(
                                                                      .60)),
                                                          child: Center(
                                                            child: Text(
                                                              DateFormat(
                                                                      'dd/MM/yyyy')
                                                                  .format(date),
                                                              style: TextStyle(
                                                                color: Colors
                                                                    .white,
                                                              ),
                                                            ),
                                                          )),
                                                    ),
                                                    Spacer(),
                                                  ],
                                                ),
                                                Spacer(flex: 1),
                                                TextField(
                                                  keyboardType:
                                                      TextInputType.number,
                                                  style: TextStyle(
                                                    color: Colors.white,
                                                  ),
                                                  decoration: InputDecoration(
                                                    border: OutlineInputBorder(
                                                      borderSide: BorderSide(
                                                        color: Colors.white,
                                                      ),
                                                    ),
                                                    labelText: 'Amount',
                                                    labelStyle: TextStyle(
                                                      color: Colors.white,
                                                    ),
                                                  ),
                                                  controller: amount,
                                                  onTap: () {},
                                                ),
                                                Spacer(flex: 1),
                                                TextField(
                                                  keyboardType:
                                                      TextInputType.multiline,
                                                  style: TextStyle(
                                                    color: Colors.white,
                                                  ),
                                                  maxLength: 100,
                                                  maxLines: null,
                                                  decoration: InputDecoration(
                                                      labelText: 'Name',
                                                      labelStyle: TextStyle(
                                                        color: Colors.white,
                                                      )),
                                                  controller: name,
                                                  onTap: () {},
                                                ),
                                                // const Spacer(flex: 1),
                                                RadioListTile(
                                                  title: Text(
                                                    'Cash In',
                                                    style: TextStyle(
                                                      color: Colors.white,
                                                    ),
                                                  ),
                                                  value: 'CashIn',
                                                  groupValue: cashRadio,
                                                  onChanged: (String? change) {
                                                    setState(() =>
                                                        cashRadio = change);
                                                  },
                                                ),
                                                RadioListTile(
                                                  title: Text('Cash Out',
                                                      style: TextStyle(
                                                        color: Colors.white,
                                                      )),
                                                  value: 'CashOut',
                                                  groupValue: cashRadio,
                                                  onChanged: (String? change) {
                                                    setState(() =>
                                                        cashRadio = change);
                                                  },
                                                ),
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceAround,
                                                  children: [
                                                    GestureDetector(
                                                      onTap: () {
                                                        list.removeAt(index);
                                                        SharedPref.setList(
                                                            list);
                                                        newSetState(() {});
                                                        Navigator.pop(context);
                                                      },
                                                      child: Container(
                                                        padding: EdgeInsets
                                                            .symmetric(
                                                                horizontal: 17,
                                                                vertical: 11),
                                                        decoration:
                                                            BoxDecoration(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(20),
                                                          color:
                                                              Color(0xff78909C),
                                                        ),
                                                        child: Text('Delete',
                                                            style: TextStyle(
                                                              color:
                                                                  Colors.white,
                                                            )),
                                                      ),
                                                    ),
                                                    GestureDetector(
                                                      onTap: () {
                                                        if (double.parse(
                                                                    x[1]) >=
                                                                0 &&
                                                            cashRadio ==
                                                                'CashOut') {
                                                          print('pos -->> neg');
                                                          list[index] =
                                                              '${name.text}_-${double.parse(amount.text).abs().toString()}_$date';
                                                        } else if (double.parse(
                                                                    x[1]) <
                                                                0 &&
                                                            cashRadio ==
                                                                'CashIn') {
                                                          print('neg -->> pos');
                                                          list[index] =
                                                              '${name.text}_${double.parse(amount.text).abs().toString()}_$date';
                                                        } else {
                                                          list[index] =
                                                              '${name.text}_${amount.text}_$date';
                                                        }
                                                        SharedPref.setList(list)
                                                            .then((value) =>
                                                                Navigator.pop(
                                                                    context));
                                                        newSetState(() {});
                                                      },
                                                      child: Container(
                                                        padding: EdgeInsets
                                                            .symmetric(
                                                                horizontal: 17,
                                                                vertical: 11),
                                                        decoration:
                                                            BoxDecoration(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(20),
                                                          color: 
                                                              !dark
                                                                  ? Colors
                                                                      .indigo
                                                                  : Color(
                                                                      0xff009688),
                                                        ),
                                                        child: Text('Update',
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .white)),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                const Spacer(flex: 1),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              );
                            },
                          );
                        },
                        tileColor: 
                            !dark
                                ? Colors.white
                                : Colors.black.withOpacity(.14),
                        title: Text(x[0], style: TextStyle(fontSize: 19)),
                        // contentPadding: EdgeInsets.all(20),
                        trailing: Text(
                          '₹ ${double.parse(x[1]).abs()}',
                          style: TextStyle(
                              color: double.parse(x[1]) >= 0
                                  ? Colors.greenAccent.shade700
                                  : Colors.redAccent.shade100,
                              fontSize: 20,
                              fontWeight: FontWeight.w900),
                        ),
                        subtitle: Text(DateFormat('dd/MM/yyyy HH:mm a')
                            .format(DateTime.parse(x[2]))),
                      ),
                    );
                  },
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Drawer pDrawer() {
    double sigma = 50;
    return Drawer(
      elevation: 0,
      width: 60.w,
      backgroundColor: Colors.transparent,
      child: ClipRect(
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: sigma, sigmaY: sigma),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.grey.shade200.withOpacity(0.2),
            ),
            child: SafeArea(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ListTile(
                    leading: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Switch(
                          // activeColor: Colors.black,
                          activeTrackColor: Colors.black,
                          activeColor: Colors.black38,
                          inactiveTrackColor: Colors.white54,
                          value: dark,
                          onChanged: (bool value) {
                            setState(() {
                              dark = value;
                              if (dark == true) {}
                            });
                          },
                        ),
                        Text('Dark Mode',
                            style: TextStyle(color: Colors.white)),
                      ],
                    ),
                  ),
                  Divider(color: Colors.white),
                  ListTile(
                    onTap: () {
                      Navigator.push(
                        context,
                        SlideTransition2(pCalendar(list1: list)),
                      );
                    },
                    leading: Text(
                      'Calender',
                      style: TextStyle(color: Colors.white, fontSize: 20),
                    ),
                    trailing: Icon(Icons.calendar_month,
                        color: Colors.white, size: 25),
                  ),
                  ListTile(
                    onTap: () {
                      Navigator.push(
                          context, SlideTransition2(Testing(list: list)));
                    },
                    leading: Text(
                      'Summary',
                      style: TextStyle(color: Colors.white, fontSize: 20),
                    ),
                    trailing: Icon(Icons.pie_chart_outline,
                        color: Colors.white, size: 25),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  pAppBar(netCash) {
    return AppBar(
        title: Text('CashBook',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(60),
          child: Row(
            children: [
              Spacer(),
              ElevatedButton(
                  onPressed: () {
                    DateTime date = DateTime.now();
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return Form(
                          key: _formKey,
                          child: StatefulBuilder(
                            builder: (BuildContext context,
                                void Function(void Function()) pSetState) {
                              return AlertDialog(
                                title: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text('Cash In',
                                        style: TextStyle(color: Colors.green)),
                                    GestureDetector(
                                      onTap: () {
                                        DateTime chossenDate = DateTime.now();
                                        showDatePicker(
                                          context: context,
                                          initialDate: date,
                                          firstDate: DateTime(2000),
                                          lastDate: DateTime(2080),
                                        ).then((value) {
                                          if (value != null) {
                                            chossenDate = value;
                                            date = chossenDate;
                                          }
                                          pSetState(() {});
                                        });
                                      },
                                      child: Container(
                                          height: 40,
                                          width: 100,
                                          decoration: BoxDecoration(
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(20)),
                                              color: Colors.purple.shade100
                                                  .withOpacity(.60)),
                                          child: Center(
                                            child: Text(
                                              DateFormat('dd/MM/yyyy')
                                                  .format(date),
                                              style: TextStyle(fontSize: 13),
                                            ),
                                          )),
                                    ),
                                  ],
                                ),
                                content: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    textFieldPhoenix(
                                        controller: _cashInCash,
                                        keyboardType: TextInputType.number),
                                    SizedBox(height: 10),
                                    textFieldPhoenix(controller: _cashInName),
                                  ],
                                ),
                                actions: [
                                  TextButton(
                                    onPressed: () async {
                                      try {
                                        if (_formKey.currentState!.validate()) {
                                          list.add(
                                              '${_cashInName.text}_${double.parse(_cashInCash.text).abs().toString()}_${DateTime.now()}');
                                          print('1 --->> $list');
                                          await SharedPref.setList(list);
                                          print('2 --->> $list');
                                          setState(() {});
                                          Get.back();
                                          _cashInCash.clear();
                                          _cashInName.clear();
                                          print(
                                              'list after adding -->> $list  ');
                                        }
                                      } catch (e) {
                                        print(e);
                                      }
                                    },
                                    child: const Text('Done'),
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      Get.back();
                                      _cashInCash.clear();
                                      _cashInName.clear();
                                    },
                                    child: Text('Cancel'),
                                  ),
                                ],
                              );
                            },
                          ),
                        );
                      },
                    );
                  },
                  style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(
                          Colors.greenAccent.shade700)),
                  child: Text('CASH IN')),
              Spacer(),
              ElevatedButton(
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return Form(
                          key: _formKey,
                          child: StatefulBuilder(
                            builder: (BuildContext context,
                                void Function(void Function()) pSetState) {
                              DateTime date = DateTime.now();
                              return AlertDialog(
                                title: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text('Cash Out',
                                        style: TextStyle(color: Colors.red)),
                                    GestureDetector(
                                      onTap: () {
                                        DateTime chossenDate = DateTime.now();
                                        showDatePicker(
                                          context: context,
                                          initialDate: date,
                                          firstDate: DateTime(2000),
                                          lastDate: DateTime(2080),
                                        ).then((value) {
                                          if (value != null) {
                                            chossenDate = value;
                                            date = chossenDate;
                                          }
                                          pSetState(() {});
                                        });
                                      },
                                      child: Container(
                                          height: 40,
                                          width: 100,
                                          decoration: BoxDecoration(
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(20)),
                                              color: Colors.purple.shade100
                                                  .withOpacity(.60)),
                                          child: Center(
                                            child: Text(
                                              DateFormat('dd/MM/yyyy')
                                                  .format(date),
                                              style: TextStyle(fontSize: 13),
                                            ),
                                          )),
                                    ),
                                  ],
                                ),
                                content: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    textFieldPhoenix(
                                        controller: _cashOutCash,
                                        keyboardType: TextInputType.number),
                                    SizedBox(height: 10),
                                    textFieldPhoenix(controller: _cashOutName),
                                  ],
                                ),
                                actions: [
                                  TextButton(
                                    onPressed: () async {
                                      if (_formKey.currentState!.validate()) {
                                        list.add(
                                            '${_cashOutName.text}_-${double.parse(_cashOutCash.text).abs().toString()}_${DateTime.now()}');
                                        print(list);
                                        await SharedPref.setList(list);
                                        setState(() {
                                          print(list);
                                          log('listnearshare ---- $list');
                                          Get.back();
                                          _cashOutCash.clear();
                                          _cashOutName.clear();
                                        });
                                      }
                                    },
                                    child: Text('Done'),
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      Get.back();
                                      _cashOutCash.clear();
                                      _cashOutName.clear();
                                    },
                                    child: Text('Cancel'),
                                  ),
                                ],
                              );
                            },
                          ),
                        );
                      },
                    );
                  },
                  style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.all(Colors.redAccent.shade100)),
                  child: Text('CASH OUT')),
              Spacer(),
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Balance - ',
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                  Text(
                    '₹ ${netCash.abs()}',
                    style: TextStyle(
                        color: netCash >= 0
                            ? Colors.greenAccent.shade700
                            : Colors.redAccent.shade100,
                        fontSize: 20,
                        fontWeight: FontWeight.w900),
                  ),
                ],
              ),
              Spacer(),
            ],
          ),
        ));
  }

  textFieldPhoenix({controller, keyboardType}) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType ?? TextInputType.multiline,
      maxLines: null,
      maxLength: keyboardType == null ? 100 : null,
      validator: (value) {
        if (value!.isEmpty) {
          return 'PLease fill this field';
        } else if (keyboardType == null ? false : !value.isNum) {
          return 'Please only numbers are allowed';
        }
        return null;
      },
      decoration: InputDecoration(
        labelText: keyboardType == null ? 'Description' : 'Amount',
      ),
    );
  }
}
*/
import 'dart:developer';
import 'dart:ui';
import 'package:cashbook/main.dart';
import 'package:cashbook/screens/splash.dart';
import 'package:cashbook/screens/temp.dart';
import 'package:cashbook/screens/calendar.dart';
import 'package:cashbook/sharedPref.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:sizer/sizer.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({
    Key? key,
  }) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _cashInCash = TextEditingController();
  final _cashInName = TextEditingController();

  final _cashOutCash = TextEditingController();
  final _cashOutName = TextEditingController();

  final _formKey = GlobalKey<FormState>();
  final _globalKey = GlobalKey<ScaffoldState>();
  final GlobalKey<AnimatedListState> listKey = GlobalKey<AnimatedListState>();

  // late bool dark;

  @override
  void initState() {
    SharedPref.setNewUser();
    print('state called ---- $dark');
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        final value = await showDialog<bool>(
            context: context,
            builder: (context) {
              return AlertDialog(
                content: Text('Are you sure you want to exit?'),
                actions: <Widget>[
                  TextButton(
                    child: Text('No'),
                    onPressed: () {
                      Navigator.of(context).pop(false);
                    },
                  ),
                  TextButton(
                    child: Text('Yes'),
                    onPressed: () {
                      Navigator.of(context).pop(true);
                      SharedPref.setTheme(theme: dark ? 'dark' : 'light');
                    },
                  ),
                ],
              );
            });
        return value == true;
      },
      child: StatefulBuilder(
        builder:
            (BuildContext context, void Function(void Function()) newSetState) {
          double netCash = 0;
          for (var i = 0; i < list.length; i++) {
            netCash = netCash + double.parse(list[i].toString().split('_')[1]);
          }
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            theme: ThemeData(
              // useMaterial3: true,

              primaryColor: Color(0xffb100cd),
              inputDecorationTheme: InputDecorationTheme(
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(width: 2, color: themeColor()),
                  borderRadius: BorderRadius.circular(10),
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ).copyWith(
              colorScheme: ThemeData().colorScheme.copyWith(
                    primary: themeColor(),
                  ),
            ),
            darkTheme: ThemeData(
              brightness: Brightness.dark,
              inputDecorationTheme: InputDecorationTheme(
                // labelStyle: TextStyle(color: Color(0xFF212121)),
                // focusColor: Color(0xFF212121),
                floatingLabelStyle: TextStyle(color: Colors.grey),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(width: 2, color: Colors.grey),
                  borderRadius: BorderRadius.circular(10),
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            themeMode: dark ? ThemeMode.dark : ThemeMode.light,
            home: Scaffold(
              key: _globalKey,
              drawer: pDrawer(),
              backgroundColor:
                  // MediaQuery.of(context).platformBrightness == Brightness.light
                  !dark ? Colors.white.withOpacity(.95) : Color(0xFF212121),
              appBar: pAppBar(netCash),
              body: SafeArea(
                child: ListView.builder(
                  itemCount: list.length,
                  itemBuilder: (BuildContext context, int index) {
                    var x = list[index].toString().split('_');

                    return Padding(
                      padding: EdgeInsets.only(bottom: 10),
                      child: ListTile(
                        onTap: () {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              final amount = TextEditingController();
                              amount.text = double.parse(x[1]).abs().toString();
                              amount.selection = TextSelection.fromPosition(
                                  TextPosition(offset: amount.text.length));

                              final name = TextEditingController();
                              name.text = x[0];
                              name.selection = TextSelection.fromPosition(
                                  TextPosition(offset: name.text.length));
                              DateTime date = DateTime.parse(x[2]);

                              String? cashRadio = double.parse(x[1]) >= 0
                                  ? 'CashIn'
                                  : 'CashOut';
                              return StatefulBuilder(
                                builder: (BuildContext context,
                                    void Function(void Function()) setState) {
                                  return Dialog(
                                    backgroundColor: Colors.transparent,
                                    child: ClipRRect(
                                      child: BackdropFilter(
                                        filter: ImageFilter.blur(
                                            sigmaX: 3, sigmaY: 3),
                                        child: Container(
                                          decoration: BoxDecoration(
                                            color: Colors.white.withOpacity(.2),
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(10)),
                                            border: Border.all(
                                              width: 1.5,
                                              color:
                                                  Colors.white.withOpacity(0.2),
                                            ),
                                          ),
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .height *
                                              .5,
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              .8,
                                          child: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Column(
                                              children: [
                                                Spacer(flex: 1),
                                                Row(
                                                  children: [
                                                    Text(
                                                      'Edit Entry',
                                                      style: TextStyle(
                                                        fontSize: 20,
                                                        color: Colors.white,
                                                      ),
                                                    ),
                                                    Spacer(),
                                                    GestureDetector(
                                                      onTap: () {
                                                        DateTime chossenDate =
                                                            DateTime.now();
                                                        showDatePicker(
                                                          context: context,
                                                          initialDate: date,
                                                          firstDate:
                                                              DateTime(2000),
                                                          lastDate:
                                                              DateTime(2080),
                                                        ).then((value) {
                                                          if (value != null) {
                                                            chossenDate = value;
                                                            date = chossenDate;
                                                          }
                                                          setState(() {});
                                                        });
                                                      },
                                                      child: Container(
                                                          height: 40,
                                                          width: 100,
                                                          decoration: BoxDecoration(
                                                              borderRadius: BorderRadius
                                                                  .all(Radius
                                                                      .circular(
                                                                          20)),
                                                              color: Colors
                                                                  .purple
                                                                  .shade100
                                                                  .withOpacity(
                                                                      .60)),
                                                          child: Center(
                                                            child: Text(
                                                              DateFormat(
                                                                      'dd/MM/yyyy')
                                                                  .format(date),
                                                              style: TextStyle(
                                                                color: Colors
                                                                    .white,
                                                              ),
                                                            ),
                                                          )),
                                                    ),
                                                    Spacer(),
                                                  ],
                                                ),
                                                Spacer(flex: 1),
                                                TextField(
                                                  keyboardType:
                                                      TextInputType.number,
                                                  style: TextStyle(
                                                    color: Colors.white,
                                                  ),
                                                  decoration: InputDecoration(
                                                    border: OutlineInputBorder(
                                                      borderSide: BorderSide(
                                                        color: Colors.white,
                                                      ),
                                                    ),
                                                    labelText: 'Amount',
                                                    labelStyle: TextStyle(
                                                      color: Colors.white,
                                                    ),
                                                  ),
                                                  controller: amount,
                                                  onTap: () {},
                                                ),
                                                Spacer(flex: 1),
                                                TextField(
                                                  keyboardType:
                                                      TextInputType.multiline,
                                                  style: TextStyle(
                                                    color: Colors.white,
                                                  ),
                                                  maxLength: 100,
                                                  maxLines: null,
                                                  decoration: InputDecoration(
                                                      labelText: 'Name',
                                                      labelStyle: TextStyle(
                                                        color: Colors.white,
                                                      )),
                                                  controller: name,
                                                  onTap: () {},
                                                ),
                                                // const Spacer(flex: 1),
                                                RadioListTile(
                                                  title: Text(
                                                    'Cash In',
                                                    style: TextStyle(
                                                      color: Colors.white,
                                                    ),
                                                  ),
                                                  value: 'CashIn',
                                                  groupValue: cashRadio,
                                                  onChanged: (String? change) {
                                                    setState(() =>
                                                        cashRadio = change);
                                                  },
                                                ),
                                                RadioListTile(
                                                  title: Text('Cash Out',
                                                      style: TextStyle(
                                                        color: Colors.white,
                                                      )),
                                                  value: 'CashOut',
                                                  groupValue: cashRadio,
                                                  onChanged: (String? change) {
                                                    setState(() =>
                                                        cashRadio = change);
                                                  },
                                                ),
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceAround,
                                                  children: [
                                                    GestureDetector(
                                                      onTap: () {
                                                        list.removeAt(index);
                                                        SharedPref.setList(
                                                            list);
                                                        newSetState(() {});
                                                        Navigator.pop(context);
                                                      },
                                                      child: Container(
                                                        padding: EdgeInsets
                                                            .symmetric(
                                                                horizontal: 17,
                                                                vertical: 11),
                                                        decoration:
                                                            BoxDecoration(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(20),
                                                          color:
                                                              Color(0xff78909C),
                                                        ),
                                                        child: Text('Delete',
                                                            style: TextStyle(
                                                              color:
                                                                  Colors.white,
                                                            )),
                                                      ),
                                                    ),
                                                    GestureDetector(
                                                      onTap: () {
                                                        if (double.parse(
                                                                    x[1]) >=
                                                                0 &&
                                                            cashRadio ==
                                                                'CashOut') {
                                                          print('pos -->> neg');
                                                          list[index] =
                                                              '${name.text}_-${double.parse(amount.text).abs().toString()}_$date';
                                                        } else if (double.parse(
                                                                    x[1]) <
                                                                0 &&
                                                            cashRadio ==
                                                                'CashIn') {
                                                          print('neg -->> pos');
                                                          list[index] =
                                                              '${name.text}_${double.parse(amount.text).abs().toString()}_$date';
                                                        } else {
                                                          list[index] =
                                                              '${name.text}_${amount.text}_$date';
                                                        }
                                                        SharedPref.setList(list)
                                                            .then((value) =>
                                                                Navigator.pop(
                                                                    context));
                                                        newSetState(() {});
                                                      },
                                                      child: Container(
                                                        padding: EdgeInsets
                                                            .symmetric(
                                                                horizontal: 17,
                                                                vertical: 11),
                                                        decoration:
                                                            BoxDecoration(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(20),
                                                          color: !dark
                                                              ? Colors.indigo
                                                              : Color(
                                                                  0xff009688),
                                                        ),
                                                        child: Text('Update',
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .white)),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                const Spacer(flex: 1),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              );
                            },
                          );
                        },
                        tileColor: !dark
                            ? Colors.white
                            : Colors.black.withOpacity(.14),
                        title: Text(x[0], style: TextStyle(fontSize: 19)),
                        // contentPadding: EdgeInsets.all(20),
                        trailing: Text(
                          '₹ ${double.parse(x[1]).abs()}',
                          style: TextStyle(
                              color: double.parse(x[1]) >= 0
                                  ? Colors.greenAccent.shade700
                                  : Colors.redAccent.shade100,
                              fontSize: 20,
                              fontWeight: FontWeight.w900),
                        ),
                        subtitle: Text(DateFormat('dd/MM/yyyy HH:mm a')
                            .format(DateTime.parse(x[2]))),
                      ),
                    );
                  },
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Drawer pDrawer() {
    double sigma = 50;
    return Drawer(
      elevation: 0,
      width: 60.w,
      backgroundColor: Colors.transparent,
      child: ClipRect(
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: sigma, sigmaY: sigma),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.grey.shade200.withOpacity(0.2),
            ),
            child: SafeArea(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ListTile(
                    leading: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Switch(
                          // activeColor: Colors.black,
                          activeTrackColor: Colors.black,
                          activeColor: Colors.black38,
                          inactiveTrackColor: Colors.white54,
                          value: dark,
                          onChanged: (bool value) {
                            setState(() {
                              dark = value;
                              if (dark == true) {}
                            });
                          },
                        ),
                        Text('Dark Mode',
                            style: TextStyle(color: Colors.white)),
                      ],
                    ),
                  ),
                  Divider(color: Colors.white),
                  ListTile(
                    onTap: () {
                      Navigator.push(
                        context,
                        SlideTransition2(pCalendar(list1: list)),
                      );
                    },
                    leading: Text(
                      'Calender',
                      style: TextStyle(color: Colors.white, fontSize: 20),
                    ),
                    trailing: Icon(Icons.calendar_month,
                        color: Colors.white, size: 25),
                  ),
                  ListTile(
                    onTap: () {
                      Navigator.push(
                          context, SlideTransition2(Testing(list: list)));
                    },
                    leading: Text(
                      'Summary',
                      style: TextStyle(color: Colors.white, fontSize: 20),
                    ),
                    trailing:
                        Icon(Icons.pie_chart, color: Colors.white, size: 25),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  pAppBar(netCash) {
    return AppBar(
        title: Text('CashBook',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(60),
          child: Row(
            children: [
              Spacer(),
              ElevatedButton(
                  onPressed: () {
                    DateTime date = DateTime.now();
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return Form(
                          key: _formKey,
                          child: StatefulBuilder(
                            builder: (BuildContext context,
                                void Function(void Function()) pSetState) {
                              return AlertDialog(
                                title: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text('Cash In',
                                        style: TextStyle(color: Colors.green)),
                                    GestureDetector(
                                      onTap: () {
                                        DateTime chossenDate = DateTime.now();
                                        showDatePicker(
                                          context: context,
                                          initialDate: date,
                                          firstDate: DateTime(2000),
                                          lastDate: DateTime(2080),
                                        ).then((value) {
                                          if (value != null) {
                                            chossenDate = value;
                                            date = chossenDate;
                                          }
                                          pSetState(() {});
                                        });
                                      },
                                      child: Container(
                                          height: 40,
                                          width: 100,
                                          decoration: BoxDecoration(
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(20)),
                                              color: Colors.purple.shade100
                                                  .withOpacity(.60)),
                                          child: Center(
                                            child: Text(
                                              DateFormat('dd/MM/yyyy')
                                                  .format(date),
                                              style: TextStyle(fontSize: 13),
                                            ),
                                          )),
                                    ),
                                  ],
                                ),
                                content: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    textFieldPhoenix(
                                        controller: _cashInCash,
                                        keyboardType: TextInputType.number),
                                    SizedBox(height: 10),
                                    textFieldPhoenix(controller: _cashInName),
                                  ],
                                ),
                                actions: [
                                  TextButton(
                                    onPressed: () async {
                                      try {
                                        if (_formKey.currentState!.validate()) {
                                          list.add(
                                              '${_cashInName.text}_${double.parse(_cashInCash.text).abs().toString()}_${DateTime.now()}');
                                          print('1 --->> $list');
                                          await SharedPref.setList(list);
                                          print('2 --->> $list');
                                          setState(() {});
                                          /*     listKey.currentState?.insertItem(0,
                                              duration: const Duration(
                                                  milliseconds: 900));
                                          list = []
                                            ..add(
                                                '${_cashInName.text}_${double.parse(_cashInCash.text).abs().toString()}_${DateTime.now()}')
                                            ..addAll(list);
                                          netCash = list.reduce(
                                              (value, element) =>
                                                  value + element);*/
                                          // list.add(
                                          //     '${_cashInName.text}_${double.parse(_cashInCash.text).abs().toString()}_${DateTime.now()}');
                                          Get.back();
                                          _cashInCash.clear();
                                          _cashInName.clear();
                                          print(
                                              'list after adding -->> $list  ');
                                        }
                                      } catch (e) {
                                        print(e);
                                      }
                                    },
                                    child: const Text('Done'),
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      Get.back();
                                      _cashInCash.clear();
                                      _cashInName.clear();
                                    },
                                    child: Text('Cancel'),
                                  ),
                                ],
                              );
                            },
                          ),
                        );
                      },
                    );
                  },
                  style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(
                          Colors.greenAccent.shade700)),
                  child: Text('CASH IN')),
              Spacer(),
              ElevatedButton(
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return Form(
                          key: _formKey,
                          child: StatefulBuilder(
                            builder: (BuildContext context,
                                void Function(void Function()) pSetState) {
                              DateTime date = DateTime.now();
                              return AlertDialog(
                                title: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text('Cash Out',
                                        style: TextStyle(color: Colors.red)),
                                    GestureDetector(
                                      onTap: () {
                                        DateTime chossenDate = DateTime.now();
                                        showDatePicker(
                                          context: context,
                                          initialDate: date,
                                          firstDate: DateTime(2000),
                                          lastDate: DateTime(2080),
                                        ).then((value) {
                                          if (value != null) {
                                            chossenDate = value;
                                            date = chossenDate;
                                          }
                                          pSetState(() {});
                                        });
                                      },
                                      child: Container(
                                          height: 40,
                                          width: 100,
                                          decoration: BoxDecoration(
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(20)),
                                              color: Colors.purple.shade100
                                                  .withOpacity(.60)),
                                          child: Center(
                                            child: Text(
                                              DateFormat('dd/MM/yyyy')
                                                  .format(date),
                                              style: TextStyle(fontSize: 13),
                                            ),
                                          )),
                                    ),
                                  ],
                                ),
                                content: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    textFieldPhoenix(
                                        controller: _cashOutCash,
                                        keyboardType: TextInputType.number),
                                    SizedBox(height: 10),
                                    textFieldPhoenix(controller: _cashOutName),
                                  ],
                                ),
                                actions: [
                                  TextButton(
                                    onPressed: () async {
                                      if (_formKey.currentState!.validate()) {
                                        list.add(
                                            '${_cashOutName.text}_-${double.parse(_cashOutCash.text).abs().toString()}_${DateTime.now()}');
                                        print(list);
                                        await SharedPref.setList(list);
                                        setState(() {
                                          print(list);
                                          log('listnearshare ---- $list');
                                          Get.back();
                                          _cashOutCash.clear();
                                          _cashOutName.clear();
                                        });
                                      }
                                    },
                                    child: Text('Done'),
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      Get.back();
                                      _cashOutCash.clear();
                                      _cashOutName.clear();
                                    },
                                    child: Text('Cancel'),
                                  ),
                                ],
                              );
                            },
                          ),
                        );
                      },
                    );
                  },
                  style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.all(Colors.redAccent.shade100)),
                  child: Text('CASH OUT')),
              Spacer(),
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Balance : ',
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                  Text(
                    '₹ ${netCash.abs()}',
                    style: TextStyle(
                        color: netCash >= 0
                            ? Colors.greenAccent.shade700
                            : Colors.redAccent.shade100,
                        fontSize: 20,
                        fontWeight: FontWeight.w900),
                  ),
                ],
              ),
              Spacer(),
            ],
          ),
        ));
  }

  textFieldPhoenix({controller, keyboardType}) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType ?? TextInputType.multiline,
      maxLines: null,
      maxLength: keyboardType == null ? 100 : null,
      validator: (value) {
        if (value!.isEmpty) {
          return 'PLease fill this field';
        } else if (keyboardType == null ? false : !value.isNum) {
          return 'Please only numbers are allowed';
        }
        return null;
      },
      decoration: InputDecoration(
        labelText: keyboardType == null ? 'Description' : 'Amount',
      ),
    );
  }
}
