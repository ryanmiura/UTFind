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
    final now = DateTime.now();
    final currentTimeStr =
        "${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}";

    // Verifica se a aula está acontecendo agora
    bool isNow = !c.isAsynchronous &&
        currentTimeStr.compareTo(c.startTime) >= 0 &&
        currentTimeStr.compareTo(c.endTime) <= 0;

    // Define cor baseada no turno ou status
    Color accentColor = isNow ? Colors.amber : Colors.blueAccent;
    if (hasConflict) accentColor = Colors.red;

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
        border: isNow 
            ? Border.all(color: Colors.amber, width: 2) 
            : (hasConflict ? Border.all(color: Colors.red, width: 1) : null),
      ),
      child: IntrinsicHeight(
        child: Row(
          children: [
            // Barra lateral colorida (Timeline feel)
            Container(
              width: 6,
              decoration: BoxDecoration(
                color: accentColor,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(16),
                  bottomLeft: Radius.circular(16),
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        if (!c.isAsynchronous)
                          Text(
                            '${c.startTime} — ${c.endTime}',
                            style: TextStyle(
                              color: accentColor,
                              fontWeight: FontWeight.bold,
                              fontSize: 13,
                            ),
                          ),
                        if (isNow)
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 2),
                            decoration: BoxDecoration(
                              color: Colors.amber,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Text(
                              'AGORA',
                              style: TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black87),
                            ),
                          ),
                        if (c.isAsynchronous)
                          const Text(
                            'ASSÍNCRONA',
                            style: TextStyle(
                              color: Colors.grey,
                              fontWeight: FontWeight.bold,
                              fontSize: 11,
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      c.className,
                      style: const TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w700,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Wrap(
                      spacing: 16,
                      runSpacing: 8,
                      children: [
                        _buildInfoItem(Icons.location_on_outlined, c.room),
                        _buildInfoItem(Icons.person_outline, c.teacher),
                      ],
                    ),
                    if (hasConflict)
                      Padding(
                        padding: const EdgeInsets.only(top: 12),
                        child: Row(
                          children: const [
                            Icon(Icons.warning_amber_rounded,
                                color: Colors.red, size: 16),
                            SizedBox(width: 4),
                            Text(
                              'Conflito detectado',
                              style: TextStyle(
                                  color: Colors.red,
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoItem(IconData icon, String text) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 16, color: Colors.grey[600]),
        const SizedBox(width: 4),
        Flexible(
          child: Text(
            text,
            style: TextStyle(color: Colors.grey[700], fontSize: 13),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}
