import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:utfind/models/schedule_class.dart';
import 'package:utfind/viewmodels/schedule_viewmodel.dart';

class ScheduleScreen extends StatefulWidget {
  const ScheduleScreen({super.key});

  @override
  State<ScheduleScreen> createState() => _ScheduleScreenState();
}

class _ScheduleScreenState extends State<ScheduleScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ScheduleViewModel>().fetchSchedule();
    });
  }

  @override
  Widget build(BuildContext context) {
    // Calcula o index inicial baseado no dia da semana (SEG=0, ..., SAB=5, EAD=6)
    int initialIndex = DateTime.now().weekday - 1;
    if (initialIndex < 0 || initialIndex > 5) initialIndex = 6; 

    return DefaultTabController(
      length: 7, // SEG, TER, QUA, QUI, SEX, SAB, EAD
      initialIndex: initialIndex,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Horários'),
          bottom: const TabBar(
            isScrollable: false,
            labelPadding: EdgeInsets.zero,
            indicatorSize: TabBarIndicatorSize.label,
            tabs: [
              Tab(child: Text('SEG', style: TextStyle(fontSize: 11))),
              Tab(child: Text('TER', style: TextStyle(fontSize: 11))),
              Tab(child: Text('QUA', style: TextStyle(fontSize: 11))),
              Tab(child: Text('QUI', style: TextStyle(fontSize: 11))),
              Tab(child: Text('SEX', style: TextStyle(fontSize: 11))),
              Tab(child: Text('SÁB', style: TextStyle(fontSize: 11))),
              Tab(child: Text('EAD', style: TextStyle(fontSize: 11))),
            ],
          ),
        ),
        body: Consumer<ScheduleViewModel>(
          builder: (context, vm, child) {
            if (vm.isLoading) {
              return const Center(child: CircularProgressIndicator());
            }
            if (vm.error != null) {
              return Center(child: Text('Erro: ${vm.error}'));
            }

            return TabBarView(
              children: [
                _buildDayList(vm, DayOfWeek.seg),
                _buildDayList(vm, DayOfWeek.ter),
                _buildDayList(vm, DayOfWeek.qua),
                _buildDayList(vm, DayOfWeek.qui),
                _buildDayList(vm, DayOfWeek.sex),
                _buildDayList(vm, DayOfWeek.sab),
                _buildAsynchronousList(vm),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildEmptyState(String message) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.event_note, size: 64, color: Colors.grey.withOpacity(0.3)),
          const SizedBox(height: 16),
          Text(
            message,
            style: const TextStyle(color: Colors.grey, fontSize: 16),
          ),
        ],
      ),
    );
  }

  Widget _buildDayList(ScheduleViewModel vm, DayOfWeek day) {
    final classes = vm.getClassesForDay(day);
    if (classes.isEmpty) {
      return _buildEmptyState('Nenhuma aula para este dia.');
    } // ... existing code ...

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: classes.length,
      itemBuilder: (context, index) {
        final c = classes[index];
        bool hasConflict = false;
        if (index > 0) {
          // simple check: if current starts before previous ends
          final prev = classes[index - 1];
          if (c.startTime.compareTo(prev.endTime) < 0) {
            hasConflict = true;
          }
        }

        return _buildClassCard(c, hasConflict);
      },
    );
  }

  Widget _buildAsynchronousList(ScheduleViewModel vm) {
    final classes = vm.getAsynchronousClasses();
    if (classes.isEmpty) {
      return _buildEmptyState('Nenhuma disciplina assíncrona.');
    } // ... existing code ...

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: classes.length,
      itemBuilder: (context, index) => _buildClassCard(classes[index], false),
    );
  }

  Widget _buildClassCard(DisplayClass c, bool hasConflict) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: hasConflict 
          ? const BorderSide(color: Colors.red, width: 2) 
          : BorderSide.none,
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (hasConflict)
              const Padding(
                padding: EdgeInsets.only(bottom: 8.0),
                child: Row(
                  children: [
                    Icon(Icons.warning, color: Colors.red, size: 16),
                    SizedBox(width: 4),
                    Text('Conflito de horário!', style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    c.className,
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
                if (!c.isAsynchronous)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.blue.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      '${c.startTime} - ${c.endTime}',
                      style: const TextStyle(color: Colors.blue, fontWeight: FontWeight.bold),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                const Icon(Icons.location_on, size: 16, color: Colors.grey),
                const SizedBox(width: 4),
                Text(c.room, style: const TextStyle(color: Colors.black54)),
              ],
            ),
            const SizedBox(height: 4),
            Row(
              children: [
                const Icon(Icons.person, size: 16, color: Colors.grey),
                const SizedBox(width: 4),
                Expanded(
                  child: Text(
                    c.teacher,
                    style: const TextStyle(color: Colors.black54),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
