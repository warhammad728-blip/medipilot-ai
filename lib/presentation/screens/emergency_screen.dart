import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../widgets/lottie_or_fallback.dart';

class EmergencyScreen extends StatefulWidget {
  const EmergencyScreen({super.key});

  @override
  State<EmergencyScreen> createState() => _EmergencyScreenState();
}

class _EmergencyScreenState extends State<EmergencyScreen> {
  final Set<String> _selectedSymptoms = {};
  String? _selectedSeverity;
  String? _selectedDuration;

  final _symptoms = [
    'Chest Pain',
    'Breathing Difficulty',
    'Stroke Signs',
    'Heavy Bleeding',
    'Unconscious',
    'Severe Headache',
    'Fainting',
  ];

  final _severities = ['1-3 (Mild)', '4-6 (Moderate)', '7-9 (Severe)', '10 (Unbearable)'];
  final _durations = ['Just started', '< 30 minutes', '30-60 minutes', 'Over 1 hour'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.red,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '🚨 Emergency Triage',
              style: GoogleFonts.poppins(
                fontSize: 18,
                fontWeight: FontWeight.w800,
                color: Colors.white,
              ),
            ),
            Text(
              'Emergency Response Agent Active',
              style: AppTextStyles.caption.copyWith(color: Colors.white70),
            ),
          ],
        ),
        leading: IconButton(
          icon: const Icon(Icons.close, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      backgroundColor: AppColors.redLight,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // ── Pulsing Heart ────────────────────────────────
            Center(
              child: LottieOrFallback(
                assetPath: 'assets/animations/heartbeat.json',
                width: 100,
                height: 100,
                fallback: const HeartbeatFallback(size: 100),
              ),
            ),
            const SizedBox(height: 20),

            // ── Card 1: Symptoms ─────────────────────────────
            _buildTriageCard(
              title: 'What are the primary symptoms?',
              child: Wrap(
                spacing: 8,
                runSpacing: 8,
                children: _symptoms.map((symptom) {
                  final isSelected = _selectedSymptoms.contains(symptom);
                  return FilterChip(
                    label: Text(symptom),
                    selected: isSelected,
                    selectedColor: AppColors.red.withValues(alpha: 0.2),
                    checkmarkColor: AppColors.red,
                    labelStyle: AppTextStyles.bodySmall.copyWith(
                      color: isSelected ? AppColors.redDark : AppColors.textPrimary,
                    ),
                    onSelected: (val) {
                      setState(() {
                        if (val) {
                          _selectedSymptoms.add(symptom);
                        } else {
                          _selectedSymptoms.remove(symptom);
                        }
                      });
                    },
                  );
                }).toList(),
              ),
            ),
            const SizedBox(height: 12),

            // ── Card 2: Severity ─────────────────────────────
            _buildTriageCard(
              title: 'How severe is the pain? (1-10)',
              child: Wrap(
                spacing: 8,
                runSpacing: 8,
                children: _severities.map((sev) {
                  final isSelected = _selectedSeverity == sev;
                  return ChoiceChip(
                    label: Text(sev),
                    selected: isSelected,
                    selectedColor: AppColors.red.withValues(alpha: 0.2),
                    labelStyle: AppTextStyles.bodySmall.copyWith(
                      color: isSelected ? AppColors.redDark : AppColors.textPrimary,
                    ),
                    onSelected: (_) => setState(() => _selectedSeverity = sev),
                  );
                }).toList(),
              ),
            ),
            const SizedBox(height: 12),

            // ── Card 3: Duration ─────────────────────────────
            _buildTriageCard(
              title: 'How long has this been happening?',
              child: Wrap(
                spacing: 8,
                runSpacing: 8,
                children: _durations.map((dur) {
                  final isSelected = _selectedDuration == dur;
                  return ChoiceChip(
                    label: Text(dur),
                    selected: isSelected,
                    selectedColor: AppColors.red.withValues(alpha: 0.2),
                    labelStyle: AppTextStyles.bodySmall.copyWith(
                      color: isSelected ? AppColors.redDark : AppColors.textPrimary,
                    ),
                    onSelected: (_) => setState(() => _selectedDuration = dur),
                  );
                }).toList(),
              ),
            ),
            const SizedBox(height: 20),

            // ── AI Reasoning Card ────────────────────────────
            _buildAiReasoningCard(),
            const SizedBox(height: 20),

            // ── Escalate Button ──────────────────────────────
            SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton.icon(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (ctx) => AlertDialog(
                      title: const Text('Confirm Escalation'),
                      content: const Text(
                        'This will notify the emergency team immediately. Continue?',
                      ),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(ctx),
                          child: const Text('Cancel'),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            Navigator.pop(ctx);
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('✅ Emergency team notified. Help is on the way.'),
                                backgroundColor: AppColors.green,
                              ),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.red,
                          ),
                          child: const Text('Confirm', style: TextStyle(color: Colors.white)),
                        ),
                      ],
                    ),
                  );
                },
                icon: const Icon(Icons.local_hospital, color: Colors.white),
                label: Text(
                  'ESCALATE TO EMERGENCY TEAM',
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.red,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 12),

            // ── Call 1122 ────────────────────────────────────
            const Text('or', style: TextStyle(color: AppColors.textHint)),
            const SizedBox(height: 4),
            GestureDetector(
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Calling 1122...'),
                    backgroundColor: AppColors.red,
                  ),
                );
              },
              child: Text(
                'Call 1122 directly',
                style: AppTextStyles.bodyBold.copyWith(
                  color: AppColors.red,
                  decoration: TextDecoration.underline,
                ),
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildTriageCard({required String title, required Widget child}) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(14),
        border: const Border(
          left: BorderSide(color: AppColors.red, width: 3),
        ),
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: AppTextStyles.bodyBold),
          const SizedBox(height: 10),
          child,
        ],
      ),
    );
  }

  Widget _buildAiReasoningCard() {
    final steps = [
      'Chest pain + severity 7–9 detected',
      'Pattern matches acute cardiac event',
      'Activating Emergency Response Agent',
      'Notifying cardiac team and ER',
    ];

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.navyMid,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Text('🧠', style: TextStyle(fontSize: 16)),
              const SizedBox(width: 6),
              Text(
                'AI Reasoning',
                style: AppTextStyles.bodyBold.copyWith(color: AppColors.teal),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ...steps.asMap().entries.map((entry) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 8),
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
                      style: AppTextStyles.bodySmall.copyWith(color: Colors.white70),
                    ),
                  ),
                ],
              ),
            )
                .animate()
                .fadeIn(delay: (entry.key * 200).ms, duration: 400.ms)
                .slideX(begin: -0.1, end: 0);
          }),
          const SizedBox(height: 10),
          Text(
            'Cardiac Emergency — 91% confidence',
            style: AppTextStyles.caption.copyWith(color: AppColors.teal),
          ),
          const SizedBox(height: 4),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: const LinearProgressIndicator(
              value: 0.91,
              backgroundColor: AppColors.navyLight,
              valueColor: AlwaysStoppedAnimation<Color>(AppColors.teal),
              minHeight: 6,
            ),
          ),
        ],
      ),
    );
  }
}
