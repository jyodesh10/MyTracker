


import 'package:flutter/material.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import '../themes.dart';

class CustomDialogs {

  static void deleteDialog(BuildContext context, {required String title, required String content, required VoidCallback onPressed}) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title, style: titlestyle(context).copyWith(fontSize: 16.sp),),
        content: Text(content, style: lighttitlestyle(context).copyWith(fontSize: 15.sp)),
        backgroundColor: Theme.of(context).colorScheme.surface,
        shape: RoundedSuperellipseBorder(
          borderRadius: BorderRadius.circular(15.sp),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text("Cancel", style: lighttitlestyle(context).copyWith(fontSize: 15.sp),),
          ),
          TextButton(
            onPressed:onPressed,
            child: Text("Delete", style: lighttitlestyle(context).copyWith(fontSize: 15.sp, color: Colors.red),),
          ),
        ],
      ),
    );
  }

}