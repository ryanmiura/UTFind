import 'package:flutter/material.dart';
import 'history_screen.dart';
import 'curriculum_screen.dart';

class AcademicScreen extends StatelessWidget {
  const AcademicScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Acadêmico'),
          bottom: const TabBar(
            tabs: [
              Tab(text: 'Histórico', icon: Icon(Icons.history_edu)),
              Tab(text: 'Matriz', icon: Icon(Icons.table_chart)),
            ],
          ),
        ),
        body: const TabBarView(
          children: [
            HistoryScreen(),
            CurriculumScreen(),
          ],
        ),
      ),
    );
  }
}
