import 'package:cashbook/screens/splash.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';
import 'package:intl/date_symbol_data_local.dart';

void main() {
  initializeDateFormatting().then((_) => runApp(MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Sizer(
      builder: (BuildContext context, Orientation orientation,
          DeviceType deviceType) {
        return GetMaterialApp(
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
          home: MyCustomSplashScreen(),
          // home: Testing(list: []),
        );
      },
    );
  }
}

themeColor() {
  return Colors.indigo;
}
