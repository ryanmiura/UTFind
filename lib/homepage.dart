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
          const SizedBox(height: 16),
          _buildQuickActions(),
        ],
      ),
    );
  }

  Widget _buildQuickActions() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Acesso Rápido',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),
        Card(
          elevation: 2,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: ListTile(
            leading: const CircleAvatar(
              backgroundColor: Colors.blueAccent,
              child: Icon(Icons.assessment, color: Colors.white),
            ),
            title: const Text('Boletim e Frequência'),
            subtitle: const Text('Acompanhe suas notas e faltas'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => Navigator.pushNamed(context, '/bulletin'),
          ),
        ),
      ],
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
            elevation: 2,
            child: ListTile(
              leading: Icon(Icons.event_available, color: Colors.green),
              title: Text('Nenhuma aula restante hoje'),
              subtitle: Text('Aproveite seu tempo livre!'),
            ),
          );
        }

        final timeRemaining = vm.getTimeUntilNextClass(next);

        return Card(
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
            side: BorderSide(color: next.color.withOpacity(0.3), width: 1),
          ),
          child: ListTile(
            contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            leading: CircleAvatar(
              backgroundColor: next.color.withOpacity(0.2),
              child: Icon(Icons.school, color: next.color),
            ),
            title: Row(
              children: [
                const Text(
                  'Próxima Aula',
                  style: TextStyle(
                    fontSize: 14, 
                    fontWeight: FontWeight.bold,
                    color: Colors.grey,
                  ),
                ),
                if (timeRemaining.isNotEmpty) ...[
                  const SizedBox(width: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    decoration: BoxDecoration(
                      color: Colors.orange.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      timeRemaining,
                      style: const TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        color: Colors.orange,
                      ),
                    ),
                  ),
                ],
              ],
            ),
            subtitle: Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    next.className,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Icon(Icons.access_time, size: 14, color: Colors.grey[600]),
                      const SizedBox(width: 4),
                      Text(
                        '${next.startTime} às ${next.endTime}',
                        style: TextStyle(color: Colors.grey[700]),
                      ),
                      const SizedBox(width: 12),
                      Icon(Icons.location_on_outlined, size: 14, color: Colors.grey[600]),
                      const SizedBox(width: 4),
                      Text(
                        next.room,
                        style: TextStyle(color: Colors.grey[700]),
                      ),
                    ],
                  ),
                ],
              ),
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
