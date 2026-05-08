import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../providers/chat_provider.dart';
import '../widgets/message_bubble.dart';
import '../widgets/reasoning_card.dart';
import '../widgets/emergency_banner.dart';
import '../widgets/lottie_or_fallback.dart';

class ChatScreen extends ConsumerStatefulWidget {
  const ChatScreen({super.key});

  @override
  ConsumerState<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends ConsumerState<ChatScreen> {
  final _controller = TextEditingController();
  final _scrollController = ScrollController();
  final _focusNode = FocusNode();

  @override
  void dispose() {
    _controller.dispose();
    _scrollController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  void _sendMessage(String text) {
    if (text.trim().isEmpty) return;
    ref.read(chatProvider.notifier).sendMessage(text);
    _controller.clear();
    _scrollToBottom();
  }

  @override
  Widget build(BuildContext context) {
    final chatState = ref.watch(chatProvider);

    // Auto-scroll when messages change
    ref.listen(chatProvider, (prev, next) {
      if (prev?.messages.length != next.messages.length || prev?.isLoading != next.isLoading) {
        _scrollToBottom();
      }
    });

    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.navyDark,
        title: Text('MediPilot AI', style: AppTextStyles.headingWhite.copyWith(fontSize: 18)),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => context.go('/'),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete_outline, color: Colors.white70),
            onPressed: () => ref.read(chatProvider.notifier).clearChat(),
            tooltip: 'Clear chat',
          ),
        ],
      ),
      body: Column(
        children: [
          // Emergency banner
          if (chatState.isEmergencyDetected)
            EmergencyBanner(
              onGoToEmergency: () => context.go('/emergency'),
              onDismiss: () => ref.read(chatProvider.notifier).dismissEmergency(),
            ),

          // Messages list
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.only(top: 12, bottom: 8),
              itemCount: chatState.messages.length + (chatState.isLoading ? 1 : 0),
              itemBuilder: (context, index) {
                // Typing indicator at the end
                if (index == chatState.messages.length) {
                  return Align(
                    alignment: Alignment.centerLeft,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 16, top: 8, bottom: 8),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const LottieOrFallback(
                            assetPath: 'assets/animations/medical_loader.json',
                            width: 50,
                            height: 50,
                            fallback: MedicalLoaderFallback(size: 50),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'MediPilot is thinking...',
                            style: AppTextStyles.caption.copyWith(color: AppColors.teal),
                          ),
                        ],
                      ),
                    ),
                  );
                }

                final message = chatState.messages[index];
                return Column(
                  children: [
                    MessageBubble(message: message),
                    // Show reasoning card for AI messages
                    if (!message.isUser && message.reasoningSteps.isNotEmpty)
                      ReasoningCard(
                        reasoningSteps: message.reasoningSteps,
                        confidenceScore: message.confidenceScore,
                        agentName: message.agentName,
                      ),
                  ],
                );
              },
            ),
          ),

          // Quick reply chips
          SizedBox(
            height: 42,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 12),
              children: [
                'I have symptoms',
                'Book appointment',
                'Explain my report',
                'Emergency help',
                'Nearest pharmacy',
              ].map((text) {
                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: ActionChip(
                    label: Text(text, style: AppTextStyles.bodySmall),
                    backgroundColor: AppColors.surface,
                    side: const BorderSide(color: AppColors.border),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    onPressed: () => _sendMessage(text),
                  ),
                );
              }).toList(),
            ),
          ),
          const SizedBox(height: 4),

          // Input bar
          _buildInputBar(),
        ],
      ),
    );
  }

  Widget _buildInputBar() {
    return Container(
      padding: EdgeInsets.only(
        left: 12,
        right: 8,
        top: 8,
        bottom: MediaQuery.of(context).padding.bottom + 8,
      ),
      decoration: BoxDecoration(
        color: AppColors.surface,
        border: Border(
          top: BorderSide(color: AppColors.border.withValues(alpha: 0.5)),
        ),
      ),
      child: Row(
        children: [
          // Attachment button
          IconButton(
            icon: const Icon(Icons.attach_file, color: AppColors.textHint),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('File picker coming with report upload')),
              );
            },
          ),
          // Text field
          Expanded(
            child: TextField(
              controller: _controller,
              focusNode: _focusNode,
              textCapitalization: TextCapitalization.sentences,
              decoration: InputDecoration(
                hintText: 'Type your message...',
                filled: true,
                fillColor: AppColors.background,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 10,
                ),
              ),
              onSubmitted: _sendMessage,
            ),
          ),
          const SizedBox(width: 4),
          // Send button
          ValueListenableBuilder<TextEditingValue>(
            valueListenable: _controller,
            builder: (context, value, _) {
              final hasText = value.text.trim().isNotEmpty;
              return IconButton(
                icon: Icon(
                  Icons.send_rounded,
                  color: hasText ? AppColors.teal : AppColors.textHint,
                ),
                onPressed: hasText
                    ? () => _sendMessage(_controller.text)
                    : null,
              );
            },
          ),
        ],
      ),
    );
  }
}
