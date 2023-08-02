import 'package:flutter/material.dart';
import 'package:utfind/cracha.dart';


class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int currentPageIndex = 0;

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
            selectedIcon: Icon(Icons.assignment_ind),
            icon: Icon(Icons.assignment_ind_outlined),
            label: 'Cardápio',
          ),
        ],
      ),
      body: <Widget>[
        Container(
          color: Colors.red,
          alignment: Alignment.center,
          child: const Text('Tela 1 Curso em andamento ...'),
        ),
        Container(
          color: Colors.green,
          alignment: Alignment.center,
          child: const Text('Tela 2 Horarios em andamento ...'),
        ),
        Container(
          color: Colors.blue,
          alignment: Alignment.center,
          child: const Text('Tela 3 Inicio em andamento ...'),
        ),
        Cracha(),
        Container(
          color: Colors.amber,
          alignment: Alignment.center,
          child: const Text('Tela 5 Cardápio em andamento ...'),
        ),

      ][currentPageIndex],
    );
  }
}
