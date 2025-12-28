import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:utfind/viewmodels/student_vm.dart';
import 'package:utfind/views/badge_screen.dart';


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
            // selectedIcon: Icon(Icons.auto_stories),
            // icon: Icon(Icons.auto_stories_outlined),
            selectedIcon: Icon(Icons.book),
            icon: Icon(Icons.book_outlined),
            label: 'Curso',
          ),
          NavigationDestination(
            selectedIcon: Icon(Icons.calendar_month),
            icon: Icon(Icons.calendar_month_outlined),
            label: 'Horários',
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
            selectedIcon: Icon(Icons.fastfood),
            icon: Icon(Icons.fastfood_outlined),
            label: 'Cardápio',
          ),
        ],
      ),
      body: <Widget>[
        const Center(
          child: Text('Tela 1 Curso em andamento ...'),
        ),
        const Center(
          child: Text('Tela 2 Horarios em andamento ...'),
        ),
        const Center(
          child: Text('Tela 3 Inicio em andamento ...'),
        ),
        const BadgeScreen(),
        const Center(
          child: Text('Tela 5 Cardápio em andamento ...'),
        ),

      ][currentPageIndex],
    );
  }
}
