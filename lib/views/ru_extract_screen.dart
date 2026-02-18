import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/ru_extract_vm.dart';
import '../models/ru_meal.dart';

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
            return Center(child: Text(vm.errorMessage ?? 'Erro ao carregar extrato'));
          }

          if (vm.meals.isEmpty) {
            return const Center(child: Text('Nenhuma refeição encontrada.'));
          }

          final keys = vm.groupedMeals.keys.toList();
          // Ordenar chaves: precisa converter "Janeiro/2023" para data para ordenar corretamente
          // Como já ordenamos a lista original por data decrescente, e iteramos nela para agrupar,
          // as chaves devem estar na ordem de inserção (se Map preservar ordem, o que Map padrão faz em Dart).
          // Mas para garantir, podemos confiar na ordem de inserção do LinkedHashMap padrão.
          
          return Column(
            children: [
              _buildSummaryCard(vm),
              Expanded(
                child: ListView.builder(
                  itemCount: keys.length,
                  itemBuilder: (context, index) {
                    final monthKey = keys[index];
                    final meals = vm.groupedMeals[monthKey]!;
                    
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          child: Text(
                            monthKey,
                            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.grey),
                          ),
                        ),
                        ...meals.map((meal) => _buildMealItem(meal)).toList(),
                        const Divider(),
                      ],
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildSummaryCard(RUExtractViewModel vm) {
    return Card(
      margin: const EdgeInsets.all(16),
      elevation: 4,
      color: Colors.amber[50],
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildSummaryItem('Gasto Total', 'R\$ ${vm.totalSpent.toStringAsFixed(2)}', Colors.red),
            _buildSummaryItem('Economia', 'R\$ ${vm.totalSubsidy.toStringAsFixed(2)}', Colors.green),
            _buildSummaryItem('Refeições', '${vm.totalMeals}', Colors.black),
          ],
        ),
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
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: color),
        ),
      ],
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
              style: TextStyle(color: Colors.green, fontSize: 10, fontWeight: FontWeight.bold),
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
