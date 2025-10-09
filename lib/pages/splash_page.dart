import 'package:flutter/material.dart';
import 'package:my_tracker/themes.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import 'home_page.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(milliseconds: 1500), () {
      if(mounted) Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => HomePage()));
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              height: 55.sp,
              width: 55.sp,
              margin: EdgeInsets.only(bottom: 20.sp),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                image: DecorationImage(
                  image: AssetImage("assets/icon/logo.png") 
                )
              ),
            ),
            Text("My Tracker", style: titlestyle(context),),
            Text("Track your expenses.", style: lighttitlestyle(context),),
          ],
        ),
      ),
    );
  }
}