import 'package:flutter/material.dart';

//! Color

class AppColors {
  static const Color primaryBlue = Color(0xFF2196F3);
  static const Color accent = Color(0xFF03A9F4);
  static const Color background = Color(0xFFF5F5F5);
  static const Color cardBackground = Color(0xFFFFFFFF);
  static const Color transparent = Colors.transparent;

  // Text Colors
  static const Color textPrimary = Color(0xFF212121);
  static const Color textSecondary = Color(0xFF757575);
  static const Color textTertiary = Colors.white;

  // Divider/Border
  static const Color divider = Color(0xFFE0E0E0);
  static const Color borderB = Colors.black;
  // Status Colors
  static const Color statusCompleted = Color(0xFF2196F3); // Filled
  static const Color statusInProgress = Color(0xFF2196F3); // Outline
  static const Color statusUpcoming = Color(0xFF9E9E9E); // Outline

  //Icon Colors
  static const Color iconPrimary = Color(0xFF212121);
  static const Color iconSecondary = Color(0xFFFFFFFF);
  

  // Circular progress Indicator
  static const Color cpiColor = Colors.black;

  
  // Calander Colors
  static const Color selectedColor = Color(0xFF2196F3);
  static const Color pastColor = Color(0xFF03A9F4);
  static const Color futureColor = Color(0xFFE1BEE7);

  static const Color white = Colors.white;
  static const Color black = Colors.black; 
  static const Color grey = Colors.grey;
}

class AppTextStyles {
  static const TextStyle header = TextStyle(
    fontFamily: 'Roboto',
    fontSize: 20,
    fontWeight: FontWeight.w600, // Medium (Use FontWeight.bold for Bold)
    color: AppColors.textPrimary,
  );


  //! Text Style
  static const TextStyle headingStyleW = TextStyle(
    fontFamily: 'Roboto',
    fontSize: 24,
    fontWeight: FontWeight.bold,
    color: Colors.white,
  );
  static const TextStyle headingStyleB = TextStyle(
    fontFamily: 'Roboto',
    fontSize: 24,
    fontWeight: FontWeight.bold,
    color: Colors.black,
  );
  static const TextStyle headerBoldB = TextStyle(
    fontFamily: 'Roboto',
    fontSize: 20,
    fontWeight: FontWeight.bold,
    color: AppColors.textPrimary,
  );
  static const TextStyle headerBoldW = TextStyle(
    fontFamily: 'Roboto',
    fontSize: 20,
    fontWeight: FontWeight.bold,
    color: Colors.white,
  );
  static const TextStyle subtitle = TextStyle(
    fontFamily: 'Roboto',
    fontSize: 16,
    fontWeight: FontWeight.w500, // Medium
    color: AppColors.textPrimary,
  );

  static const TextStyle body = TextStyle(
    fontFamily: 'Roboto',
    fontSize: 14,
    fontWeight: FontWeight.normal, // Regular
    color: AppColors.textPrimary,
  );

  static const TextStyle caption = TextStyle(
    fontFamily: 'Roboto',
    fontSize: 12,
    fontWeight: FontWeight.normal, // Regular
    color: AppColors.textSecondary,
  );
}
