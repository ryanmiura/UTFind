class CurriculumSubject {
  final String name;
  final int period;
  final int totalHours;
  final List<String> prerequisites; // Lista de nomes ou códigos? O JSON mostra objetos
  final bool isCompleted; // Será calculado cruzando com histórico

  CurriculumSubject({
    required this.name,
    required this.period,
    required this.totalHours,
    required this.prerequisites,
    this.isCompleted = false,
  });

  factory CurriculumSubject.fromJson(Map<String, dynamic> json) {
    final prereqs = (json['preRequisito'] as List<dynamic>? ?? [])
        .map((e) => e['discNomeVc'] as String? ?? '')
        .where((e) => e.isNotEmpty)
        .toList();

    return CurriculumSubject(
      name: json['discNomeVc'] ?? '',
      period: json['digrperiodoNr'] ?? 0,
      totalHours: json['cargaHoraria']?['total'] ?? 0,
      prerequisites: List<String>.from(prereqs),
    );
  }

  CurriculumSubject copyWith({bool? isCompleted}) {
    return CurriculumSubject(
      name: name,
      period: period,
      totalHours: totalHours,
      prerequisites: prerequisites,
      isCompleted: isCompleted ?? this.isCompleted,
    );
  }
}
