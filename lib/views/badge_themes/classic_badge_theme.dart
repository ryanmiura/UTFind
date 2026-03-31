import 'package:flutter/material.dart';
import 'package:barcode_widget/barcode_widget.dart';
import '../../viewmodels/student_vm.dart';

class ClassicBadgeTheme extends StatelessWidget {
  final StudentViewModel vm;

  const ClassicBadgeTheme({Key? key, required this.vm}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
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
          // Top orange bar
          Container(
            width: double.infinity,
            height: 100,
            color: const Color.fromRGBO(255, 123, 1, 1),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
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
            padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 20),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: 2,
                  child: Column(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.white, width: 3),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 8,
                              offset: const Offset(0, 3),
                            ),
                          ],
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(9),
                          child: vm.hasPhoto
                              ? Image.memory(vm.photoBytes!,
                                  width: 110, height: 145, fit: BoxFit.cover)
                              : Container(
                                  width: 110,
                                  height: 145,
                                  color: Colors.grey[200],
                                  child: Icon(Icons.person,
                                      size: 60, color: Colors.grey[400]),
                                ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      const Text('RA',
                          style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w600,
                              color: Colors.black54,
                              letterSpacing: 1.2)),
                      Text(vm.studentRa,
                          style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.black)),
                    ],
                  ),
                ),
                const SizedBox(width: 20),
                Expanded(
                  flex: 3,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _infoField('NOME', vm.studentName),
                      const SizedBox(height: 12),
                      _infoField('CAMPUS', vm.campusName),
                      const SizedBox(height: 12),
                      _infoField('CURSO',
                          '${vm.primaryCourseType}\n${vm.primaryCourseName}'),
                      const SizedBox(height: 12),
                      _infoField('VALIDADE', vm.badgeValidity),
                    ],
                  ),
                ),
              ],
            ),
          ),
          // Bottom orange bar
          Container(
            width: double.infinity,
            color: const Color.fromRGBO(255, 123, 1, 1),
            padding: const EdgeInsets.fromLTRB(30, 20, 30, 30),
            child: Column(
              children: [
                Container(
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8)),
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
                Text(vm.formattedRaForBarcode,
                    style: const TextStyle(
                        fontSize: 10,
                        color: Colors.white,
                        letterSpacing: 2,
                        fontWeight: FontWeight.bold)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _infoField(String label, String value) {
    if (value.isEmpty) return const SizedBox.shrink();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: const TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w600,
                color: Colors.black54,
                letterSpacing: 1.1)),
        const SizedBox(height: 2),
        Text(value,
            style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.bold,
                color: Colors.black,
                height: 1.2),
            maxLines: 3,
            overflow: TextOverflow.ellipsis),
      ],
    );
  }
}
