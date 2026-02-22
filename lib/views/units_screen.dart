import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/units_vm.dart';
import '../models/campus_unit.dart';

class UnitsScreen extends StatefulWidget {
  const UnitsScreen({super.key});

  @override
  State<UnitsScreen> createState() => _UnitsScreenState();
}

class _UnitsScreenState extends State<UnitsScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<UnitsViewModel>(context, listen: false).loadUnits();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Câmpus da UTFPR'),
      ),
      body: Consumer<UnitsViewModel>(
        builder: (context, vm, child) {
          if (vm.state == UnitsLoadingState.loading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (vm.state == UnitsLoadingState.error) {
            return Center(
                child: Text(vm.errorMessage ?? 'Erro ao carregar unidades'));
          }

          if (vm.units.isEmpty) {
            return const Center(child: Text('Nenhuma unidade encontrada.'));
          }

          return RefreshIndicator(
            onRefresh: () => vm.loadUnits(),
            child: ListView.builder(
              physics: const AlwaysScrollableScrollPhysics(),
              itemCount: vm.units.length,
              itemBuilder: (context, index) {
                return _buildUnitCard(vm.units[index]);
              },
            ),
          );
        },
      ),
    );
  }

  Widget _buildUnitCard(CampusUnit unit) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              unit.name,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                const Icon(Icons.location_on, size: 16, color: Colors.grey),
                const SizedBox(width: 8),
                Expanded(child: Text(unit.address)),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                const Icon(Icons.phone, size: 16, color: Colors.grey),
                const SizedBox(width: 8),
                Text(unit.phone.isEmpty ? 'Sem telefone' : unit.phone),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton.icon(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Ligar para ${unit.phone}')),
                    );
                  },
                  icon: const Icon(Icons.phone),
                  label: const Text('Ligar'),
                ),
                const SizedBox(width: 8),
                FilledButton.icon(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                          content:
                              Text('Abrir mapa: ${unit.lat}, ${unit.long}')),
                    );
                  },
                  icon: const Icon(Icons.map),
                  label: const Text('Mapa'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
