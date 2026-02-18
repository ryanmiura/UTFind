class RUMeal {
  final String type;
  final double paidAmount;
  final double subsidyAmount;
  final String campus;
  final String dateString;
  final DateTime date;

  RUMeal({
    required this.type,
    required this.paidAmount,
    required this.subsidyAmount,
    required this.campus,
    required this.dateString,
    required this.date,
  });

  factory RUMeal.fromJson(Map<String, dynamic> json) {
    return RUMeal(
      type: json['tipo'] ?? 'Desconhecido',
      paidAmount: (json['valorPago'] as num?)?.toDouble() ?? 0.0,
      subsidyAmount: (json['valorSubsidio'] as num?)?.toDouble() ?? 0.0,
      campus: json['campus'] ?? '',
      dateString: json['data'] ?? '',
      date: _parseDate(json['data'] ?? ''),
    );
  }

  static DateTime _parseDate(String dateStr) {
    // Formato esperado: "dd/MM/yyyy HH:mm"
    try {
      if (dateStr.isEmpty) return DateTime.now();
      final parts = dateStr.split(' ');
      if (parts.length != 2) return DateTime.now();

      final dateParts = parts[0].split('/');
      final timeParts = parts[1].split(':');

      if (dateParts.length != 3 || timeParts.length < 2) return DateTime.now();

      return DateTime(
        int.parse(dateParts[2]),
        int.parse(dateParts[1]),
        int.parse(dateParts[0]),
        int.parse(timeParts[0]),
        int.parse(timeParts[1]),
      );
    } catch (e) {
      return DateTime.now();
    }
  }
}
