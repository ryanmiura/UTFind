import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/ru_extract_vm.dart';
import 'dart:math';

class RUStatisticsScreen extends StatelessWidget {
  const RUStatisticsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Estatísticas do RU'),
      ),
      body: Consumer<RUExtractViewModel>(
        builder: (context, vm, child) {
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildDistributionCard(vm),
                const SizedBox(height: 24),
                _buildMealsTrendChart(vm),
                const SizedBox(height: 24),
                _buildSpendingChart(vm),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildDistributionCard(RUExtractViewModel vm) {
    double lunchPercent = 0;
    double dinnerPercent = 0;
    if (vm.totalMeals > 0) {
      lunchPercent = vm.lunchCount / vm.totalMeals;
      dinnerPercent = vm.dinnerCount / vm.totalMeals;
    }

    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Distribuição de Refeições',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: SizedBox(
                height: 24,
                child: Row(
                  children: [
                    Expanded(
                        flex: (lunchPercent * 100).toInt(),
                        child: Container(color: Colors.orange)),
                    Expanded(
                        flex: (dinnerPercent * 100).toInt(),
                        child: Container(color: Colors.indigo)),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildLegendItem('Almoço', '${(lunchPercent * 100).toStringAsFixed(0)}%', Colors.orange),
                _buildLegendItem('Jantar', '${(dinnerPercent * 100).toStringAsFixed(0)}%', Colors.indigo),
              ],
            ),
            const SizedBox(height: 8),
            Text('Total: ${vm.totalMeals} refeições', style: const TextStyle(color: Colors.grey)),
          ],
        ),
      ),
    );
  }

  Widget _buildLegendItem(String label, String percent, Color color) {
    return Row(
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 8),
        Text(
          '$label ($percent)',
          style: TextStyle(color: color, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }

  Widget _buildMealsTrendChart(RUExtractViewModel vm) {
    // Processar dados para o gráfico (últimos 6 meses)
    final grouped = vm.groupedMeals;
    final keys = grouped.keys.toList(); // Já devem estar ordenados decrescente
    
    // Pegar os últimos 6 meses
    final recentKeys = keys.take(6).toList().reversed.toList();

    if (recentKeys.isEmpty) return const SizedBox.shrink();

    // Encontrar o valor máximo de refeições para escala
    int maxMeals = 0;
    for (var key in recentKeys) {
      if (grouped[key]!.length > maxMeals) maxMeals = grouped[key]!.length;
    }

    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Tendência de Refeições (Últimos 6 meses)',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 24),
            SizedBox(
              height: 200,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: recentKeys.map((key) {
                  final meals = grouped[key]!;
                  int lunchCount = 0;
                  int dinnerCount = 0;
                  for (var m in meals) {
                    if (m.type.toLowerCase().contains('almoço')) {
                      lunchCount++;
                    } else {
                      dinnerCount++;
                    }
                  }
                  
                  final totalHeight = 150.0; // Altura máxima da barra
                  final lunchHeight = maxMeals > 0 ? (lunchCount / maxMeals) * totalHeight : 0.0;
                  final dinnerHeight = maxMeals > 0 ? (dinnerCount / maxMeals) * totalHeight : 0.0;
                  
                  // Extrair apenas o mês (ex: "Setembro/2023" -> "Set")
                  final monthShort = key.split('/').first.substring(0, 3);

                  return Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                        '${lunchCount + dinnerCount}',
                        style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 4),
                      Container(
                        width: 30,
                        decoration: const BoxDecoration(
                          borderRadius: BorderRadius.vertical(top: Radius.circular(4)),
                        ),
                        child: Column(
                          children: [
                            Container(
                              height: dinnerHeight,
                              width: 30,
                              decoration: const BoxDecoration(
                                color: Colors.indigo,
                                borderRadius: BorderRadius.vertical(top: Radius.circular(4)),
                              ),
                            ),
                            Container(
                              height: lunchHeight,
                              width: 30,
                              color: Colors.orange,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(monthShort, style: const TextStyle(fontSize: 12)),
                    ],
                  );
                }).toList(),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildLegendItem('Almoço', '', Colors.orange),
                const SizedBox(width: 16),
                _buildLegendItem('Jantar', '', Colors.indigo),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSpendingChart(RUExtractViewModel vm) {
    // Processar dados para o gráfico (últimos 6 meses)
    final grouped = vm.groupedMeals;
    final keys = grouped.keys.toList(); 
    
    // Pegar os últimos 6 meses
    final recentKeys = keys.take(6).toList().reversed.toList();

    if (recentKeys.isEmpty) return const SizedBox.shrink();

    // Encontrar o valor máximo para escala (Soma de Pago + Subsídio)
    double maxTotal = 0;
    for (var key in recentKeys) {
      double total = 0;
      for (var meal in grouped[key]!) {
        total += meal.paidAmount + meal.subsidyAmount;
      }
      if (total > maxTotal) maxTotal = total;
    }

    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Tendência de Gastos (Últimos 6 meses)',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 24),
            SizedBox(
              height: 250, // Increased height to prevent overflow
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: recentKeys.map((key) {
                  final meals = grouped[key]!;
                  double paid = 0;
                  double subsidy = 0;
                  for (var m in meals) {
                    paid += m.paidAmount;
                    subsidy += m.subsidyAmount;
                  }
                  
                  final totalHeight = 150.0;
                  final paidHeight = maxTotal > 0 ? (paid / maxTotal) * totalHeight : 0.0;
                  final subsidyHeight = maxTotal > 0 ? (subsidy / maxTotal) * totalHeight : 0.0;
                  
                  // Extrair apenas o mês
                  final monthShort = key.split('/').first.substring(0, 3);

                  return Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                        'R\$${subsidy.toInt()}',
                        style: const TextStyle(fontSize: 9, fontWeight: FontWeight.bold, color: Colors.green),
                      ),
                      Text(
                        'R\$${paid.toInt()}',
                        style: TextStyle(fontSize: 9, fontWeight: FontWeight.bold, color: Colors.red[400]),
                      ),
                      const SizedBox(height: 4),
                      Container(
                        width: 30,
                        decoration: const BoxDecoration(
                          borderRadius: BorderRadius.vertical(top: Radius.circular(4)),
                        ),
                        child: Column(
                          children: [
                            Container(
                              height: subsidyHeight,
                              width: 30,
                              decoration: const BoxDecoration(
                                color: Colors.green,
                                borderRadius: BorderRadius.vertical(top: Radius.circular(4)),
                              ),
                            ),
                            Container(
                              height: paidHeight,
                              width: 30,
                              color: Colors.red[400],
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(monthShort, style: const TextStyle(fontSize: 12)),
                    ],
                  );
                }).toList(),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildLegendItem('Subsídio', '', Colors.green),
                const SizedBox(width: 16),
                _buildLegendItem('Pago', '', Colors.red[400]!),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
