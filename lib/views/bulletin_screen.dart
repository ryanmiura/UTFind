import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:utfind/models/bulletin_model.dart';
import 'package:utfind/viewmodels/bulletin_vm.dart';

class BulletinScreen extends StatefulWidget {
  const BulletinScreen({super.key});

  @override
  State<BulletinScreen> createState() => _BulletinScreenState();
}

class _BulletinScreenState extends State<BulletinScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<BulletinViewModel>().fetchBulletin();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Desempenho Acadêmico'),
        elevation: 0,
      ),
      body: Consumer<BulletinViewModel>(
        builder: (context, vm, child) {
          if (vm.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (vm.error != null) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.error_outline, size: 48, color: Colors.red),
                    const SizedBox(height: 16),
                    Text(vm.error!, textAlign: TextAlign.center),
                    ElevatedButton(
                      onPressed: () => vm.fetchBulletin(),
                      child: const Text('Tentar Novamente'),
                    )
                  ],
                ),
              ),
            );
          }

          if (vm.subjects.isEmpty) {
            return const Center(child: Text('Nenhuma disciplina encontrada.'));
          }

          return ListView.builder(
            padding: const EdgeInsets.all(12),
            itemCount: vm.subjects.length,
            itemBuilder: (context, index) {
              return _SubjectCard(subject: vm.subjects[index]);
            },
          );
        },
      ),
    );
  }
}

class _SubjectCard extends StatelessWidget {
  final BulletinSubject subject;

  const _SubjectCard({required this.subject});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ExpansionTile(
        title: Text(
          subject.name,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text('Turma: ${subject.classCode} • ${subject.status}'),
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Divider(),
                _buildFrequencySection(context),
                const SizedBox(height: 16),
                _buildGradesSection(context),
                const SizedBox(height: 16),
                _buildClassComparison(context),
                const SizedBox(height: 8),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFrequencySection(BuildContext context) {
    final rate = subject.attendanceRate;
    final color = subject.isFailedByAbsence 
        ? Colors.red 
        : (subject.isNearAbsenceLimit ? Colors.orange : Colors.green);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text('Frequência', style: TextStyle(fontWeight: FontWeight.w600)),
            Text('${(rate * 100).toStringAsFixed(0)}%', 
                style: TextStyle(color: color, fontWeight: FontWeight.bold)),
          ],
        ),
        const SizedBox(height: 8),
        LinearProgressIndicator(
          value: rate,
          backgroundColor: Colors.grey[200],
          color: color,
          minHeight: 8,
          borderRadius: BorderRadius.circular(4),
        ),
        const SizedBox(height: 4),
        Text(
          'Faltas: ${subject.absences} / Aulas: ${subject.classesHeld}' + 
          (subject.classesPlanned != null ? ' (Previstas: ${subject.classesPlanned})' : ''),
          style: TextStyle(fontSize: 12, color: Colors.grey[600]),
        ),
        if (subject.isNearAbsenceLimit)
          const Padding(
            padding: EdgeInsets.only(top: 4.0),
            child: Text('⚠️ Atenção: Limite de faltas próximo!', 
                style: TextStyle(fontSize: 11, color: Colors.orange, fontWeight: FontWeight.w500)),
          ),
        _buildRemainingAbsencesBadge(),
      ],
    );
  }

  Widget _buildRemainingAbsencesBadge() {
    final remaining = subject.remainingAbsences;
    if (remaining == null) return const SizedBox.shrink();

    final isCritical = remaining <= 2;
    final color = isCritical ? Colors.red[700] : Colors.blue[700];
    final bgColor = isCritical ? Colors.red[50] : Colors.blue[50];

    return Container(
      margin: const EdgeInsets.only(top: 12),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color!.withOpacity(0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.info_outline, size: 16, color: color),
          const SizedBox(width: 8),
          Text(
            remaining > 0 
                ? 'Você ainda pode faltar $remaining vez${remaining > 1 ? 'es' : ''}'
                : 'Você não pode mais faltar!',
            style: TextStyle(
              color: color,
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGradesSection(BuildContext context) {
    if (subject.avaliacoes.isEmpty) {
      return const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Notas', style: TextStyle(fontWeight: FontWeight.w600)),
          SizedBox(height: 8),
          Text('Nenhuma avaliação lançada até o momento.', 
              style: TextStyle(fontStyle: FontStyle.italic, color: Colors.grey)),
        ],
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Notas', style: TextStyle(fontWeight: FontWeight.w600)),
        const SizedBox(height: 8),
        ...subject.avaliacoes.map((e) => Padding(
          padding: const EdgeInsets.only(bottom: 4.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(child: Text(e.description, style: const TextStyle(fontSize: 13))),
              Text(
                e.numericGrade != null ? e.numericGrade!.toStringAsFixed(1) : '-',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ],
          ),
        )),
      ],
    );
  }

  Widget _buildClassComparison(BuildContext context) {
    final avg = subject.classAverage;
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.blue.withOpacity(0.05),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text('Média da Turma', style: TextStyle(fontSize: 12)),
          Text(
            avg != null ? avg.toStringAsFixed(1) : 'N/A',
            style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
          ),
        ],
      ),
    );
  }
}
