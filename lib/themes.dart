




import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

// TextStyle titlestyle = GoogleFonts.poppins(
//   fontSize: 18.sp,
//   fontWeight: FontWeight.w600,
//   color: Colors.black
// );

// TextStyle lighttitlestyle = GoogleFonts.poppins(
//   fontSize: 15.5.sp,
//   fontWeight: FontWeight.normal,
//   color: Colors.black
// );

TextStyle titlestyle(BuildContext context) {
  // Use the color that is the opposite of the background
  final color = Theme.of(context).colorScheme.onSurface; 
  
  return GoogleFonts.poppins(
    fontSize: 18.sp,
    fontWeight: FontWeight.w600,
    color: color, // Dynamic color based on current theme
  );
}

TextStyle lighttitlestyle(BuildContext context) {
  // Use the color that is the opposite of the background
  final color = Theme.of(context).colorScheme.onSurface.withAlpha(220);

  return GoogleFonts.poppins(
    fontSize: 15.5.sp,
    fontWeight: FontWeight.normal,
    color: color, // Dynamic color based on current theme
  );
}