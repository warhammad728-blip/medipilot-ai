import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../data/models/lab_result.dart';

class LabResultCard extends StatelessWidget {
  final LabResult result;

  const LabResultCard({super.key, required this.result});

  Color _statusColor(LabStatus status) {
    switch (status) {
      case LabStatus.high:   return AppColors.red;
      case LabStatus.low:    return AppColors.amber;
      case LabStatus.normal: return AppColors.green;
      case LabStatus.watch:  return AppColors.amber;
    }
  }

  Color _statusBgColor(LabStatus status) {
    switch (status) {
      case LabStatus.high:   return AppColors.redLight;
      case LabStatus.low:    return AppColors.amberLight;
      case LabStatus.normal: return AppColors.greenLight;
      case LabStatus.watch:  return AppColors.amberLight;
    }
  }

  @override
  Widget build(BuildContext context) {
    final color = _statusColor(result.status);
    final bgColor = _statusBgColor(result.status);

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border, width: 0.5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            decoration: const BoxDecoration(
              color: AppColors.navyDark,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(12),
                topRight: Radius.circular(12),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    result.testName,
                    style: AppTextStyles.bodyBold.copyWith(color: Colors.white),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                  decoration: BoxDecoration(
                    color: bgColor,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    result.statusLabel,
                    style: AppTextStyles.agentTag.copyWith(
                      color: color,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
              ],
            ),
          ),
          // Body
          Padding(
            padding: const EdgeInsets.all(14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      '${result.value} ${result.unit}',
                      style: AppTextStyles.heading3.copyWith(color: color),
                    ),
                    const Spacer(),
                    Text(
                      'Normal: ${result.normalRange}',
                      style: AppTextStyles.bodySmall,
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  result.explanation,
                  style: AppTextStyles.bodySmall.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
