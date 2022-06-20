import 'package:flutter/material.dart';
import 'package:njia/constants/app_constants.dart';
import 'package:njia/main.dart';

class SplashPage extends StatelessWidget {
  int duration = 0;
  Widget goToPage;
  SplashPage({Key? key, required this.duration, required this.goToPage})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    Future.delayed(Duration(seconds: this.duration), () {
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => this.goToPage));
    });

    return Scaffold(
      body: Container(
        color: mainHexColor,
        alignment: Alignment.center,
        child: IconFont(),
      ),
    );
  }
}
