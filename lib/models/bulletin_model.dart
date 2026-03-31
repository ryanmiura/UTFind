class Evaluation {
  final String description;
  final dynamic nota;

  Evaluation({
    required this.description,
    this.nota,
  });

  double? get numericGrade {
    if (nota == null) return null;
    if (nota is num) return nota.toDouble();
    if (nota is String) return double.tryParse(nota.replaceAll(',', '.'));
    return null;
  }

  factory Evaluation.fromJson(Map<String, dynamic> json) {
    return Evaluation(
      description: json['tpAvDescrVc'] ?? '',
      nota: json['nota'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'tpAvDescrVc': description,
      'nota': nota,
    };
  }
}

class BulletinSubject {
  final String name;
  final String classCode;
  final int absences;
  final int classesHeld;
  final int? classesPlanned;
  final String status;
  final dynamic classAverageRaw;
  final List<Evaluation> avaliacoes;

  BulletinSubject({
    required this.name,
    required this.classCode,
    required this.absences,
    required this.classesHeld,
    this.classesPlanned,
    required this.status,
    this.classAverageRaw,
    required this.avaliacoes,
  });

  double get attendanceRate {
    if (classesHeld <= 0) return 1.0;
    return 1.0 - (absences / classesHeld);
  }

  double? get classAverage {
    if (classAverageRaw == null) return null;
    if (classAverageRaw is num) return classAverageRaw.toDouble();
    if (classAverageRaw is String) return double.tryParse(classAverageRaw.replaceAll(',', '.'));
    return null;
  }

  bool get isNearAbsenceLimit {
    return attendanceRate < 0.80 && attendanceRate >= 0.75;
  }

  bool get isFailedByAbsence {
    return attendanceRate < 0.75;
  }

  int? get maxAbsencesAllowed {
    if (classesPlanned == null || classesPlanned! <= 0) return null;
    // UTFPR exige 75% de presença, logo 25% de faltas permitidas
    return (classesPlanned! * 0.25).floor();
  }

  int? get remainingAbsences {
    final max = maxAbsencesAllowed;
    if (max == null) return null;
    final remaining = max - absences;
    return remaining < 0 ? 0 : remaining;
  }

  double? get studentAverage {
    if (avaliacoes.isEmpty) return null;
    final grades = avaliacoes
        .map((e) => e.numericGrade)
        .whereType<double>()
        .toList();
    if (grades.isEmpty) return null;
    return grades.reduce((a, b) => a + b) / grades.length;
  }

  factory BulletinSubject.fromJson(Map<String, dynamic> json) {
    var list = json['avaliacoes'] as List? ?? [];
    List<Evaluation> evals = list.map((i) => Evaluation.fromJson(i)).toList();

    return BulletinSubject(
      name: json['discNomeVc'] ?? '',
      classCode: json['turmCodVc'] ?? '',
      absences: json['faltas'] ?? 0,
      classesHeld: json['aulasDadas'] ?? 0,
      classesPlanned: json['aulasPrevistas'],
      status: json['siHiDescrVc'] ?? '',
      classAverageRaw: json['mediaNotaTurma'],
      avaliacoes: evals,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'discNomeVc': name,
      'turmCodVc': classCode,
      'faltas': absences,
      'aulasDadas': classesHeld,
      'aulasPrevistas': classesPlanned,
      'siHiDescrVc': status,
      'mediaNotaTurma': classAverageRaw,
      'avaliacoes': avaliacoes.map((e) => e.toJson()).toList(),
    };
  }
}
