import 'dart:typed_data';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/constants/app_constants.dart';
import '../../data/models/chat_message.dart';
import '../../data/models/doctor.dart';
import '../../data/services/gemini_service.dart';

// ── State ────────────────────────────────────────────

class ChatState {
  final List<ChatMessage> messages;
  final bool isLoading;
  final String activeAgent;
  final bool isEmergencyDetected;
  final String streamingText;

  const ChatState({
    this.messages = const [],
    this.isLoading = false,
    this.activeAgent = 'Orchestrator',
    this.isEmergencyDetected = false,
    this.streamingText = '',
  });

  ChatState copyWith({
    List<ChatMessage>? messages,
    bool? isLoading,
    String? activeAgent,
    bool? isEmergencyDetected,
    String? streamingText,
  }) {
    return ChatState(
      messages: messages ?? this.messages,
      isLoading: isLoading ?? this.isLoading,
      activeAgent: activeAgent ?? this.activeAgent,
      isEmergencyDetected: isEmergencyDetected ?? this.isEmergencyDetected,
      streamingText: streamingText ?? this.streamingText,
    );
  }
}

// ── Notifier ─────────────────────────────────────────

class ChatNotifier extends Notifier<ChatState> {
  late final GeminiService _gemini;

  @override
  ChatState build() {
    _gemini = ref.watch(geminiServiceProvider);
    final welcome = ChatMessage(
      id: 'welcome',
      text: 'Hello! I am MediPilot AI. I can help you with symptoms, appointments, lab reports, emergency guidance, and more. How can I assist you today?',
      isUser: false,
      agentName: 'Orchestrator',
      reasoningSteps: [
        'User opened the app',
        'Orchestrator activated for initial greeting',
        'Welcome message delivered',
      ],
      confidenceScore: 99,
    );
    return ChatState(messages: [welcome]);
  }

  bool _checkEmergencyKeywords(String message) {
    final lower = message.toLowerCase();
    return AppConstants.emergencyKeywords
        .any((keyword) => lower.contains(keyword));
  }

  Future<void> sendMessage(String text, {Uint8List? imageData}) async {
    if (text.trim().isEmpty) return;

    // Add user message
    final userMsg = ChatMessage(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      text: text,
      isUser: true,
    );

    state = state.copyWith(
      messages: [...state.messages, userMsg],
      isLoading: true,
      isEmergencyDetected: _checkEmergencyKeywords(text),
    );

    try {
      final prompt = imageData != null
          ? 'The patient has uploaded a medical report image. $text\nAnalyze this report: list each test with value, normal range, and status (HIGH/LOW/NORMAL/WATCH). Give a plain language summary and next steps.'
          : text;

      final response = await _gemini.sendMessage(prompt, imageData: imageData);

      final agentName = GeminiService.extractAgentName(response);
      final reasoning = GeminiService.extractReasoning(response);
      final confidence = GeminiService.extractConfidence(response);
      final cleanText = GeminiService.cleanResponse(response);
      final isEmergency = GeminiService.isEmergencyResponse(agentName);

      final aiMsg = ChatMessage(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        text: cleanText,
        isUser: false,
        agentName: agentName,
        isEmergency: isEmergency,
        reasoningSteps: reasoning,
        confidenceScore: confidence,
      );

      state = state.copyWith(
        messages: [...state.messages, aiMsg],
        isLoading: false,
        activeAgent: agentName,
        isEmergencyDetected: isEmergency || state.isEmergencyDetected,
      );
    } catch (e) {
      state = state.copyWith(isLoading: false);
    }
  }

  void clearChat() {
    _gemini.clearHistory();
    state = build();
  }

  void dismissEmergency() {
    state = state.copyWith(isEmergencyDetected: false);
  }
}

// ── Providers ─────────────────────────────────────────

final geminiServiceProvider = Provider<GeminiService>((ref) {
  final service = GeminiService();
  service.initialize();
  return service;
});

final chatProvider = NotifierProvider<ChatNotifier, ChatState>(
  ChatNotifier.new,
);

final doctorsProvider = Provider((ref) => MockDoctors.doctors);
