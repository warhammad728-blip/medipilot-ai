import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';

class AgentPill extends StatelessWidget {
  final String agentName;
  final bool isActive;

  const AgentPill({
    super.key,
    required this.agentName,
    this.isActive = true,
  });

  @override
  Widget build(BuildContext context) {
    final color = AppColors.agentColor(agentName);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: AppColors.agentLightColor(agentName),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Pulsing dot
          Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
            ),
          )
              .animate(onPlay: (c) => c.repeat(reverse: true))
              .scale(
                begin: const Offset(1.0, 1.0),
                end: const Offset(1.4, 1.4),
                duration: 800.ms,
              )
              .fadeIn(duration: 300.ms),
          const SizedBox(width: 6),
          Text(
            agentName,
            style: AppTextStyles.agentTag.copyWith(color: color),
          ),
        ],
      ),
    );
  }
}
