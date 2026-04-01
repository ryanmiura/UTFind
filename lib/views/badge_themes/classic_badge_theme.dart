import 'package:flutter/material.dart';
import 'package:barcode_widget/barcode_widget.dart';
import '../../viewmodels/student_vm.dart';

class ClassicBadgeTheme extends StatelessWidget {
  final StudentViewModel vm;

  const ClassicBadgeTheme({Key? key, required this.vm}) : super(key: key);

  static const utfprOrange = Color.fromRGBO(255, 123, 1, 1);
  static const utfprYellow = Color.fromRGBO(255, 205, 0, 1);
  static const utfprOrangeDark = Color(0xFFE66A00);
  static const utfprOrangeLight = Color(0xFFFF9D45);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 350,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24.0),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.12),
            blurRadius: 30,
            offset: const Offset(0, 15),
          ),
          BoxShadow(
            color: utfprOrange.withOpacity(0.1),
            blurRadius: 20,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: Stack(
        children: [
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Top bar with Premium Gradient
              Container(
                width: double.infinity,
                height: 115,
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [utfprOrangeDark, utfprOrange, utfprOrangeLight],
                    stops: [0.0, 0.6, 1.0],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: Stack(
                  children: [
                    Positioned(
                      right: -30,
                      top: -20,
                      child: Opacity(
                        opacity: 0.12,
                        child: Transform.rotate(
                          angle: -0.2,
                          child: Image.asset(
                            'assets/brasao.png',
                            width: 160,
                            height: 160,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                    Center(
                      child: Hero(
                        tag: 'badge_logo',
                        child: Image.asset(
                          'assets/utflogo.png',
                          fit: BoxFit.contain,
                          height: 80,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              // Middle section with Mesh-like Gradient
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      utfprYellow,
                      const Color(0xFFFFD700),
                      utfprYellow.withOpacity(0.9),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                padding: const EdgeInsets.symmetric(vertical: 28, horizontal: 22),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      flex: 42,
                      child: Column(
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(18),
                              border: Border.all(color: Colors.white.withOpacity(0.9), width: 4),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.15),
                                  blurRadius: 12,
                                  offset: const Offset(0, 6),
                                ),
                              ],
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(14),
                              child: vm.hasPhoto
                                  ? Image.memory(vm.photoBytes!,
                                      width: 120, height: 160, fit: BoxFit.cover)
                                  : Container(
                                      width: 120,
                                      height: 160,
                                      color: Colors.grey[100],
                                      child: Icon(Icons.person,
                                          size: 70, color: Colors.grey[300]),
                                    ),
                            ),
                          ),
                          const SizedBox(height: 18),
                          _label('RA'),
                          Text(vm.studentRa,
                              style: const TextStyle(
                                  fontSize: 19,
                                  fontWeight: FontWeight.w900,
                                  color: Colors.black87,
                                  letterSpacing: -0.5)),
                        ],
                      ),
                    ),
                    const SizedBox(width: 20),
                    Expanded(
                      flex: 58,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _infoField('NOME', vm.studentName),
                          const SizedBox(height: 14),
                          _infoField('CAMPUS', vm.campusName),
                          const SizedBox(height: 14),
                          _infoField('CURSO',
                              '${vm.primaryCourseType}\n${vm.primaryCourseName}'),
                          const SizedBox(height: 14),
                          _infoField('VALIDADE', vm.badgeValidity),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              // Bottom bar with Reversed Gradient and Barcode
              Container(
                width: double.infinity,
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [utfprOrangeLight, utfprOrange, utfprOrangeDark],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                padding: const EdgeInsets.fromLTRB(30, 24, 30, 32),
                child: Column(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(14),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.08),
                            blurRadius: 6,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
                      height: 85,
                      child: BarcodeWidget(
                        barcode: Barcode.code39(),
                        data: vm.formattedRaForBarcode,
                        drawText: false,
                        color: Colors.black.withOpacity(0.85),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(vm.formattedRaForBarcode,
                        style: TextStyle(
                            fontSize: 12,
                            color: Colors.white.withOpacity(0.95),
                            letterSpacing: 4,
                            fontWeight: FontWeight.w900)),
                  ],
                ),
              ),
            ],
          ),
          // Glossy Reflection Overlay
          Positioned.fill(
            child: IgnorePointer(
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: const Alignment(0.5, 2),
                    colors: [
                      Colors.white.withOpacity(0.15),
                      Colors.white.withOpacity(0.05),
                      Colors.transparent,
                      Colors.black.withOpacity(0.02),
                    ],
                    stops: const [0.0, 0.4, 0.5, 1.0],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _label(String text) {
    return Text(text,
        style: TextStyle(
            fontSize: 10,
            fontWeight: FontWeight.w900,
            color: Colors.black.withOpacity(0.4),
            letterSpacing: 2.0));
  }

  Widget _infoField(String label, String value) {
    if (value.isEmpty) return const SizedBox.shrink();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _label(label),
        const SizedBox(height: 2),
        Text(value,
            style: const TextStyle(
                fontSize: 14.5,
                fontWeight: FontWeight.w800,
                color: Colors.black87,
                height: 1.2),
            maxLines: 3,
            overflow: TextOverflow.ellipsis),
      ],
    );
  }
}