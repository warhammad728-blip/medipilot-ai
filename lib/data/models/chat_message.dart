class ChatMessage {
  final String id;
  final String text;
  final bool isUser;
  final String agentName;
  final DateTime timestamp;
  final bool isEmergency;
  final List<String> reasoningSteps;
  final double confidenceScore;

  ChatMessage({
    required this.id,
    required this.text,
    required this.isUser,
    this.agentName = 'Orchestrator',
    DateTime? timestamp,
    this.isEmergency = false,
    this.reasoningSteps = const [],
    this.confidenceScore = 0.85,
  }) : timestamp = timestamp ?? DateTime.now();
}
