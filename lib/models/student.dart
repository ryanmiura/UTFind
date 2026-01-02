import '../constants/unit_constants.dart';

/// Modelo que representa os dados de um curso do estudante

class Course {
  final String id;
  final String abbreviation;
  final int campusCode;
  final int courseCode;
  final String? lastModification;
  final String name;
  final int typeCode;
  final String typeDescription;
  final int statusCode;
  final String statusDescription;
  final int enrollmentYear;
  final int enrollmentPeriod;
  final int category;
  final int educationLevelCode;
  final String educationLevel;
  final int order;
  final int isFreshman;
  final String? graduationDate;
  final int currentPeriod;
  final int degreeCode;
  final String degreeDescription;
  final double coefficient;
  final String shift;
  final String badgeValidity;
  final int currentYear;
  final int currentAcademicPeriod;

  Course({
    required this.id,
    required this.abbreviation,
    required this.campusCode,
    required this.courseCode,
    this.lastModification,
    required this.name,
    required this.typeCode,
    required this.typeDescription,
    required this.statusCode,
    required this.statusDescription,
    required this.enrollmentYear,
    required this.enrollmentPeriod,
    required this.category,
    required this.educationLevelCode,
    required this.educationLevel,
    required this.order,
    required this.isFreshman,
    this.graduationDate,
    required this.currentPeriod,
    required this.degreeCode,
    required this.degreeDescription,
    required this.coefficient,
    required this.shift,
    required this.badgeValidity,
    required this.currentYear,
    required this.currentAcademicPeriod,
  });

  factory Course.fromJson(Map<String, dynamic> json) {
    return Course(
      id: json['alCuIdVc'] ?? '',
      abbreviation: json['cursAbrevVc'] ?? '',
      campusCode: json['unidCodNr'] ?? 0,
      courseCode: json['cursCodNr'] ?? 0,
      lastModification: json['ultimaModificacao'],
      name: json['cursNomeVc'] ?? '',
      typeCode: json['tpCurCodNr'] ?? 0,
      typeDescription: json['tpCurDescrVc'] ?? '',
      statusCode: json['sitpCodNr'] ?? 0,
      statusDescription: json['sitpDescrVc'] ?? '',
      enrollmentYear: json['alCuAnoingNr'] ?? 0,
      enrollmentPeriod: json['alCuPerAnoingNr'] ?? 0,
      category: json['alCuCategpgNr'] ?? 0,
      educationLevelCode: json['nivEnsCursoCodNr'] ?? 0,
      educationLevel: json['nivEnsDescrVc'] ?? '',
      order: json['alCuOrdemNr'] ?? 0,
      isFreshman: json['alCuCalouroNr'] ?? 0,
      graduationDate: json['alCuColacaoDt'],
      currentPeriod: json['alCuPeriodoNr'] ?? 0,
      degreeCode: json['gradCodNr'] ?? 0,
      degreeDescription: json['gradDescrVc'] ?? '',
      coefficient: _parseDouble(json['alCuCoefNr']),
      shift: json['alCuTurnoCh'] ?? '',
      badgeValidity: json['validadeCracha'] ?? '',
      currentYear: json['anoVigente'] ?? 0,
      currentAcademicPeriod: json['periodoVigente'] ?? 0,
    );
  }

  String get campusName => unitMapping[campusCode] ?? 'Desconhecido';

  /// Helper method para converter valores para double
  static double _parseDouble(dynamic value) {
    if (value is double) return value;
    if (value is int) return value.toDouble();
    if (value != null) {
      return double.tryParse(value.toString()) ?? 0.0;
    }
    return 0.0;
  }

  Map<String, dynamic> toJson() {
    return {
      'alCuIdVc': id,
      'cursAbrevVc': abbreviation,
      'unidCodNr': campusCode,
      'cursCodNr': courseCode,
      'ultimaModificacao': lastModification,
      'cursNomeVc': name,
      'tpCurCodNr': typeCode,
      'tpCurDescrVc': typeDescription,
      'sitpCodNr': statusCode,
      'sitpDescrVc': statusDescription,
      'alCuAnoingNr': enrollmentYear,
      'alCuPerAnoingNr': enrollmentPeriod,
      'alCuCategpgNr': category,
      'nivEnsCursoCodNr': educationLevelCode,
      'nivEnsDescrVc': educationLevel,
      'alCuOrdemNr': order,
      'alCuCalouroNr': isFreshman,
      'alCuColacaoDt': graduationDate,
      'alCuPeriodoNr': currentPeriod,
      'gradCodNr': degreeCode,
      'gradDescrVc': degreeDescription,
      'alCuCoefNr': coefficient,
      'alCuTurnoCh': shift,
      'validadeCracha': badgeValidity,
      'anoVigente': currentYear,
      'periodoVigente': currentAcademicPeriod,
    };
  }
}

