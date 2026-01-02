import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:barcode_widget/barcode_widget.dart';
import '../viewmodels/badge_vm.dart';
import '../models/badge.dart' as badge_model;

class BadgeScreen extends StatelessWidget {
  const BadgeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => BadgeViewModel()..fetchBadge(),
      child: Consumer<BadgeViewModel>(
        builder: (context, vm, _) {
          if (vm.state == BadgeState.loading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (vm.state == BadgeState.error) {
            return Center(child: Text(vm.error ?? 'Erro desconhecido'));
          }
          if (vm.state == BadgeState.loaded && vm.badge != null) {
            final badge = vm.badge!;
            final curso = badge.cursos.isNotEmpty ? badge.cursos.first : null;
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
                            child: Image.asset('assets/utf-logo.png'),
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
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      const SizedBox(height: 15),
                                      const Text('NOME'),
                                      Flexible(
                                        child: Text(
                                          badge.pessNomeVc,
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
                                          curso != null ? curso.unidNome : "",
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
                                                (curso != null
                                                    ? curso.tpCurDescrVc
                                                    : ""),
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
                                          curso != null ? curso.cursNomeVc : "",
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
                                          curso != null
                                              ? curso.validadeCracha
                                              : "",
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
                                    Image.asset('assets/photo.png'),
                                    Container(
                                      width: 10,
                                      height: 10,
                                    ),
                                    const Text('REGISTRO ACADEMICO'),
                                    Text(
                                      badge.login,
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
                              data: badge.formattedLoginForBarcode,
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
          return const SizedBox.shrink();
        },
      ),
    );
  }
}
