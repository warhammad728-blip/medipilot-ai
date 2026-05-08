import 'package:flutter/material.dart';

class AppColors {
  // Primary
  static const Color navyDark     = Color(0xFF0A1628);
  static const Color navyMid      = Color(0xFF0F1F3D);
  static const Color navyLight    = Color(0xFF1A2F50);

  // Teal Accent
  static const Color teal         = Color(0xFF00C9A7);
  static const Color tealDark     = Color(0xFF00A88A);
  static const Color tealLight    = Color(0xFFE0FAF5);

  // Emergency Red
  static const Color red          = Color(0xFFE53935);
  static const Color redDark      = Color(0xFFC62828);
  static const Color redLight     = Color(0xFFFFF0F0);

  // Purple (Appointments)
  static const Color purple       = Color(0xFF7C3AED);
  static const Color purpleLight  = Color(0xFFF0EBFF);

  // Blue (Info)
  static const Color blue         = Color(0xFF1565C0);
  static const Color blueLight    = Color(0xFFE3F0FF);

  // Amber (Warning)
  static const Color amber        = Color(0xFFF59E0B);
  static const Color amberLight   = Color(0xFFFFFBEB);

  // Green (Success)
  static const Color green        = Color(0xFF16A34A);
  static const Color greenLight   = Color(0xFFF0FDF4);

  // Neutral
  static const Color background   = Color(0xFFF0F4F8);
  static const Color surface      = Color(0xFFFFFFFF);
  static const Color border       = Color(0xFFE2E8F0);
  static const Color textPrimary  = Color(0xFF0A1628);
  static const Color textSecondary= Color(0xFF4A5568);
  static const Color textHint     = Color(0xFF94A3B8);

  // Agent Colors Map
  static Color agentColor(String agentName) {
    switch (agentName) {
      case 'Orchestrator':      return teal;
      case 'Emergency Agent':   return red;
      case 'Symptom Analyst':   return blue;
      case 'Appointment Agent': return purple;
      case 'Report Explainer':  return amber;
      case 'Navigation Agent':  return green;
      default:                  return teal;
    }
  }

  static Color agentLightColor(String agentName) {
    switch (agentName) {
      case 'Orchestrator':      return tealLight;
      case 'Emergency Agent':   return redLight;
      case 'Symptom Analyst':   return blueLight;
      case 'Appointment Agent': return purpleLight;
      case 'Report Explainer':  return amberLight;
      case 'Navigation Agent':  return greenLight;
      default:                  return tealLight;
    }
  }
}
