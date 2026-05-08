import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../data/models/doctor.dart';

class DoctorCard extends StatelessWidget {
  final Doctor doctor;
  final VoidCallback? onBook;

  const DoctorCard({super.key, required this.doctor, this.onBook});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border, width: 0.5),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Top row: avatar + info
            Row(
              children: [
                // Emoji avatar
                Container(
                  width: 52,
                  height: 52,
                  decoration: BoxDecoration(
                    color: doctor.avatarColor,
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Text(doctor.emoji, style: const TextStyle(fontSize: 24)),
                  ),
                ),
                const SizedBox(width: 12),
                // Name + specialty
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(doctor.name, style: AppTextStyles.heading3),
                      Text(
                        doctor.specialty,
                        style: AppTextStyles.bodySmall.copyWith(color: AppColors.teal),
                      ),
                    ],
                  ),
                ),
                // AI badge
                if (doctor.isAiRecommended)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppColors.tealLight,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.auto_awesome, size: 12, color: AppColors.teal),
                        const SizedBox(width: 3),
                        Text(
                          'AI Pick',
                          style: AppTextStyles.agentTag.copyWith(color: AppColors.teal),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 10),
            // Star rating
            Row(
              children: [
                const Icon(Icons.star, size: 16, color: AppColors.amber),
                const SizedBox(width: 3),
                Text(
                  '${doctor.rating}',
                  style: AppTextStyles.bodyBold,
                ),
                const SizedBox(width: 4),
                Text(
                  '(${doctor.reviewCount} reviews)',
                  style: AppTextStyles.bodySmall,
                ),
              ],
            ),
            // AI reason
            if (doctor.isAiRecommended && doctor.reason.isNotEmpty) ...[
              const SizedBox(height: 8),
              Text(
                doctor.reason,
                style: AppTextStyles.bodySmall.copyWith(
                  fontStyle: FontStyle.italic,
                  color: AppColors.textHint,
                ),
              ),
            ],
            const SizedBox(height: 10),
            // Available slots
            Wrap(
              spacing: 6,
              runSpacing: 6,
              children: doctor.availableSlots.map((slot) {
                return Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                    color: AppColors.tealLight,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    slot,
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.tealDark,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 12),
            // Book button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: onBook,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.navyDark,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 12),
                ),
                child: const Text('Book Appointment'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
