import 'package:flutter/material.dart';
import 'package:barcode_widget/barcode_widget.dart';
import '../../viewmodels/student_vm.dart';

class NeoBrutalismBadgeTheme extends StatelessWidget {
  final StudentViewModel vm;

  const NeoBrutalismBadgeTheme({Key? key, required this.vm}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 350,
      decoration: BoxDecoration(
        color: const Color(0xFFFFF1CC),
        borderRadius: BorderRadius.zero,
        border: Border.all(color: Colors.black, width: 4),
        boxShadow: const [
          BoxShadow(
            color: Colors.black,
            offset: Offset(8, 8),
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            padding: const EdgeInsets.fromLTRB(14, 10, 14, 10),
            decoration: const BoxDecoration(
              color: Color(0xFFFF7A00),
              border: Border(bottom: BorderSide(color: Colors.black, width: 4)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  decoration: BoxDecoration(
                    color: const Color(0xFF38E1FF),
                    border: Border.all(color: Colors.black, width: 2),
                  ),
                  child: const Text(
                    'UTFPR',
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.w900,
                      fontSize: 12,
                      letterSpacing: 1,
                    ),
                  ),
                ),
                Expanded(
                  child: Center(
                    child: Image.asset(
                      'assets/utflogo.png',
                      fit: BoxFit.contain,
                      height: 34,
                    ),
                  ),
                ),
                const Icon(Icons.bolt_rounded, color: Colors.black, size: 25),
              ],
            ),
          ),

          Padding(
            padding: const EdgeInsets.fromLTRB(14, 14, 14, 12),
            child: Column(
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 98,
                      height: 122,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(color: Colors.black, width: 3),
                        boxShadow: const [
                          BoxShadow(
                            color: Colors.black,
                            offset: Offset(4, 4),
                          )
                        ],
                      ),
                      child: vm.hasPhoto
                          ? Image.memory(
                              vm.photoBytes!,
                              fit: BoxFit.cover,
                            )
                          : const Icon(Icons.person, size: 58, color: Colors.black87),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _brutalLabel('NOME'),
                          Text(
                            vm.studentName.toUpperCase().isEmpty
                                ? 'SEM NOME'
                                : vm.studentName.toUpperCase(),
                            style: const TextStyle(
                              color: Colors.black,
                              fontSize: 15,
                              fontWeight: FontWeight.w900,
                              height: 1.1,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 9),
                          _brutalLabel('CAMPUS'),
                          Text(
                            vm.campusName,
                            style: const TextStyle(
                              color: Colors.black,
                              fontSize: 13,
                              fontWeight: FontWeight.w800,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 9),
                          _brutalLabel('CURSO'),
                          Text(
                            '${vm.primaryCourseType} • ${vm.primaryCourseName}',
                            style: const TextStyle(
                              color: Colors.black,
                              fontSize: 12,
                              fontWeight: FontWeight.w800,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: _dataChip(
                        title: 'RA',
                        value: vm.studentRa,
                        background: const Color(0xFFFF87CC),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: _dataChip(
                        title: 'VALIDADE',
                        value: vm.badgeValidity,
                        background: const Color(0xFFA6FF3B),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Container(
            decoration: const BoxDecoration(
              color: Color(0xFF111111),
              border: Border(top: BorderSide(color: Colors.black, width: 4)),
            ),
            padding: const EdgeInsets.fromLTRB(14, 12, 14, 14),
            child: Column(
              children: [
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(color: Colors.black, width: 3),
                    boxShadow: const [
                      BoxShadow(color: Colors.black, offset: Offset(4, 4))
                    ],
                  ),
                  child: SizedBox(
                    height: 56,
                    child: BarcodeWidget(
                      barcode: Barcode.code39(),
                      data: vm.formattedRaForBarcode,
                      drawText: false,
                      color: Colors.black,
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  vm.formattedRaForBarcode,
                  style: const TextStyle(
                    color: Color(0xFFFFD400),
                    fontSize: 11,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 2,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _brutalLabel(String text) {
    return Text(
      text,
      style: const TextStyle(
        color: Colors.black54,
        fontSize: 10,
        fontWeight: FontWeight.w900,
        letterSpacing: 1,
      ),
    );
  }

  Widget _dataChip({
    required String title,
    required String value,
    required Color background,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        color: background,
        border: Border.all(color: Colors.black, width: 2),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              color: Colors.black87,
              fontSize: 10,
              fontWeight: FontWeight.w900,
              letterSpacing: 1,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            value.isEmpty ? '-' : value,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              color: Colors.black,
              fontSize: 13,
              fontWeight: FontWeight.w900,
            ),
          ),
        ],
      ),
    );
  }
}
