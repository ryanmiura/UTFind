enum DayOfWeek { seg, ter, qua, qui, sex, sab, dom }

class ScheduleClass {
  final String turmIdVc;
  final String discCodVelhoVc;
  final String discNomeVc;
  final String turmCodVc;
  final List<ClassTimeDetail> horarios;
  final List<String> professores;

  ScheduleClass({
    required this.turmIdVc,
    required this.discCodVelhoVc,
    required this.discNomeVc,
    required this.turmCodVc,
    required this.horarios,
    required this.professores,
  });

  bool get isAsynchronous => horarios.isEmpty;

  factory ScheduleClass.fromJson(Map<String, dynamic> json) {
    var rawHorarios = json['horarios'] as List? ?? [];
    
    // Flatten schedules: each schedule in JSON might have a list of times
    List<ClassTimeDetail> parsedHorarios = [];
    for (var h in rawHorarios) {
      parsedHorarios.add(ClassTimeDetail.fromRaw(h));
    }

    var rawProfs = json['professores'] as List? ?? [];
    var parsedProfs = rawProfs.map<String>((p) => p['pessNomeVc'] as String).toList();

    return ScheduleClass(
      turmIdVc: json['turmIdVc'] ?? '',
      discCodVelhoVc: json['discCodVelhoVc'] ?? '',
      discNomeVc: json['discNomeVc'] ?? '',
      turmCodVc: json['turmCodVc'] ?? '',
      horarios: parsedHorarios,
      professores: parsedProfs,
    );
  }
}

class ClassTimeDetail {
  final String rawCode; // e.g. "3N4"
  final String ambiente; // e.g. "P204"
  final DayOfWeek day;
  final String startTime;
  final String endTime;

  ClassTimeDetail({
    required this.rawCode,
    required this.ambiente,
    required this.day,
    required this.startTime,
    required this.endTime,
  });

  factory ClassTimeDetail.fromRaw(Map<String, dynamic> json) {
    String code = json['horaDescrVc'] ?? '';
    String room = json['ambienteNomeVc'] ?? 'Sem sala';
    
    // Default values
    DayOfWeek day = DayOfWeek.seg;
    String start = "00:00";
    String end = "00:00";

    if (code.isNotEmpty) {
      // 1=DOM, 2=SEG, 3=TER, 4=QUA, 5=QUI, 6=SEX, 7=SAB
      int? dayNum = int.tryParse(code[0]);
      if (dayNum != null) {
        day = _getDayFromNum(dayNum);
        
        if (code.length >= 3) {
           String shift = code[1]; // M, T, N
           int? period = int.tryParse(code.substring(2));
           if (period != null) {
              var times = _getTimeRange(shift, period);
              start = times[0];
              end = times[1];
           }
        }
      }
    }

    return ClassTimeDetail(
      rawCode: code,
      ambiente: room,
      day: day,
      startTime: start,
      endTime: end,
    );
  }

  static DayOfWeek _getDayFromNum(int n) {
    switch (n) {
      case 1: return DayOfWeek.dom;
      case 2: return DayOfWeek.seg;
      case 3: return DayOfWeek.ter;
      case 4: return DayOfWeek.qua;
      case 5: return DayOfWeek.qui;
      case 6: return DayOfWeek.sex;
      case 7: return DayOfWeek.sab;
      default: return DayOfWeek.seg;
    }
  }

  static List<String> _getTimeRange(String shift, int period) {
    if (shift == 'M') {
      switch (period) {
        case 1: return ["07:30", "08:20"];
        case 2: return ["08:20", "09:10"];
        case 3: return ["09:10", "10:00"];
        case 4: return ["10:20", "11:10"];
        case 5: return ["11:10", "12:00"];
        case 6: return ["12:00", "12:50"];
      }
    } else if (shift == 'T') {
      switch (period) {
        case 1: return ["13:00", "13:50"];
        case 2: return ["13:50", "14:40"];
        case 3: return ["14:40", "15:30"];
        case 4: return ["15:50", "16:40"];
        case 5: return ["16:40", "17:30"];
        case 6: return ["17:50", "18:40"];
      }
    } else if (shift == 'N') {
      switch (period) {
        case 1: return ["18:40", "19:30"];
        case 2: return ["19:30", "20:20"];
        case 3: return ["20:20", "21:10"];
        case 4: return ["21:20", "22:10"];
        case 5: return ["22:10", "23:00"];
      }
    }
    return ["00:00", "00:00"];
  }
}
