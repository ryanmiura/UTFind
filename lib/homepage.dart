import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:utfind/viewmodels/student_vm.dart';
import 'package:utfind/views/badge_screen.dart';
import 'package:utfind/views/academic_screen.dart';
import 'package:utfind/views/units_screen.dart';
import 'package:utfind/views/ru_extract_screen.dart';


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
        const UnitsScreen(),
        const Center(
          child: Text('Bem-vindo ao UTFind!'),
        ),
        const BadgeScreen(),
        const RUExtractScreen(),
      ][currentPageIndex],
    );
  }
}
