import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/student_vm.dart';
import 'badge_themes/classic_badge_theme.dart';
import 'badge_themes/professional_badge_theme.dart';
import 'badge_themes/modern_gradient_badge_theme.dart';
import 'badge_themes/neo_brutalism_badge_theme.dart';

class BadgeScreen extends StatefulWidget {
  const BadgeScreen({Key? key}) : super(key: key);

  @override
  State<BadgeScreen> createState() => _BadgeScreenState();
}

class _BadgeScreenState extends State<BadgeScreen> {
  String _selectedTheme = 'classic';

  @override
  Widget build(BuildContext context) {
    return Consumer<StudentViewModel>(
      builder: (context, vm, _) {
        if (vm.state == StudentLoadingState.loading) {
          return const Center(child: CircularProgressIndicator());
        }
        if (vm.state == StudentLoadingState.error) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline, size: 48, color: Colors.red),
                  const SizedBox(height: 16),
                  Text(
                    vm.errorMessage ?? 'Erro ao carregar dados do estudante',
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () => vm.loadAllData(),
                    child: const Text('Tentar Novamente'),
                  ),
                ],
              ),
            ),
          );
        }
        if (vm.state == StudentLoadingState.loaded && vm.student != null) {
          return Scaffold(
            appBar: AppBar(
              title: const Text('Meu Crachá'),
              actions: [
                PopupMenuButton<String>(
                  icon: const Icon(Icons.palette_outlined),
                  tooltip: 'Trocar tema',
                  onSelected: (String theme) {
                    setState(() {
                      _selectedTheme = theme;
                    });
                  },
                  itemBuilder: (context) => [
                    const PopupMenuItem(
                      value: 'classic',
                      child: Row(
                        children: [
                          Icon(Icons.style, size: 20),
                          SizedBox(width: 10),
                          Text('Tema Clássico'),
                        ],
                      ),
                    ),
                    const PopupMenuItem(
                      value: 'professional',
                      child: Row(
                        children: [
                          Icon(Icons.style_outlined, size: 20),
                          SizedBox(width: 10),
                          Text('Tema Professional'),
                        ],
                      ),
                    ),
                    const PopupMenuItem(
                      value: 'modern_gradient',
                      child: Row(
                        children: [
                          Icon(Icons.gradient, size: 20),
                          SizedBox(width: 10),
                          Text('Tema Gradient Wave'),
                        ],
                      ),
                    ),
                    const PopupMenuItem(
                      value: 'neo_brutalism',
                      child: Row(
                        children: [
                          Icon(Icons.layers, size: 20),
                          SizedBox(width: 10),
                          Text('Tema Neo Brutal'),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
            body: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (_selectedTheme == 'classic')
                      ClassicBadgeTheme(vm: vm)
                    else if (_selectedTheme == 'professional')
                      ProfessionalBadgeTheme(vm: vm)
                    else if (_selectedTheme == 'modern_gradient')
                      ModernGradientBadgeTheme(vm: vm)
                    else if (_selectedTheme == 'neo_brutalism')
                      NeoBrutalismBadgeTheme(vm: vm)
                    else
                      ClassicBadgeTheme(vm: vm), // Fallback
                    const SizedBox(height: 30),
                    const Text(
                      'Passe o crachá no leitor para acesso ao RU',
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 12,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }
        if (vm.state == StudentLoadingState.initial) {
          return const Center(child: Text('Carregando dados...'));
        }
        return const Center(child: Text('Nenhum dado de estudante disponível'));
      },
    );
  }
}