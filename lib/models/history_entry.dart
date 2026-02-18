class HistoryEntry {
  final String subjectName;
  final String grade;
  final String frequency;
  final String statusDescription;
  final int year;
  final int semester; // 1 or 2
  final int curriculumPeriod; // Período na grade (1º, 2º...)

  HistoryEntry({
    required this.subjectName,
    required this.grade,
    required this.frequency,
    required this.statusDescription,
    required this.year,
    required this.semester,
    required this.curriculumPeriod,
  });

  factory HistoryEntry.fromJson(Map<String, dynamic> json) {
    return HistoryEntry(
      subjectName: json['discNomeVc'] ?? '',
      grade: json['histnotanr']?.toString() ?? '-',
      frequency: json['histfreqnr']?.toString() ?? '-',
      statusDescription: json['siHiDescrVc'] ?? '',
      year: json['histanonr'] ?? 0,
      semester: json['histperanonr'] ?? 0,
      curriculumPeriod: json['digrPeriodoNr'] ?? 0,
    );
  }

  /// Retorna "2023/1"
  String get semesterLabel => '$year/$semester';

  /// Retorna se foi aprovado (lógica básica, pode precisar de refinamento)
  bool get isApproved {
    final status = statusDescription.toLowerCase();
    return status.contains('aprovado') || status.contains('dispensado');
  }

  double get gradeValue {
      if (grade == '-' || grade.isEmpty) return 0.0;
      try {
          return double.parse(grade.replaceAll(',', '.'));
      } catch (e) {
          return 0.0;
      }
  }

    double get frequencyValue {
      if (frequency == '-' || frequency.isEmpty) return 0.0;
      try {
          return double.parse(frequency.replaceAll(',', '.'));
      } catch (e) {
          return 0.0;
      }
  }
}
