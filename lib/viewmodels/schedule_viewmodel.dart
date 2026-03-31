import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:utfind/models/schedule_class.dart';
import 'package:utfind/services/api_service.dart';

class ScheduleViewModel extends ChangeNotifier {
  final ApiService _apiService = ApiService();

  List<ScheduleClass> _allClasses = [];
  bool _isLoading = false;
  String? _error;

  List<ScheduleClass> get allClasses => _allClasses;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> fetchSchedule() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final response = await _apiService.getSchedule();
      if (response.data is List) {
        _allClasses = (response.data as List)
            .map((json) => ScheduleClass.fromJson(json))
            .toList();
      }
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Returns classes that have set schedules for a specific day
  List<DisplayClass> getClassesForDay(DayOfWeek day) {
    List<DisplayClass> displayClasses = [];
    
    for (var scheduleClass in _allClasses) {
      for (var time in scheduleClass.horarios) {
        if (time.day == day) {
          displayClasses.add(DisplayClass(
            className: scheduleClass.discNomeVc,
            room: time.ambiente,
            startTime: time.startTime,
            endTime: time.endTime,
            teacher: scheduleClass.professores.isNotEmpty 
                ? scheduleClass.professores.join(", ") 
                : "Não informado",
            isAsynchronous: false,
            color: _generateColorForClass(scheduleClass.discNomeVc),
          ));
        }
      }
    }

    // Sort by start time
    displayClasses.sort((a, b) => a.startTime.compareTo(b.startTime));

    // Merge consecutive classes if they touch exactly (no breaks) and are the same class
    return _mergeConsecutiveClasses(displayClasses);
  }

  List<DisplayClass> _mergeConsecutiveClasses(List<DisplayClass> classes) {
    if (classes.isEmpty) return [];

    List<DisplayClass> merged = [classes.first];

    for (int i = 1; i < classes.length; i++) {
      var current = classes[i];
      var previous = merged.last;

      // Check if same class, same room, same teacher
      if (current.className == previous.className &&
          current.room == previous.room &&
          current.teacher == previous.teacher &&
          current.startTime == previous.endTime) {
        // They touch exactly, merge them
        merged[merged.length - 1] = DisplayClass(
          className: previous.className,
          room: previous.room,
          startTime: previous.startTime,
          endTime: current.endTime,
          teacher: previous.teacher,
          isAsynchronous: previous.isAsynchronous,
          color: previous.color,
        );
      } else {
        merged.add(current);
      }
    }

    return merged;
  }


  List<DisplayClass> getAsynchronousClasses() {
    return _allClasses
        .where((c) => c.isAsynchronous)
        .map((c) => DisplayClass(
              className: c.discNomeVc,
              room: "EAD / Assíncrona",
              startTime: "--:--",
              endTime: "--:--",
              teacher: c.professores.isNotEmpty 
                  ? c.professores.join(", ") 
                  : "Não informado",
              isAsynchronous: true,
              color: _generateColorForClass(c.discNomeVc),
            ))
        .toList();
  }

  Color _generateColorForClass(String name) {
    final List<Color> palette = [
      Colors.blueAccent,
      Colors.greenAccent[700]!,
      Colors.deepPurpleAccent,
      Colors.orangeAccent[700]!,
      Colors.pinkAccent,
      Colors.teal,
      Colors.indigoAccent,
      Colors.cyan[700]!,
    ];

    int hash = 0;
    for (var i = 0; i < name.length; i++) {
        hash = name.codeUnitAt(i) + ((hash << 5) - hash);
    }

    return palette[hash.abs() % palette.length];
  }

  DisplayClass? getNextClass() {
    final now = DateTime.now();
    final dayOfWeek = _getNowDayOfWeek(now.weekday);
    final currentTimeStr = "${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}";

    final todayClasses = getClassesForDay(dayOfWeek);
    
    for (var c in todayClasses) {
      if (c.startTime.compareTo(currentTimeStr) > 0) {
        return c;
      }
    }
    return null;
  }

  DayOfWeek _getNowDayOfWeek(int weekday) {
    switch (weekday) {
      case DateTime.monday: return DayOfWeek.seg;
      case DateTime.tuesday: return DayOfWeek.ter;
      case DateTime.wednesday: return DayOfWeek.qua;
      case DateTime.thursday: return DayOfWeek.qui;
      case DateTime.friday: return DayOfWeek.sex;
      case DateTime.saturday: return DayOfWeek.sab;
      case DateTime.sunday: return DayOfWeek.dom;
      default: return DayOfWeek.seg;
    }
  }
}

// Flat structure for easy UI rendering
class DisplayClass {
  final String className;
  final String room;
  final String startTime;
  final String endTime;
  final String teacher;
  final bool isAsynchronous;
  final Color color;

  DisplayClass({
    required this.className,
    required this.room,
    required this.startTime,
    required this.endTime,
    required this.teacher,
    required this.isAsynchronous,
    required this.color,
  });
}
