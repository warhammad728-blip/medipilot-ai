import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';

class AppTextStyles {
  // Headings — Poppins
  static TextStyle heading1 = GoogleFonts.poppins(
    fontSize: 24, fontWeight: FontWeight.w700,
    color: AppColors.textPrimary);

  static TextStyle heading2 = GoogleFonts.poppins(
    fontSize: 20, fontWeight: FontWeight.w700,
    color: AppColors.textPrimary);

  static TextStyle heading3 = GoogleFonts.poppins(
    fontSize: 16, fontWeight: FontWeight.w700,
    color: AppColors.textPrimary);

  static TextStyle headingWhite = GoogleFonts.poppins(
    fontSize: 20, fontWeight: FontWeight.w700,
    color: Colors.white);

  // Body — Inter
  static TextStyle body = GoogleFonts.inter(
    fontSize: 14, fontWeight: FontWeight.w400,
    color: AppColors.textPrimary);

  static TextStyle bodySmall = GoogleFonts.inter(
    fontSize: 12, fontWeight: FontWeight.w400,
    color: AppColors.textSecondary);

  static TextStyle bodyBold = GoogleFonts.inter(
    fontSize: 14, fontWeight: FontWeight.w600,
    color: AppColors.textPrimary);

  static TextStyle caption = GoogleFonts.inter(
    fontSize: 10, fontWeight: FontWeight.w500,
    color: AppColors.textHint, letterSpacing: 0.5);

  static TextStyle label = GoogleFonts.inter(
    fontSize: 11, fontWeight: FontWeight.w700,
    color: AppColors.textSecondary, letterSpacing: 0.8);

  static TextStyle agentTag = GoogleFonts.inter(
    fontSize: 9, fontWeight: FontWeight.w700,
    letterSpacing: 0.5);
}
