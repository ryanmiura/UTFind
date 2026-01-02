import 'package:flutter_test/flutter_test.dart';
import 'package:utfind/models/badge.dart';

void main() {
  group('Badge Model Tests', () {
    test('formattedLoginForBarcode should replace leading "a" with "0"', () {
      final badge = Badge(
        pessNomeVc: 'Test User',
        alunEmailAlternVc: '',
        alunemail: 'test@example.com',
        emInstAluemailVc: 'test@alunos.utfpr.edu.br',
        estCivCodNr: 1,
        estCivDescrVc: 'Solteiro',
        login: 'a123456',
        matrbloqstatusNr: 0,
        paisNacioVc: 'Brasil',
        pessMaeVc: 'Mother',
        pessNascDt: 0,
        pessPaiVc: 'Father',
        pessSexoCh: 'M',
        tpBloqCodNr: 0,
        tpBloqDescrVc: '',
        situacaoPassaporte: 1,
        cursos: [],
      );

      expect(badge.formattedLoginForBarcode, '0123456');
    });

    test(
        'formattedLoginForBarcode should not change login if it does not start with "a"',
        () {
      final badge = Badge(
        pessNomeVc: 'Test User',
        alunEmailAlternVc: '',
        alunemail: 'test@example.com',
        emInstAluemailVc: 'test@alunos.utfpr.edu.br',
        estCivCodNr: 1,
        estCivDescrVc: 'Solteiro',
        login: '123456',
        matrbloqstatusNr: 0,
        paisNacioVc: 'Brasil',
        pessMaeVc: 'Mother',
        pessNascDt: 0,
        pessPaiVc: 'Father',
        pessSexoCh: 'M',
        tpBloqCodNr: 0,
        tpBloqDescrVc: '',
        situacaoPassaporte: 1,
        cursos: [],
      );

      expect(badge.formattedLoginForBarcode, '123456');
    });
  });
}
