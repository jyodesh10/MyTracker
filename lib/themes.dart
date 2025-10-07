




import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

TextStyle titlestyle(BuildContext context) {
  final color = Theme.of(context).colorScheme.onSurface; 
  
  return GoogleFonts.poppins(
    fontSize: 18.sp,
    fontWeight: FontWeight.w600,
    color: color,
  );
}

TextStyle lighttitlestyle(BuildContext context) {
  final color = Theme.of(context).colorScheme.onSurface.withAlpha(220);

  return GoogleFonts.poppins(
    fontSize: 15.5.sp,
    fontWeight: FontWeight.normal,
    color: color,
  );
}