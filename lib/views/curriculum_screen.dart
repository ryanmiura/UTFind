import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/curriculum_vm.dart';
import '../models/curriculum_subject.dart';

class CurriculumScreen extends StatefulWidget {
  const CurriculumScreen({super.key});

  @override
  State<CurriculumScreen> createState() => _CurriculumScreenState();
}

class _CurriculumScreenState extends State<CurriculumScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<CurriculumViewModel>(context, listen: false).loadCurriculum();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Matriz Curricular'),
      ),
      body: Consumer<CurriculumViewModel>(
        builder: (context, vm, child) {
          if (vm.state == CurriculumLoadingState.loading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (vm.state == CurriculumLoadingState.error) {
            return Center(
                child: Text(vm.errorMessage ?? 'Erro ao carregar matriz'));
          }

          if (vm.curriculum.isEmpty) {
            return const Center(child: Text('Nenhuma disciplina encontrada.'));
          }

          final keys = vm.groupedCurriculum.keys.toList();
          keys.sort();

          return Column(
            children: [
              _buildProgressCard(vm),
              Expanded(
                child: RefreshIndicator(
                  onRefresh: () => vm.loadCurriculum(),
                  child: ListView.builder(
                    physics: const AlwaysScrollableScrollPhysics(),
                    itemCount: keys.length,
                    itemBuilder: (context, index) {
                      final period = keys[index];
                      final subjects = vm.groupedCurriculum[period]!;

                      return ExpansionTile(
                        title: Text(
                          '${period}º Período',
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        children: subjects
                            .map((subj) => _buildSubjectItem(subj))
                            .toList(),
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

  Widget _buildProgressCard(CurriculumViewModel vm) {
    final progress = vm.progress;
    final percent = (progress * 100).toStringAsFixed(1);

    return Card(
      margin: const EdgeInsets.all(16),
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Progresso do Curso',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            LinearProgressIndicator(
              value: progress,
              minHeight: 10,
              backgroundColor: Colors.grey[300],
              color: Colors.green,
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '$percent% Concluído',
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
                Text(
                  '${vm.completedHours} / ${vm.totalHours} Horas',
                  style: const TextStyle(color: Colors.grey),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSubjectItem(CurriculumSubject subject) {
    return ListTile(
      leading: Icon(
        subject.isCompleted ? Icons.check_circle : Icons.circle_outlined,
        color: subject.isCompleted ? Colors.green : Colors.grey,
      ),
      title: Text(
        subject.name,
        style: TextStyle(
          decoration: subject.isCompleted ? TextDecoration.lineThrough : null,
          color: subject.isCompleted ? Colors.grey : null,
        ),
      ),
      subtitle: Text('${subject.totalHours}h'),
      trailing: subject.prerequisites.isNotEmpty
          ? Tooltip(
              message: 'Pré-requisitos: ${subject.prerequisites.join(", ")}',
              child: const Icon(Icons.info_outline, size: 20),
            )
          : null,
    );
  }
}
