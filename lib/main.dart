import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';
import 'package:utfind/viewmodels/student_vm.dart';
import 'package:utfind/viewmodels/history_vm.dart';
import 'package:utfind/viewmodels/curriculum_vm.dart';
import 'package:utfind/viewmodels/ru_extract_vm.dart';
import 'package:utfind/viewmodels/units_vm.dart';
import 'package:utfind/views/login_screen.dart';

Future<void> main() async {
  // Carrega o arquivo .env
  await dotenv.load(fileName: ".env");
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        // Provider global para dados do estudante
        ChangeNotifierProvider(create: (_) => StudentViewModel()),
        ChangeNotifierProvider(create: (_) => HistoryViewModel()),
        ChangeNotifierProvider(create: (_) => CurriculumViewModel()),
        ChangeNotifierProvider(create: (_) => RUExtractViewModel()),
        ChangeNotifierProvider(create: (_) => UnitsViewModel()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'UTFind',
        theme: ThemeData(
          //colorScheme: ColorScheme.fromSeed(seedColor: Colors.amber),
          //useMaterial3: true,
          primarySwatch: Colors.amber,
        ),
        home: const LoginScreen(),
      ),
    );
  }
}
