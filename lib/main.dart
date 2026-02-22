import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';
import 'package:utfind/viewmodels/student_vm.dart';
import 'package:utfind/viewmodels/history_vm.dart';
import 'package:utfind/viewmodels/curriculum_vm.dart';
import 'package:utfind/viewmodels/ru_extract_vm.dart';
import 'package:utfind/viewmodels/units_vm.dart';
import 'package:utfind/views/login_screen.dart';
import 'package:utfind/homepage.dart';
import 'package:utfind/viewmodels/login_vm.dart';

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
        home: const AuthWrapper(),
      ),
    );
  }
}

/// Wrapper que avalia se existem credenciais e tenta o login automático.
class AuthWrapper extends StatefulWidget {
  const AuthWrapper({super.key});

  @override
  State<AuthWrapper> createState() => _AuthWrapperState();
}

class _AuthWrapperState extends State<AuthWrapper> {
  late Future<bool> _loginFuture;

  @override
  void initState() {
    super.initState();
    // Instancia o LoginViewModel pontualmente apenas para tentar o login
    final loginVM = LoginViewModel();
    _loginFuture = loginVM.tryAutomaticLogin();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
      future: _loginFuture,
      builder: (context, snapshot) {
        // Exibe loader enquanto a verificação é feita
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }

        // Se o login automático retornou true, vai para HomePage
        if (snapshot.hasData && snapshot.data == true) {
          return const HomePage();
        }

        // Se retornou false ou ocorreu erro, vai para LoginScreen
        return const LoginScreen();
      },
    );
  }
}
