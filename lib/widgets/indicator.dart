import 'package:flutter/material.dart';
import 'package:my_tracker/themes.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class Indicator extends StatelessWidget {
  const Indicator({
    super.key,
    required this.color,
    required this.text,
    required this.isSquare,
    this.size = 10,
    this.textColor,
  });
  final Color color;
  final String text;
  final bool isSquare;
  final double size;
  final Color? textColor;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            shape: isSquare ? BoxShape.rectangle : BoxShape.circle,
            color: color,
          ),
        ),
        const SizedBox(
          width: 4,
        ),
        Text(
          text,
          style: lighttitlestyle(context).copyWith(fontSize: 11.sp, overflow: TextOverflow.ellipsis),
          overflow: TextOverflow.ellipsis,
        )
      ],
    );
  }
}