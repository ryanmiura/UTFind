import 'package:flutter/material.dart';
import 'package:barcode_widget/barcode_widget.dart';
import '../../viewmodels/student_vm.dart';

class ProfessionalBadgeTheme extends StatelessWidget {
  final StudentViewModel vm;

  const ProfessionalBadgeTheme({Key? key, required this.vm}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const Color utfprOrange = Color(0xFFFF7B01);
    const Color utfprYellow = Color(0xFFFFCD00);

    return Container(
      width: 350,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20.0),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.12),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Header with Logo
          Stack(
            clipBehavior: Clip.none,
            children: [
              Container(
                width: double.infinity,
                height: 110,
                decoration: const BoxDecoration(
                  color: utfprOrange,
                ),
              ),
              // Yellow accent line
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Container(
                  height: 6,
                  color: utfprYellow,
                ),
              ),
              // Logo
              Positioned(
                top: 20,
                left: 0,
                right: 0,
                child: Center(
                  child: Image.asset(
                    'assets/utflogo.png',
                    fit: BoxFit.contain,
                    height: 55,
                  ),
                ),
              ),
            ],
          ),
          
          // Body Area
          Padding(
            padding: const EdgeInsets.fromLTRB(24, 24, 24, 16),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Info Column
                Expanded(
                  flex: 3,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _label('NOME DO ESTUDANTE'),
                      _value(vm.studentName, fontSize: 16),
                      const SizedBox(height: 14),
                      _label('CURSO'),
                      _value('${vm.primaryCourseType}\n${vm.primaryCourseName}', maxLines: 2),
                      const SizedBox(height: 14),
                      _label('CÂMPUS'),
                      _value(vm.campusName),
                    ],
                  ),
                ),
                const SizedBox(width: 16),
                
                // Photo & RA Column
                Expanded(
                  flex: 2,
                  child: Column(
                    children: [
                      // Photo
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.grey.shade300, width: 1),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.05),
                              blurRadius: 6,
                              offset: const Offset(0, 3),
                            ),
                          ],
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(11),
                          child: vm.hasPhoto
                              ? Image.memory(
                                  vm.photoBytes!,
                                  width: 100,
                                  height: 130,
                                  fit: BoxFit.cover,
                                )
                              : Container(
                                  width: 100,
                                  height: 130,
                                  color: Colors.grey.shade100,
                                  child: Icon(Icons.person,
                                      size: 50, color: Colors.grey.shade400),
                                ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      // RA
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(vertical: 6),
                        decoration: BoxDecoration(
                          color: Colors.grey.shade100,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: Colors.grey.shade300),
                        ),
                        child: Column(
                          children: [
                            _label('RA'),
                            Text(
                              vm.studentRa.isEmpty ? '-' : vm.studentRa,
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: utfprOrange,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          
          // Footer / Barcode Area
          Container(
            width: double.infinity,
            padding: const EdgeInsets.fromLTRB(24, 16, 24, 24),
            decoration: BoxDecoration(
              color: Colors.grey.shade50,
              border: Border(
                top: BorderSide(color: Colors.grey.shade200),
              ),
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.verified_user, size: 16, color: Colors.green),
                        const SizedBox(width: 4),
                        Text(
                          'VALIDADE: ${vm.badgeValidity}',
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey.shade700,
                          ),
                        ),
                      ],
                    ),
                    const Icon(Icons.contactless, size: 18, color: Colors.grey),
                  ],
                ),
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: Colors.grey.shade300),
                  ),
                  child: BarcodeWidget(
                    barcode: Barcode.code39(),
                    data: vm.formattedRaForBarcode,
                    drawText: false,
                    color: Colors.black,
                    height: 50,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  vm.formattedRaForBarcode,
                  style: const TextStyle(
                    fontSize: 11,
                    color: Colors.black87,
                    letterSpacing: 3,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _label(String text) {
    return Text(
      text,
      style: TextStyle(
        fontSize: 10,
        fontWeight: FontWeight.w700,
        color: Colors.grey.shade600,
        letterSpacing: 0.8,
      ),
    );
  }

  Widget _value(String text, {double fontSize = 13, int maxLines = 1}) {
    return Text(
      text.isEmpty ? '-' : text,
      style: TextStyle(
        fontSize: fontSize,
        fontWeight: FontWeight.w800,
        color: Colors.black87,
        height: 1.2,
      ),
      maxLines: maxLines,
      overflow: TextOverflow.ellipsis,
    );
  }
}
