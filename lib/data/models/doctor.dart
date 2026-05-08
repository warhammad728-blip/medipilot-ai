import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';

class Doctor {
  final String name;
  final String specialty;
  final double rating;
  final int reviewCount;
  final String emoji;
  final Color avatarColor;
  final List<String> availableSlots;
  final bool isAiRecommended;
  final String reason;

  const Doctor({
    required this.name,
    required this.specialty,
    required this.rating,
    required this.reviewCount,
    required this.emoji,
    required this.avatarColor,
    required this.availableSlots,
    this.isAiRecommended = false,
    this.reason = '',
  });
}

// Mock doctor data
class MockDoctors {
  static const List<Doctor> doctors = [
    Doctor(
      name: 'Dr. Asad Mehmood',
      specialty: 'Endocrinologist',
      rating: 4.9,
      reviewCount: 234,
      emoji: '👨‍⚕️',
      avatarColor: AppColors.blueLight,
      availableSlots: ['Today 4:00 PM', 'Today 6:00 PM', 'Tomorrow 10:00 AM'],
      isAiRecommended: true,
      reason: 'Based on your elevated glucose & HbA1c levels',
    ),
    Doctor(
      name: 'Dr. Saba Qureshi',
      specialty: 'Cardiologist',
      rating: 4.7,
      reviewCount: 188,
      emoji: '👩‍⚕️',
      avatarColor: AppColors.purpleLight,
      availableSlots: ['Tomorrow 2:00 PM', 'Saturday 11:00 AM'],
    ),
    Doctor(
      name: 'Dr. Kamran Ali',
      specialty: 'General Physician',
      rating: 4.8,
      reviewCount: 312,
      emoji: '🧑‍⚕️',
      avatarColor: AppColors.tealLight,
      availableSlots: ['Today 5:00 PM', 'Today 7:00 PM'],
    ),
    Doctor(
      name: 'Dr. Hina Malik',
      specialty: 'Neurologist',
      rating: 4.6,
      reviewCount: 156,
      emoji: '👩‍⚕️',
      avatarColor: AppColors.amberLight,
      availableSlots: ['Monday 9:00 AM', 'Monday 11:00 AM'],
    ),
  ];
}
