import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:utfind/viewmodels/student_vm.dart';
import 'package:utfind/viewmodels/schedule_viewmodel.dart';
import 'package:utfind/views/badge_screen.dart';
import 'package:utfind/views/academic_screen.dart';
import 'package:utfind/views/units_screen.dart';
import 'package:utfind/views/ru_extract_screen.dart';
import 'package:utfind/views/schedule_screen.dart';


class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int currentPageIndex = 3;

  @override
  void initState() {
    super.initState();
    // Agenda o carregamento dos dados do estudante para o próximo frame
    // Isso permite que a tela seja construída primeiro, depois carrega os dados
    Future.microtask(() {
      if (mounted) {
        context.read<StudentViewModel>().loadAllData();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: NavigationBar(
        onDestinationSelected: (int index) {
          setState(() {
            currentPageIndex = index;
          });
        },
        selectedIndex: currentPageIndex,
        destinations: const <Widget>[
          NavigationDestination(
            selectedIcon: Icon(Icons.school),
            icon: Icon(Icons.school_outlined),
            label: 'Acadêmico',
          ),
          NavigationDestination(
            selectedIcon: Icon(Icons.calendar_month),
            icon: Icon(Icons.calendar_month_outlined),
            label: 'Agenda',
          ),
          NavigationDestination(
            selectedIcon: Icon(Icons.location_on),
            icon: Icon(Icons.location_on_outlined),
            label: 'Câmpus',
          ),
          NavigationDestination(
            selectedIcon: Icon(Icons.home),
            icon: Icon(Icons.home_outlined),
            label: 'Início',
          ),
          NavigationDestination(
            selectedIcon: Icon(Icons.assignment_ind),
            icon: Icon(Icons.assignment_ind_outlined),
            label: 'Crachá',
          ),
          NavigationDestination(
            selectedIcon: Icon(Icons.restaurant),
            icon: Icon(Icons.restaurant_outlined),
            label: 'RU',
          ),
        ],
      ),
      body: <Widget>[
        const AcademicScreen(),
        const ScheduleScreen(),
        const UnitsScreen(),
        _buildHomeContent(),
        const BadgeScreen(),
        const RUExtractScreen(),
      ][currentPageIndex],
    );
  }

  Widget _buildHomeContent() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 48),
          const Text(
            'Bem-vindo ao UTFind!',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 24),
          _buildNextClassWidget(),
        ],
      ),
    );
  }

  Widget _buildNextClassWidget() {
    return Consumer<ScheduleViewModel>(
      builder: (context, vm, child) {
        if (vm.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }
        
        final next = vm.getNextClass();
        if (next == null) {
          return const Card(
            child: ListTile(
              leading: Icon(Icons.event_available, color: Colors.green),
              title: Text('Nenhuma aula restante hoje'),
              subtitle: Text('Aproveite seu tempo livre!'),
            ),
          );
        }

        return Card(
          child: ListTile(
            leading: const Icon(Icons.upcoming, color: Colors.orange),
            title: const Text('Próxima Aula'),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(next.className, style: const TextStyle(fontWeight: FontWeight.bold)),
                Text('${next.startTime} - ${next.room}'),
              ],
            ),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {
              setState(() {
                currentPageIndex = 1; // Go to Schedule
              });
            },
          ),
        );
      },
    );
  }
}
