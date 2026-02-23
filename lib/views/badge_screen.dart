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
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    alignment: Alignment.center,
                    transformAlignment: Alignment.center,
                    child: Column(
                      children: [
                        // Top orange bar with logo
                        Container(
                          width: 350,
                          height: 100,
                          decoration: const BoxDecoration(
                            color: Color.fromRGBO(255, 123, 1, 1),
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(20.0),
                              topRight: Radius.circular(20.0),
                            ),
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
                          width: 350,
                          height: 300,
                          color: const Color.fromRGBO(255, 205, 0, 1),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              // Dados do aluno
                              Container(
                                width: 150,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    const SizedBox(height: 15),
                                    const Text('NOME'),
                                    Flexible(
                                      child: Text(
                                        vm.studentName,
                                        style: const TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold,
                                        ),
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 2,
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    const Text('CAMPUS'),
                                    Flexible(
                                      child: Text(
                                        vm.campusName,
                                        style: const TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold,
                                        ),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    Flexible(
                                      child: Row(
                                        children: [
                                          const Text('CURSO '),
                                          Expanded(
                                            child: Text(
                                              vm.primaryCourseType,
                                              style: const TextStyle(
                                                fontSize: 14,
                                                fontWeight: FontWeight.bold,
                                              ),
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Flexible(
                                      child: Text(
                                        vm.primaryCourseName,
                                        style: const TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold,
                                        ),
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 2,
                                      ),
                                    ),
                                    const SizedBox(height: 15),
                                    const Text('VALIDADE'),
                                    Flexible(
                                      child: Text(
                                        vm.badgeValidity,
                                        style: const TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold,
                                        ),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              // Foto e RA
                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  vm.hasPhoto
                                      ? Image.memory(
                                          vm.photoBytes!,
                                          width: 100,
                                          height: 130,
                                          fit: BoxFit.cover,
                                        )
                                      : Container(
                                          width: 100,
                                          height: 130,
                                          color: Colors.grey[300],
                                          child: const Icon(Icons.person,
                                              size: 50, color: Colors.grey),
                                        ),
                                  const SizedBox(height: 10),
                                  const Text('REGISTRO ACADÊMICO'),
                                  Text(
                                    vm.studentRa,
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        // Barra inferior com código de barras
                        Container(
                          width: 350,
                          height: 120,
                          decoration: const BoxDecoration(
                            color: Color.fromRGBO(255, 123, 1, 1),
                            borderRadius: BorderRadius.only(
                              bottomLeft: Radius.circular(20.0),
                              bottomRight: Radius.circular(20.0),
                            ),
                          ),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 20),
                          child: BarcodeWidget(
                            barcode: Barcode.code39(),
                            data: vm.formattedRaForBarcode,
                            drawText: false,
                            color: Colors.black,
                            backgroundColor: Colors.white,
                          ),
                        ),
                      ],
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
}
