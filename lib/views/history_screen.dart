import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/history_vm.dart';
import '../models/history_entry.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<HistoryViewModel>(context, listen: false).loadHistory();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Histórico Escolar'),
      ),
      body: Consumer<HistoryViewModel>(
        builder: (context, vm, child) {
          if (vm.state == HistoryLoadingState.loading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (vm.state == HistoryLoadingState.error) {
            return Center(child: Text(vm.errorMessage ?? 'Erro ao carregar histórico'));
          }

          if (vm.history.isEmpty) {
            return const Center(child: Text('Nenhum histórico encontrado.'));
          }

          final keys = vm.groupedHistory.keys.toList();
          keys.sort((a, b) => b.compareTo(a)); // Ordenação decrescente de semestres (2025/1 -> 2022/1)

          return ListView.builder(
            itemCount: keys.length,
            itemBuilder: (context, index) {
              final semester = keys[index];
              final entries = vm.groupedHistory[semester]!;
              
              return ExpansionTile(
                title: Text(
                  semester,
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                ),
                initiallyExpanded: index == 0, // Primeiro expandido por padrão
                children: entries.map((entry) => _buildHistoryItem(entry)).toList(),
              );
            },
          );
        },
      ),
    );
  }

  Widget _buildHistoryItem(HistoryEntry entry) {
    Color statusColor = Colors.grey;
    IconData statusIcon = Icons.help_outline;

    final status = entry.statusDescription.toLowerCase();
    if (status.contains('aprovado') || status.contains('dispensado')) {
      statusColor = Colors.green;
      statusIcon = Icons.check_circle;
    } else if (status.contains('reprovado')) {
      statusColor = Colors.red;
      statusIcon = Icons.cancel;
    } else if (status.contains('matriculado') || status.contains('cursando')) {
      statusColor = Colors.blue;
      statusIcon = Icons.school;
    }

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: ListTile(
        leading: Icon(statusIcon, color: statusColor),
        title: Text(entry.subjectName, style: const TextStyle(fontWeight: FontWeight.w500)),
        subtitle: Text(entry.statusDescription),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            if (entry.grade != '-') 
              Text(
                'Nota: ${entry.grade}',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            if (entry.frequency != '-')
              Text(
                'Freq: ${entry.frequency}%',
                style: const TextStyle(fontSize: 12),
              ),
          ],
        ),
      ),
    );
  }
}
