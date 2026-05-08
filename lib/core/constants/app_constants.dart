class AppConstants {
  static const String appName = 'MediPilot AI';
  static const String hospitalName = 'MediPilot Hospital';
  static const String geminiApiKey = 'YOUR_API_KEY_HERE';
  static const String geminiModel = 'gemini-1.5-pro';
  
  // Emergency keywords (English + Urdu/Roman Urdu)
  static const List<String> emergencyKeywords = [
    'chest pain', 'heart attack', 'can\'t breathe', 'cannot breathe',
    'stroke', 'unconscious', 'not breathing', 'heavy bleeding',
    'seena dard', 'saans nahi', 'dil ka dora', 'behosh',
    'breathing difficulty', 'collapsed', 'seizure', 'severe pain'
  ];

  // Agent names
  static const String orchestrator = 'Orchestrator';
  static const String symptomAgent = 'Symptom Analyst';
  static const String emergencyAgent = 'Emergency Agent';
  static const String appointmentAgent = 'Appointment Agent';
  static const String reportAgent = 'Report Explainer';
  static const String navigationAgent = 'Navigation Agent';
}
