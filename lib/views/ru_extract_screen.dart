import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/ru_extract_vm.dart';
import '../models/ru_meal.dart';
import 'ru_statistics_screen.dart';

class RUExtractScreen extends StatefulWidget {
  const RUExtractScreen({super.key});

  @override
  State<RUExtractScreen> createState() => _RUExtractScreenState();
}

class _RUExtractScreenState extends State<RUExtractScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<RUExtractViewModel>(context, listen: false).loadMeals();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Extrato do RU'),
      ),
      body: Consumer<RUExtractViewModel>(
        builder: (context, vm, child) {
          if (vm.state == RULoadingState.loading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (vm.state == RULoadingState.error) {
            return Center(
                child: Text(vm.errorMessage ?? 'Erro ao carregar extrato'));
          }

          if (vm.meals.isEmpty) {
            return const Center(child: Text('Nenhuma refeição encontrada.'));
          }

          final keys = vm.groupedMeals.keys.toList();

          return Column(
            children: [
              _buildSummaryCard(vm),
              _buildFilterChips(vm),
              Expanded(
                child: RefreshIndicator(
                  onRefresh: () => vm.loadMeals(),
                  child: ListView.builder(
                    physics: const AlwaysScrollableScrollPhysics(),
                    itemCount: keys.length,
                    itemBuilder: (context, index) {
                      final monthKey = keys[index];
                      final meals = vm.groupedMeals[monthKey]!;

                      // Calcular totais do mês
                      double monthlySpent = 0;
                      double monthlySubsidy = 0;
                      for (var meal in meals) {
                        monthlySpent += meal.paidAmount;
                        monthlySubsidy += meal.subsidyAmount;
                      }

                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 8),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  monthKey,
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18,
                                      color: Colors.black87),
                                ),
                                const SizedBox(height: 4),
                                _buildMonthlySummary(
                                    meals.length, monthlySpent, monthlySubsidy),
                              ],
                            ),
                          ),
                          ...meals.map((meal) => _buildMealItem(meal)).toList(),
                          const Divider(),
                        ],
                      );
                    },
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildSummaryCard(RUExtractViewModel vm) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      // Adiciona sombra abaixo do recorte
      child: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: ClipPath(
          clipper: ReceiptClipper(),
          child: Container(
            color: Colors.amber[50],
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
              child: Column(
                children: [
                  Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: Colors.black12,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildSummaryItem(
                          'Gasto Total',
                          'R\$ ${vm.totalSpent.toStringAsFixed(2)}',
                          Colors.red),
                      _buildSummaryItem(
                          'Economia',
                          'R\$ ${vm.totalSubsidy.toStringAsFixed(2)}',
                          Colors.green),
                      _buildSummaryItem(
                          'Refeições', '${vm.totalMeals}', Colors.black),
                    ],
                  ),
                  const SizedBox(height: 16),
                  const Divider(
                      height: 1,
                      thickness: 1,
                      color: Colors.black12,
                      indent: 8,
                      endIndent: 8),
                  const SizedBox(height: 16),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const RUStatisticsScreen()),
                      );
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'VER ESTATÍSTICAS',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                            letterSpacing: 1.2,
                            color: Colors.grey[800],
                          ),
                        ),
                        const SizedBox(width: 4),
                        Icon(Icons.bar_chart,
                            size: 16, color: Colors.grey[800]),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFilterChips(RUExtractViewModel vm) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Row(
        children: [
          _buildChip(vm, 'Todos'),
          const SizedBox(width: 8),
          _buildChip(vm, 'Almoço'),
          const SizedBox(width: 8),
          _buildChip(vm, 'Jantar'),
        ],
      ),
    );
  }

  Widget _buildChip(RUExtractViewModel vm, String label) {
    final isSelected = vm.filterType == label;
    return FilterChip(
      label: Text(label),
      selected: isSelected,
      onSelected: (_) => vm.setFilter(label),
      backgroundColor: Colors.grey[200],
      selectedColor: Colors.amber[200],
      checkmarkColor: Colors.black,
      labelStyle: TextStyle(
        color: isSelected ? Colors.black : Colors.black87,
        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
      ),
    );
  }

  Widget _buildSummaryItem(String label, String value, Color color) {
    return Column(
      children: [
        Text(label, style: const TextStyle(fontSize: 12, color: Colors.grey)),
        const SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(
              fontSize: 16, fontWeight: FontWeight.bold, color: color),
        ),
      ],
    );
  }

  Widget _buildMonthlySummary(int count, double spent, double saved) {
    return Row(
      children: [
        _buildMonthlyStat('Refeições: $count'),
        const SizedBox(width: 12),
        _buildMonthlyStat('Gasto: R\$ ${spent.toStringAsFixed(2)}'),
        const SizedBox(width: 12),
        _buildMonthlyStat('Econ: R\$ ${saved.toStringAsFixed(2)}',
            color: Colors.green[700]),
      ],
    );
  }

  Widget _buildMonthlyStat(String text, {Color? color}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: (color ?? Colors.grey[600])!.withOpacity(0.1),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: color ?? Colors.grey[700],
        ),
      ),
    );
  }

  Widget _buildMealItem(RUMeal meal) {
    final isDinner = meal.type.toLowerCase().contains('jantar');
    final icon = isDinner ? Icons.nights_stay : Icons.wb_sunny;
    final color = isDinner ? Colors.indigo : Colors.orange;

    return ListTile(
      leading: CircleAvatar(
        backgroundColor: color.withOpacity(0.1),
        child: Icon(icon, color: color, size: 20),
      ),
      title: Text(meal.type),
      subtitle: Text('${meal.dateString} - ${meal.campus}'),
      trailing: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'R\$ ${meal.paidAmount.toStringAsFixed(2)}',
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
          ),
          if (meal.paidAmount == 0)
            const Text(
              'GRATUITO',
              style: TextStyle(
                  color: Colors.green,
                  fontSize: 10,
                  fontWeight: FontWeight.bold),
            ),
          if (meal.subsidyAmount > 0)
            Text(
              'Subsídio: R\$ ${meal.subsidyAmount.toStringAsFixed(2)}',
              style: TextStyle(color: Colors.green[700], fontSize: 11),
            ),
        ],
      ),
    );
  }
}

class ReceiptClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    const double radius = 16.0;

    // Top-left corner
    path.moveTo(0, radius);
    path.quadraticBezierTo(0, 0, radius, 0);

    // Top-right corner
    path.lineTo(size.width - radius, 0);
    path.quadraticBezierTo(size.width, 0, size.width, radius);

    // Right side down
    path.lineTo(size.width, size.height - 10);

    // Serrated bottom edge
    const int numberOfTeeth = 30;
    final double toothWidth = size.width / numberOfTeeth;
    const double toothHeight = 6.0;

    for (int i = 0; i < numberOfTeeth; i++) {
      double x = size.width - (i * toothWidth);
      path.lineTo(x - toothWidth / 2, size.height);
      path.lineTo(x - toothWidth, size.height - 10);
    }

    // Left side up
    path.lineTo(0, radius);

    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
