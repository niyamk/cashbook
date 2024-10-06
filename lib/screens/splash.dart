import 'dart:async';

import 'package:cashbook/screens/home.dart';
import 'package:cashbook/sharedPref.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class SlideTransition2 extends PageRouteBuilder {
  final Widget page;

  SlideTransition2(this.page)
      : super(
      pageBuilder: (context, animation, anotherAnimation) => page,
      transitionDuration: Duration(milliseconds: 1000),
      reverseTransitionDuration: Duration(milliseconds: 400),
      transitionsBuilder: (context, animation, anotherAnimation, child) {
        animation = CurvedAnimation(
            curve: Curves.fastOutSlowIn,
            parent: animation,
            reverseCurve: Curves.fastOutSlowIn);
        return SlideTransition(
          position: Tween(begin: Offset(1.0, 0.0), end: Offset(0.0, 0.0))
              .animate(animation),
          textDirection: TextDirection.rtl,
          child: page,
        );
      });
}

class MyCustomSplashScreen extends StatefulWidget {
  const MyCustomSplashScreen({Key? key}) : super(key: key);

  @override
  _MyCustomSplashScreenState createState() => _MyCustomSplashScreenState();
}

List<String> list = [];
bool dark = false;

class _MyCustomSplashScreenState extends State<MyCustomSplashScreen>
    with TickerProviderStateMixin {
  double _fontSize = 2;
  double _containerSize = 20;
  double _textOpacity = 0.0;
  double _containerOpacity = 0.0;

  late AnimationController _controller;
  late Animation<double> animation1;

  Future getData() async {
    String? data = await SharedPref.getNewUser();
    if (data == null || data == '') {
      Get.snackbar('welcome!', 'Welcome to my app');
      print('welcome brotha');
    }
    print('data ---->>>> ${data}');
  }

  Future GetList() async {
    List<String>? _list = await SharedPref.getList();
    _list == null ? list = [] : list = _list;
    print('phoenix pro------ $_list');
  }

  Future getTheme() async {
    String? data = await SharedPref.getTheme();
    print('phoenixhere ---->>> $data');
    if (data == null) {
      if (MediaQuery
          .of(context)
          .platformBrightness == Brightness.light) {
        dark = false;
      } else {
        dark = true;
      }
    } else if (data == 'dark') {
      dark = true;
    } else {
      dark = false;
    }
  }


  @override
  void initState() {
    super.initState();
    getTheme();
    getData();
    GetList();

    _controller =
        AnimationController(vsync: this, duration: Duration(seconds: 3));

    animation1 = Tween<double>(begin: 10, end: 30).animate(CurvedAnimation(
        parent: _controller, curve: Curves.fastLinearToSlowEaseIn))
      ..addListener(() {
        setState(() {
          _textOpacity = 1.0;
        });
      });

    _controller.forward();

    Timer(Duration(seconds: 2), () {
      setState(() {
        _fontSize = 1.06;
      });
    });

    Timer(Duration(seconds: 2), () {
      setState(() {
        _containerSize = 3;
        _containerOpacity = 1;
      });
    });

    Timer(Duration(seconds: 4), () {
      setState(() {
        Navigator.pushReplacement(context, PageTransition(HomeScreen()));
      });
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double _width = MediaQuery
        .of(context)
        .size
        .width;
    double _height = MediaQuery
        .of(context)
        .size
        .height;

    return Scaffold(
      backgroundColor: Color(0xFF212121),
      body: Stack(
        children: [
          Column(
            children: [
              AnimatedContainer(
                duration: Duration(milliseconds: 2000),
                curve: Curves.fastLinearToSlowEaseIn,
                height: _height / _fontSize,
                // child: Text('YOO PHOENIX'),
              ),
              AnimatedOpacity(
                duration: Duration(milliseconds: 1000),
                opacity: _textOpacity,
                child: Text(
                  'Phoenix',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: animation1.value,
                  ),
                ),
              ),
            ],
          ),
          Center(
            child: AnimatedOpacity(
              duration: Duration(milliseconds: 2000),
              curve: Curves.fastLinearToSlowEaseIn,
              opacity: _containerOpacity,
              child: AnimatedContainer(
                duration: Duration(milliseconds: 2000),
                curve: Curves.fastLinearToSlowEaseIn,
                height: _width / _containerSize,
                width: _width / _containerSize,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Image.asset('assets/images/phoenix.gif'),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class PageTransition extends PageRouteBuilder {
  final Widget page;

  PageTransition(this.page)
      : super(
    pageBuilder: (context, animation, anotherAnimation) => page,
    transitionDuration: Duration(milliseconds: 2000),
    transitionsBuilder: (context, animation, anotherAnimation, child) {
      animation = CurvedAnimation(
        curve: Curves.fastLinearToSlowEaseIn.flipped,
        parent: animation,
      );
      return Align(
        alignment: Alignment.bottomCenter,
        child: SizeTransition(
          sizeFactor: animation,
          child: page,
          axisAlignment: 0,
        ),
      );
    },
  );
}

class SecondPage extends StatefulWidget {
  @override
  State<SecondPage> createState() => _SecondPageState();
}

class _SecondPageState extends State<SecondPage> with TickerProviderStateMixin {
  double _fontSize = 10;

  double _containerSize = 1.5;

  double _textOpacity = 0.0;

  double _containerOpacity = 0.0;

  late AnimationController _controller;
  late Animation<double> animation1;

  @override
  void initState() {
    _controller =
        AnimationController(duration: Duration(seconds: 5), vsync: this);

    animation1 = Tween<double>(begin: 50, end: 10).animate(CurvedAnimation(
        parent: _controller, curve: Curves.fastLinearToSlowEaseIn))
      ..addListener(() {
        setState(() {
          _textOpacity = 1.0;
        });
      });

    _controller.forward();

    Timer(Duration(seconds: 3), () {
      setState(() {
        _fontSize = 1.06;
      });
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double _width = MediaQuery
        .of(context)
        .size
        .width;
    double _height = MediaQuery
        .of(context)
        .size
        .height;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.deepPurple,
        centerTitle: true,
        title: Text(
          'YOUR APP\'S NAME',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        systemOverlayStyle: SystemUiOverlayStyle.light,
      ),
      body: Center(
        child: AnimatedContainer(
          duration: Duration(milliseconds: 2000),
          decoration: BoxDecoration(
            color: Colors.blue,
          ),
          curve: Curves.fastLinearToSlowEaseIn,
          // width: _width / _fontSize,
          child: Text(
            'YOO PHOENIX',
            style: TextStyle(
              color: Colors.black,
              fontSize: animation1.value,
            ),
          ),
        ),
      ),
    );
  }
}

/*
import 'dart:async';

import 'package:cashbook/screens/home.dart';
import 'package:cashbook/screens/temp.dart';
import 'package:cashbook/sharedPref.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

List<String> list = [];

class _SplashScreenState extends State<SplashScreen> {
  Future getData() async {
    String? data = await SharedPref.getNewUser();
    if (data == null || data == '') {
      Get.snackbar('welcome!', 'Welcome to my app');
      print('welcome brotha');
    }
    print('data ---->>>> ${data}');
  }

  Future GetList() async {
    List<String>? _list = await SharedPref.getList();
    _list == null ? list = [] : list = _list;
    print('phoenix pro------ $_list');
  }

  @override
  void initState() {
    getData();
    GetList();
    */
/* Timer(Duration(seconds: 3), () {
      // Get.off(HomeScreen());
      Get.off(testing1());
    });*/ /*


    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Image(
          image: AssetImage('assets/images/phoenix.gif'),
          height: 100,
        ),
      ),
    );
  }
}
*/
