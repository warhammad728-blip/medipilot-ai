import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';

class ReasoningCard extends StatefulWidget {
  final List<String> reasoningSteps;
  final double confidenceScore;
  final String agentName;

  const ReasoningCard({
    super.key,
    required this.reasoningSteps,
    required this.confidenceScore,
    required this.agentName,
  });

  @override
  State<ReasoningCard> createState() => _ReasoningCardState();
}

class _ReasoningCardState extends State<ReasoningCard> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    if (widget.reasoningSteps.isEmpty) return const SizedBox.shrink();

    return Container(
      margin: const EdgeInsets.only(left: 16, right: 60, top: 2, bottom: 8),
      decoration: BoxDecoration(
        color: AppColors.navyDark,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          // Tappable header
          InkWell(
            onTap: () => setState(() => _isExpanded = !_isExpanded),
            borderRadius: BorderRadius.circular(12),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              child: Row(
                children: [
                  const Text('🧠', style: TextStyle(fontSize: 14)),
                  const SizedBox(width: 6),
                  Text(
                    'AI Reasoning',
                    style: AppTextStyles.bodyBold.copyWith(color: AppColors.teal),
                  ),
                  const Spacer(),
                  // Agent chip
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    decoration: BoxDecoration(
                      color: AppColors.agentColor(widget.agentName).withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      widget.agentName,
                      style: AppTextStyles.agentTag.copyWith(
                        color: AppColors.agentColor(widget.agentName),
                      ),
                    ),
                  ),
                  const SizedBox(width: 6),
                  AnimatedRotation(
                    turns: _isExpanded ? 0.5 : 0,
                    duration: const Duration(milliseconds: 200),
                    child: const Icon(
                      Icons.expand_more,
                      color: AppColors.teal,
                      size: 20,
                    ),
                  ),
                ],
              ),
            ),
          ),
          // Expandable body
          AnimatedCrossFade(
            firstChild: const SizedBox.shrink(),
            secondChild: _buildBody(),
            crossFadeState: _isExpanded
                ? CrossFadeState.showSecond
                : CrossFadeState.showFirst,
            duration: const Duration(milliseconds: 250),
          ),
        ],
      ),
    );
  }

  Widget _buildBody() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(14, 0, 14, 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Divider(color: AppColors.navyLight, height: 1),
          const SizedBox(height: 10),
          // Reasoning steps
          ...widget.reasoningSteps.asMap().entries.map((entry) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 6),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 20,
                    height: 20,
                    decoration: BoxDecoration(
                      color: AppColors.teal.withValues(alpha: 0.2),
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Text(
                        '${entry.key + 1}',
                        style: AppTextStyles.caption.copyWith(
                          color: AppColors.teal,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      entry.value,
                      style: AppTextStyles.bodySmall.copyWith(
                        color: Colors.white70,
                      ),
                    ),
                  ),
                ],
              ),
            )
                .animate()
                .fadeIn(delay: (entry.key * 150).ms, duration: 300.ms)
                .slideX(begin: -0.1, end: 0);
          }),
          const SizedBox(height: 10),
          // Confidence bar
          Row(
            children: [
              Text(
                'Confidence: ${widget.confidenceScore.toInt()}%',
                style: AppTextStyles.caption.copyWith(color: AppColors.teal),
              ),
              const Spacer(),
            ],
          ),
          const SizedBox(height: 4),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: widget.confidenceScore / 100,
              backgroundColor: AppColors.navyLight,
              valueColor: const AlwaysStoppedAnimation<Color>(AppColors.teal),
              minHeight: 6,
            ),
          ),
        ],
      ),
    );
  }
}
