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

    test(
        'CursoBadge unidNome should return correct campus name for valid unidCodNr',
        () {
      final curso = CursoBadge(
        alCuIdVc: 'prdpnp',
        cursAbrevVc: 'ENG',
        unidCodNr: 2,
        cursCodNr: 65,
        cursNomeVc: 'Engenharia',
        tpCurCodNr: 2,
        tpCurDescrVc: 'Bacharelado',
        sitpCodNr: 0,
        sitpDescrVc: 'Regular',
        alCuAnoingNr: 2022,
        alCuPerAnoingNr: 1,
        alCuCategpgNr: 0,
        nivEnsCursoCodNr: 3,
        nivEnsDescrVc: 'Superior',
        alCuOrdemNr: 1,
        alCuCalouroNr: 0,
        alCuPeriodoNr: 4,
        gradCodNr: 175,
        gradDescrVc: 'Graduação',
        alCuCoefNr: 0.8,
        alCuTurnoCh: 'N',
        validadeCracha: '2025-12-31',
        anoVigente: 2023,
        periodoVigente: 2,
      );

      expect(curso.unidNome, 'Cornélio Procópio');
    });

    test(
        'CursoBadge unidNome should return "Desconhecido" for invalid unidCodNr',
        () {
      final curso = CursoBadge(
        alCuIdVc: 'prdpnp',
        cursAbrevVc: 'ENG',
        unidCodNr: 999,
        cursCodNr: 65,
        cursNomeVc: 'Engenharia',
        tpCurCodNr: 2,
        tpCurDescrVc: 'Bacharelado',
        sitpCodNr: 0,
        sitpDescrVc: 'Regular',
        alCuAnoingNr: 2022,
        alCuPerAnoingNr: 1,
        alCuCategpgNr: 0,
        nivEnsCursoCodNr: 3,
        nivEnsDescrVc: 'Superior',
        alCuOrdemNr: 1,
        alCuCalouroNr: 0,
        alCuPeriodoNr: 4,
        gradCodNr: 175,
        gradDescrVc: 'Graduação',
        alCuCoefNr: 0.8,
        alCuTurnoCh: 'N',
        validadeCracha: '2025-12-31',
        anoVigente: 2023,
        periodoVigente: 2,
      );

      expect(curso.unidNome, 'Desconhecido');
    });
  });
}
