import 'dart:typed_data';
import 'package:google_generative_ai/google_generative_ai.dart';
import '../../core/constants/app_constants.dart';

class GeminiService {
  static final GeminiService _instance = GeminiService._internal();
  factory GeminiService() => _instance;
  GeminiService._internal();

  late final GenerativeModel _model;
  late ChatSession _chat;

  static const String _systemPrompt = """
You are MediPilot AI, an autonomous hospital assistant with 6 specialized agents.
You MUST always start your response with an agent tag in this exact format: [AGENT:AgentName]

Agents and when to use them:
[AGENT:Orchestrator] - General questions, greetings, routing decisions
[AGENT:SymptomAnalyst] - When user mentions any symptoms, pain, feeling unwell
[AGENT:EmergencyAgent] - IMMEDIATELY when detecting: chest pain, breathing difficulty, 
  stroke, unconscious, heart attack, heavy bleeding, seena dard, saans nahi, 
  dil ka dora, behosh — ANY emergency signal in any language
[AGENT:AppointmentAgent] - Booking, scheduling, finding a doctor
[AGENT:ReportExplainer] - Lab reports, test results, medical documents
[AGENT:NavigationAgent] - Hospital departments, locations, directions

EMERGENCY is your HIGHEST priority. When [AGENT:EmergencyAgent] activates:
1. Acknowledge the emergency immediately
2. Ask these 3 triage questions:
   - What are the exact symptoms?
   - How severe is the pain on a scale of 1-10?
   - How long has this been happening?
3. Advise to call 1122 (Pakistan emergency number)
4. Tell them to not move the patient

After EVERY response, append this section exactly:
[REASONING]
- Step 1: (what you detected in the user message)
- Step 2: (which agent you activated and why)  
- Step 3: (what action you are taking)
[CONFIDENCE:85]
[/REASONING]

Replace 85 with actual confidence number between 60-99.
Keep responses concise and clear. Support English and Urdu/Roman Urdu.
If user writes in Roman Urdu, respond in Roman Urdu mixed with English.
""";

  void initialize() {
    _model = GenerativeModel(
      model: AppConstants.geminiModel,
      apiKey: AppConstants.geminiApiKey,
      systemInstruction: Content.system(_systemPrompt),
      generationConfig: GenerationConfig(
        temperature: 0.7,
        maxOutputTokens: 1024,
      ),
    );
    _startNewChat();
  }

  void _startNewChat() {
    _chat = _model.startChat(history: []);
  }

  Future<String> sendMessage(String message, {Uint8List? imageData}) async {
    try {
      Content content;
      if (imageData != null) {
        content = Content.multi([
          DataPart('image/jpeg', imageData),
          TextPart(message),
        ]);
      } else {
        content = Content.text(message);
      }
      final response = await _chat.sendMessage(content);
      return response.text ?? 'Sorry, I could not process that request.';
    } catch (e) {
      return '[AGENT:Orchestrator]\nI apologize, I am having trouble connecting right now. Please try again.\n[REASONING]\n- Step 1: Connection error detected\n- Step 2: Orchestrator handling fallback\n- Step 3: Requesting retry\n[CONFIDENCE:60]\n[/REASONING]';
    }
  }

  Stream<String> sendMessageStream(String message) async* {
    try {
      final response = _chat.sendMessageStream(Content.text(message));
      await for (final chunk in response) {
        if (chunk.text != null) yield chunk.text!;
      }
    } catch (e) {
      yield 'Connection error. Please try again.';
    }
  }

  void clearHistory() => _startNewChat();

  // ── Parsers ──────────────────────────────────────────

  static String extractAgentName(String response) {
    final match = RegExp(r'\[AGENT:(\w+)\]').firstMatch(response);
    if (match == null) return 'Orchestrator';
    final raw = match.group(1) ?? 'Orchestrator';
    switch (raw) {
      case 'EmergencyAgent':    return 'Emergency Agent';
      case 'SymptomAnalyst':    return 'Symptom Analyst';
      case 'AppointmentAgent':  return 'Appointment Agent';
      case 'ReportExplainer':   return 'Report Explainer';
      case 'NavigationAgent':   return 'Navigation Agent';
      default:                  return 'Orchestrator';
    }
  }

  static List<String> extractReasoning(String response) {
    final match = RegExp(
      r'\[REASONING\](.*?)\[/REASONING\]',
      dotAll: true,
    ).firstMatch(response);
    if (match == null) return [];
    final block = match.group(1) ?? '';
    return block
        .split('\n')
        .map((l) => l.trim())
        .where((l) => l.startsWith('- '))
        .map((l) => l.substring(2))
        .toList();
  }

  static double extractConfidence(String response) {
    final match = RegExp(r'\[CONFIDENCE:(\d+)\]').firstMatch(response);
    return double.tryParse(match?.group(1) ?? '80') ?? 80.0;
  }

  static String cleanResponse(String response) {
    return response
        .replaceAll(RegExp(r'\[AGENT:\w+\]'), '')
        .replaceAll(RegExp(r'\[REASONING\].*?\[/REASONING\]', dotAll: true), '')
        .replaceAll(RegExp(r'\[CONFIDENCE:\d+\]'), '')
        .trim();
  }

  static bool isEmergencyResponse(String agentName) {
    return agentName == 'Emergency Agent';
  }
}