/// Modelo que representa os dados completos de um estudante
class Student {
  final String name;
  final String alternativeEmail;
  final String personalEmail;
  final String institutionalEmail;
  final int maritalStatusCode;
  final String maritalStatusDescription;
  final String ra; // Registro Acadêmico
  final int enrollmentBlockStatus;
  final String nationality;
  final String motherName;
  final int birthDate;
  final String fatherName;
  final String gender;
  final int blockTypeCode;
  final String blockTypeDescription;
  final int passportStatus;
  final List<Course> courses;

  Student({
    required this.name,
    required this.alternativeEmail,
    required this.personalEmail,
    required this.institutionalEmail,
    required this.maritalStatusCode,
    required this.maritalStatusDescription,
    required this.ra,
    required this.enrollmentBlockStatus,
    required this.nationality,
    required this.motherName,
    required this.birthDate,
    required this.fatherName,
    required this.gender,
    required this.blockTypeCode,
    required this.blockTypeDescription,
    required this.passportStatus,
    required this.courses,
  });

  factory Student.fromJson(Map<String, dynamic> json) {
    return Student(
      name: json['pessNomeVc'] ?? '',
      alternativeEmail: json['alunEmailAlternVc'] ?? '',
      personalEmail: json['alunemail'] ?? '',
      institutionalEmail: json['emInstAluemailVc'] ?? '',
      maritalStatusCode: json['estCivCodNr'] ?? 0,
      maritalStatusDescription: json['estCivDescrVc'] ?? '',
      ra: json['login'] ?? '',
      enrollmentBlockStatus: json['matrbloqstatusNr'] ?? 0,
      nationality: json['paisNacioVc'] ?? '',
      motherName: json['pessMaeVc'] ?? '',
      birthDate: json['pessNascDt'] ?? 0,
      fatherName: json['pessPaiVc'] ?? '',
      gender: json['pessSexoCh'] ?? '',
      blockTypeCode: json['tpBloqCodNr'] ?? 0,
      blockTypeDescription: json['tpBloqDescrVc'] ?? '',
      passportStatus: json['situacaoPassaporte'] ?? 0,
      courses: (json['cursos'] as List<dynamic>? ?? [])
          .map((e) => Course.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'pessNomeVc': name,
      'alunEmailAlternVc': alternativeEmail,
      'alunemail': personalEmail,
      'emInstAluemailVc': institutionalEmail,
      'estCivCodNr': maritalStatusCode,
      'estCivDescrVc': maritalStatusDescription,
      'login': ra,
      'matrbloqstatusNr': enrollmentBlockStatus,
      'paisNacioVc': nationality,
      'pessMaeVc': motherName,
      'pessNascDt': birthDate,
      'pessPaiVc': fatherName,
      'pessSexoCh': gender,
      'tpBloqCodNr': blockTypeCode,
      'tpBloqDescrVc': blockTypeDescription,
      'situacaoPassaporte': passportStatus,
      'cursos': courses.map((e) => e.toJson()).toList(),
    };
  }

  /// Retorna o curso principal (primeiro da lista, geralmente)
  Course? get primaryCourse => courses.isNotEmpty ? courses.first : null;

  /// Verifica se o estudante tem matrícula ativa
  bool get hasActiveEnrollment => enrollmentBlockStatus == 0;

  /// Retorna o nome do curso principal
  String get primaryCourseName => primaryCourse?.name ?? '';

  /// Retorna a abreviação do curso principal
  String get primaryCourseAbbreviation => primaryCourse?.abbreviation ?? '';

  /// Retorna o tipo do curso principal (ex: Bacharelado)
  String get primaryCourseType => primaryCourse?.typeDescription ?? '';

  /// Retorna a validade do crachá
  String get badgeValidity => primaryCourse?.badgeValidity ?? '';

  /// Retorna o período atual do estudante
  int get currentPeriod => primaryCourse?.currentPeriod ?? 0;

  /// Retorna o coeficiente acadêmico
  double get academicCoefficient => primaryCourse?.coefficient ?? 0.0;

  /// Retorna o nome do campus principal
  String get campusName => primaryCourse?.campusName ?? 'Desconhecido';

  /// Retorna o RA formatado para o código de barras (converte 'a' inicial para '0')
  String get formattedRaForBarcode {
    if (ra.startsWith('a')) {
      return '0${ra.substring(1)}';
    }
    return ra;
  }
}
