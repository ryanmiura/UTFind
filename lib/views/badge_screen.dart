import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:barcode_widget/barcode_widget.dart';
import '../viewmodels/student_vm.dart';

class BadgeScreen extends StatelessWidget {
  const BadgeScreen({Key? key}) : super(key: key);

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
          return Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 350,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20.0),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 15,
                          offset: const Offset(0, 5),
                        ),
                      ],
                    ),
                    clipBehavior: Clip.antiAlias,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Top orange bar with logo
                        Container(
                          width: double.infinity,
                          height: 100,
                          decoration: const BoxDecoration(
                            color: Color.fromRGBO(255, 123, 1, 1),
                          ),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 8),
                          child: Center(
                            child: Image.asset(
                              'assets/utflogo.png',
                              fit: BoxFit.contain,
                              height: 70,
                            ),
                          ),
                        ),
                        // Middle yellow section
                        Container(
                          width: double.infinity,
                          color: const Color.fromRGBO(255, 205, 0, 1),
                          padding: const EdgeInsets.symmetric(
                              vertical: 24, horizontal: 20),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Foto e RA
                              Expanded(
                                flex: 2,
                                child: Column(
                                  children: [
                                    Container(
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(12),
                                        border: Border.all(
                                          color: Colors.white,
                                          width: 3,
                                        ),
                                        boxShadow: [
                                          BoxShadow(
                                            color:
                                                Colors.black.withOpacity(0.1),
                                            blurRadius: 8,
                                            offset: const Offset(0, 3),
                                          ),
                                        ],
                                      ),
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(9),
                                        child: vm.hasPhoto
                                            ? Image.memory(
                                                vm.photoBytes!,
                                                width: 110,
                                                height: 145,
                                                fit: BoxFit.cover,
                                              )
                                            : Container(
                                                width: 110,
                                                height: 145,
                                                color: Colors.grey[200],
                                                child: Icon(Icons.person,
                                                    size: 60,
                                                    color: Colors.grey[400]),
                                              ),
                                      ),
                                    ),
                                    const SizedBox(height: 16),
                                    const Text(
                                      'RA',
                                      style: TextStyle(
                                        fontSize: 10,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.black54,
                                        letterSpacing: 1.2,
                                      ),
                                    ),
                                    Text(
                                      vm.studentRa,
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(width: 20),
                              // Dados do aluno
                              Expanded(
                                flex: 3,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    _buildInfoField('NOME', vm.studentName),
                                    const SizedBox(height: 12),
                                    _buildInfoField('CAMPUS', vm.campusName),
                                    const SizedBox(height: 12),
                                    _buildInfoField('CURSO',
                                        '${vm.primaryCourseType}\n${vm.primaryCourseName}'),
                                    const SizedBox(height: 12),
                                    _buildInfoField(
                                        'VALIDADE', vm.badgeValidity),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        // Barra inferior com código de barras
                        Container(
                          width: double.infinity,
                          decoration: const BoxDecoration(
                            color: Color.fromRGBO(255, 123, 1, 1),
                          ),
                          padding: const EdgeInsets.fromLTRB(30, 20, 30, 30),
                          child: Column(
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                padding: const EdgeInsets.all(8),
                                height: 70,
                                child: BarcodeWidget(
                                  barcode: Barcode.code39(),
                                  data: vm.formattedRaForBarcode,
                                  drawText: false,
                                  color: Colors.black,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                vm.formattedRaForBarcode,
                                style: const TextStyle(
                                  fontSize: 10,
                                  color: Colors.white,
                                  letterSpacing: 2,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
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
          );
        }
        if (vm.state == StudentLoadingState.initial) {
          return const Center(child: Text('Carregando dados...'));
        }
        return const Center(child: Text('Nenhum dado de estudante disponível'));
      },
    );
  }

  Widget _buildInfoField(String label, String value) {
    if (value.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 10,
            fontWeight: FontWeight.w600,
            color: Colors.grey,
            letterSpacing: 1.1,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          value,
          style: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
            height: 1.2,
          ),
          maxLines: 3,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }
}
