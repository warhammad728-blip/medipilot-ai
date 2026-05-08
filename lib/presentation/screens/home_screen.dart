import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../widgets/agent_pill.dart';
import '../widgets/emergency_banner.dart';
import '../widgets/lottie_or_fallback.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Header ──────────────────────────────────────
            _buildHeader(context),
            const SizedBox(height: 8),

            // ── Emergency Banner ────────────────────────────
            EmergencyBanner(
              onGoToEmergency: () => context.go('/emergency'),
              onDismiss: () {},
            ),
            const SizedBox(height: 16),

            // ── Quick Actions ───────────────────────────────
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text('Quick Actions', style: AppTextStyles.heading2),
            ),
            const SizedBox(height: 10),
            _buildQuickActions(context),
            const SizedBox(height: 24),

            // ── Active AI Agents ────────────────────────────
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text('Active AI Agents', style: AppTextStyles.heading2),
            ),
            const SizedBox(height: 10),
            _buildAgentsList(),
            const SizedBox(height: 24),

            // ── Today's Insight ─────────────────────────────
            _buildInsightCard(),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.only(
        top: MediaQuery.of(context).padding.top + 16,
        left: 20,
        right: 20,
        bottom: 20,
      ),
      decoration: const BoxDecoration(
        color: AppColors.navyDark,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(24),
          bottomRight: Radius.circular(24),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Good morning,',
                    style: AppTextStyles.body.copyWith(color: AppColors.textHint),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    'Ali Hassan 👋',
                    style: AppTextStyles.heading1.copyWith(color: Colors.white),
                  ),
                ],
              ),
              CircleAvatar(
                radius: 22,
                backgroundColor: AppColors.blueLight,
                child: const Icon(Icons.person, color: AppColors.blue, size: 24),
              ),
            ],
          )
              .animate()
              .fadeIn(duration: 500.ms),
          const SizedBox(height: 12),
          // AI Pulse animation
          const LottieOrFallback(
            assetPath: 'assets/animations/ai_pulse.json',
            width: 50,
            height: 50,
            fallback: AiPulseFallback(size: 50),
          ),
          const SizedBox(height: 8),
          // Agents online pill
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: AppColors.navyLight,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 8,
                  height: 8,
                  decoration: const BoxDecoration(
                    color: AppColors.green,
                    shape: BoxShape.circle,
                  ),
                )
                    .animate(onPlay: (c) => c.repeat(reverse: true))
                    .scale(
                      begin: const Offset(1.0, 1.0),
                      end: const Offset(1.3, 1.3),
                      duration: 800.ms,
                    ),
                const SizedBox(width: 8),
                Text(
                  '● 6 AI Agents Online',
                  style: AppTextStyles.bodySmall.copyWith(color: AppColors.teal),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickActions(BuildContext context) {
    final actions = [
      _QuickAction('💬', 'Ask\nMediPilot', AppColors.blueLight, () => context.go('/chat')),
      _QuickAction('📅', 'Book\nAppointment', AppColors.purpleLight, () => context.go('/appointments')),
      _QuickAction('📊', 'Report\nAnalysis', AppColors.tealLight, () => context.go('/reports')),
      _QuickAction('🏥', 'Health\nVault', AppColors.amberLight, () {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Coming soon!')),
        );
      }),
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: 12,
          crossAxisSpacing: 12,
          childAspectRatio: 1.5,
        ),
        itemCount: actions.length,
        itemBuilder: (context, index) {
          final action = actions[index];
          return GestureDetector(
            onTap: action.onTap,
            child: Container(
              decoration: BoxDecoration(
                color: action.color,
                borderRadius: BorderRadius.circular(16),
              ),
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(action.emoji, style: const TextStyle(fontSize: 28)),
                  const SizedBox(height: 8),
                  Text(action.label, style: AppTextStyles.bodyBold),
                ],
              ),
            ),
          )
              .animate()
              .fadeIn(delay: (index * 100).ms, duration: 400.ms)
              .slideY(begin: 0.1, end: 0);
        },
      ),
    );
  }

  Widget _buildAgentsList() {
    final agents = ['Symptom Analyst', 'Appointment Agent', 'Report Explainer'];
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: agents.map((agent) {
          return Container(
            margin: const EdgeInsets.only(bottom: 8),
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.border, width: 0.5),
            ),
            child: Row(
              children: [
                AgentPill(agentName: agent),
                const Spacer(),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: AppColors.greenLight,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    'Ready',
                    style: AppTextStyles.agentTag.copyWith(color: AppColors.green),
                  ),
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildInsightCard() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.tealLight,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.teal.withValues(alpha: 0.2)),
      ),
      child: Row(
        children: [
          const Text('💡', style: TextStyle(fontSize: 28)),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Today's Insight", style: AppTextStyles.bodyBold),
                const SizedBox(height: 4),
                Text(
                  'Your glucose improved 8% since last month. Consider booking with Dr. Asad.',
                  style: AppTextStyles.bodySmall,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _QuickAction {
  final String emoji;
  final String label;
  final Color color;
  final VoidCallback onTap;

  const _QuickAction(this.emoji, this.label, this.color, this.onTap);
}
