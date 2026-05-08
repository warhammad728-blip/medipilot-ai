import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import 'package:shimmer/shimmer.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../data/models/lab_result.dart';
import '../widgets/lab_result_card.dart';
import '../widgets/lottie_or_fallback.dart';

class ReportScreen extends StatefulWidget {
  const ReportScreen({super.key});

  @override
  State<ReportScreen> createState() => _ReportScreenState();
}

class _ReportScreenState extends State<ReportScreen> {
  bool _isAnalyzing = false;
  String? _fileName;

  void _pickFile() async {
    // Simulate file pick
    setState(() {
      _isAnalyzing = true;
      _fileName = 'blood_report_may2026.pdf';
    });
    // Simulate analysis delay
    await Future.delayed(const Duration(seconds: 2));
    if (mounted) {
      setState(() {
        _isAnalyzing = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.navyDark,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Report Explainer', style: AppTextStyles.headingWhite.copyWith(fontSize: 18)),
            Text(
              'AI-powered analysis',
              style: AppTextStyles.caption.copyWith(color: Colors.white54),
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Upload Zone ─────────────────────────────────
            _buildUploadZone(),
            const SizedBox(height: 16),

            // ── File chip ───────────────────────────────────
            if (_fileName != null) _buildFileChip(),

            // ── Loading shimmer ─────────────────────────────
            if (_isAnalyzing) _buildShimmer(),

            // ── Results ─────────────────────────────────────
            if (_fileName != null && !_isAnalyzing) ...[
              const SizedBox(height: 20),
              Text(
                'Latest Report — $_fileName',
                style: AppTextStyles.heading3,
              ),
              Text(
                'May 8, 2026',
                style: AppTextStyles.bodySmall,
              ),
              const SizedBox(height: 12),
              ...MockLabResults.results.map(
                (result) => LabResultCard(result: result),
              ),
              const SizedBox(height: 16),
              _buildAiExplanation(),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildUploadZone() {
    return GestureDetector(
      onTap: _pickFile,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 32),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: AppColors.teal.withValues(alpha: 0.4),
            width: 1.5,
          ),
        ),
        child: Column(
          children: [
            Icon(
              Icons.cloud_upload_outlined,
              size: 48,
              color: AppColors.teal.withValues(alpha: 0.6),
            ),
            const SizedBox(height: 10),
            Text('Upload your lab report', style: AppTextStyles.bodyBold),
            const SizedBox(height: 4),
            Text(
              'PDF · Image · Scanned Report',
              style: AppTextStyles.bodySmall.copyWith(color: AppColors.teal),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFileChip() {
    return Container(
      margin: const EdgeInsets.only(top: 10),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.tealLight,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.description, size: 16, color: AppColors.teal),
          const SizedBox(width: 6),
          Text(
            _fileName!,
            style: AppTextStyles.bodySmall.copyWith(color: AppColors.tealDark),
          ),
          const SizedBox(width: 8),
          GestureDetector(
            onTap: () => setState(() {
              _fileName = null;
              _isAnalyzing = false;
            }),
            child: const Icon(Icons.close, size: 14, color: AppColors.textHint),
          ),
        ],
      ),
    );
  }

  Widget _buildShimmer() {
    return Column(
      children: [
        const SizedBox(height: 20),
        // Lottie medical loader
        const Center(
          child: LottieOrFallback(
            assetPath: 'assets/animations/medical_loader.json',
            width: 70,
            height: 70,
            fallback: MedicalLoaderFallback(size: 70),
          ),
        ),
        const SizedBox(height: 12),
        Shimmer.fromColors(
          baseColor: AppColors.border,
          highlightColor: AppColors.background,
          child: Column(
            children: List.generate(3, (i) {
              return Container(
                margin: const EdgeInsets.only(bottom: 12),
                height: 80,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                ),
              );
            }),
          ),
        ),
        Text(
          'AI is analyzing your report...',
          style: AppTextStyles.bodySmall.copyWith(color: AppColors.teal),
        ),
      ],
    );
  }

  Widget _buildAiExplanation() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.tealLight,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Text('🧠', style: TextStyle(fontSize: 20)),
              const SizedBox(width: 8),
              Text('AI Explanation', style: AppTextStyles.heading3),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            'Your blood glucose (138 mg/dL) and HbA1c (7.2%) are both elevated, '
            'indicating your diabetes management needs attention. Your hemoglobin and WBC '
            'are within normal ranges, which is good. LDL cholesterol is borderline high — '
            'consider dietary adjustments. I recommend consulting an Endocrinologist for '
            'glucose management.',
            style: AppTextStyles.body.copyWith(height: 1.5),
          ),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: () => context.go('/chat'),
              icon: const Icon(Icons.chat_bubble_outline, size: 16),
              label: const Text('Ask a follow-up question →'),
              style: OutlinedButton.styleFrom(
                foregroundColor: AppColors.tealDark,
                side: const BorderSide(color: AppColors.teal),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),
        ],
      ),
    )
        .animate()
        .fadeIn(duration: 500.ms)
        .slideY(begin: 0.05, end: 0);
  }
}
