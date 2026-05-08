enum LabStatus { high, low, normal, watch }

class LabResult {
  final String testName;
  final String value;
  final String unit;
  final String normalRange;
  final LabStatus status;
  final String explanation;

  const LabResult({
    required this.testName,
    required this.value,
    required this.unit,
    required this.normalRange,
    required this.status,
    required this.explanation,
  });

  String get statusLabel {
    switch (status) {
      case LabStatus.high:   return 'HIGH';
      case LabStatus.low:    return 'LOW';
      case LabStatus.normal: return 'NORMAL';
      case LabStatus.watch:  return 'WATCH';
    }
  }
}

// Mock lab data
class MockLabResults {
  static const List<LabResult> results = [
    LabResult(
      testName: 'Hemoglobin',
      value: '14.2', unit: 'g/dL', normalRange: '13.5–17.5',
      status: LabStatus.normal,
      explanation: 'Healthy level. No action needed.',
    ),
    LabResult(
      testName: 'Blood Glucose (Fasting)',
      value: '138', unit: 'mg/dL', normalRange: '70–99',
      status: LabStatus.high,
      explanation: 'Elevated. Indicates possible pre-diabetes.',
    ),
    LabResult(
      testName: 'HbA1c',
      value: '7.2', unit: '%', normalRange: '< 5.7',
      status: LabStatus.high,
      explanation: 'Above target. Consult endocrinologist.',
    ),
    LabResult(
      testName: 'Cholesterol (LDL)',
      value: '142', unit: 'mg/dL', normalRange: '< 130',
      status: LabStatus.watch,
      explanation: 'Borderline high. Monitor diet.',
    ),
    LabResult(
      testName: 'WBC Count',
      value: '7.1', unit: '×10³/μL', normalRange: '4.5–11.0',
      status: LabStatus.normal,
      explanation: 'Normal immune function.',
    ),
  ];
}
