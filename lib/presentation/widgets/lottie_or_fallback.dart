import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:lottie/lottie.dart';
import '../../core/theme/app_colors.dart';

/// Tries to load a Lottie asset; falls back to a custom animated widget.
class LottieOrFallback extends StatelessWidget {
  final String assetPath;
  final double width;
  final double height;
  final Widget fallback;
  final BoxFit fit;

  const LottieOrFallback({
    super.key,
    required this.assetPath,
    required this.fallback,
    this.width = 80,
    this.height = 80,
    this.fit = BoxFit.contain,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height,
      child: Lottie.asset(
        assetPath,
        width: width,
        height: height,
        fit: fit,
        errorBuilder: (context, error, stackTrace) => fallback,
      ),
    );
  }
}

// ── Fallback Animated Widgets ────────────────────────────────

/// Teal pulsing rings — used on Home screen
class AiPulseFallback extends StatelessWidget {
  final double size;
  const AiPulseFallback({super.key, this.size = 60});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Outer ring
          Container(
            width: size,
            height: size,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: AppColors.teal.withValues(alpha: 0.3), width: 2),
            ),
          )
              .animate(onPlay: (c) => c.repeat(reverse: true))
              .scale(begin: const Offset(0.8, 0.8), end: const Offset(1.0, 1.0), duration: 1200.ms)
              .fadeIn(duration: 600.ms),
          // Inner dot
          Container(
            width: size * 0.4,
            height: size * 0.4,
            decoration: const BoxDecoration(
              color: AppColors.teal,
              shape: BoxShape.circle,
            ),
          )
              .animate(onPlay: (c) => c.repeat(reverse: true))
              .scale(begin: const Offset(0.9, 0.9), end: const Offset(1.1, 1.1), duration: 800.ms),
        ],
      ),
    );
  }
}

/// Red pulsing heart — used on Emergency screen
class HeartbeatFallback extends StatelessWidget {
  final double size;
  const HeartbeatFallback({super.key, this.size = 100});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            width: size,
            height: size,
            decoration: BoxDecoration(
              color: AppColors.red.withValues(alpha: 0.15),
              shape: BoxShape.circle,
            ),
          )
              .animate(onPlay: (c) => c.repeat(reverse: true))
              .scale(begin: const Offset(0.9, 0.9), end: const Offset(1.1, 1.1), duration: 800.ms),
          const Text('❤️', style: TextStyle(fontSize: 36)),
        ],
      ),
    );
  }
}

/// Teal spinning loader — used on Chat & Report screens
class MedicalLoaderFallback extends StatelessWidget {
  final double size;
  const MedicalLoaderFallback({super.key, this.size = 50});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: Stack(
        alignment: Alignment.center,
        children: [
          SizedBox(
            width: size,
            height: size,
            child: CircularProgressIndicator(
              strokeWidth: 3,
              valueColor: AlwaysStoppedAnimation<Color>(
                AppColors.teal.withValues(alpha: 0.7),
              ),
            ),
          ),
          Container(
            width: size * 0.3,
            height: size * 0.3,
            decoration: const BoxDecoration(
              color: AppColors.teal,
              shape: BoxShape.circle,
            ),
          )
              .animate(onPlay: (c) => c.repeat(reverse: true))
              .scale(begin: const Offset(0.7, 0.7), end: const Offset(1.0, 1.0), duration: 600.ms),
        ],
      ),
    );
  }
}
