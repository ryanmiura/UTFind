import '../constants/unit_constants.dart';

class CursoBadge {
  final String alCuIdVc;
  final String cursAbrevVc;
  final int unidCodNr;
  // ... rest of the fields

  String get unidNome => unitMapping[unidCodNr] ?? 'Desconhecido';
  final int cursCodNr;
  final String? ultimaModificacao;
  final String cursNomeVc;
  final int tpCurCodNr;
  final String tpCurDescrVc;
  final int sitpCodNr;
  final String sitpDescrVc;
  final int alCuAnoingNr;
  final int alCuPerAnoingNr;
  final int alCuCategpgNr;
  final int nivEnsCursoCodNr;
  final String nivEnsDescrVc;
  final int alCuOrdemNr;
  final int alCuCalouroNr;
  final String? alCuColacaoDt;
  final int alCuPeriodoNr;
  final int gradCodNr;
  final String gradDescrVc;
  final double alCuCoefNr;
  final String alCuTurnoCh;
  final String validadeCracha;
  final int anoVigente;
  final int periodoVigente;

  CursoBadge({
    required this.alCuIdVc,
    required this.cursAbrevVc,
    required this.unidCodNr,
    required this.cursCodNr,
    this.ultimaModificacao,
    required this.cursNomeVc,
    required this.tpCurCodNr,
    required this.tpCurDescrVc,
    required this.sitpCodNr,
    required this.sitpDescrVc,
    required this.alCuAnoingNr,
    required this.alCuPerAnoingNr,
    required this.alCuCategpgNr,
    required this.nivEnsCursoCodNr,
    required this.nivEnsDescrVc,
    required this.alCuOrdemNr,
    required this.alCuCalouroNr,
    this.alCuColacaoDt,
    required this.alCuPeriodoNr,
    required this.gradCodNr,
    required this.gradDescrVc,
    required this.alCuCoefNr,
    required this.alCuTurnoCh,
    required this.validadeCracha,
    required this.anoVigente,
    required this.periodoVigente,
  });

  factory CursoBadge.fromJson(Map<String, dynamic> json) {
    return CursoBadge(
      alCuIdVc: json['alCuIdVc'] ?? '',
      cursAbrevVc: json['cursAbrevVc'] ?? '',
      unidCodNr: json['unidCodNr'] ?? 0,
      cursCodNr: json['cursCodNr'] ?? 0,
      ultimaModificacao: json['ultimaModificacao'],
      cursNomeVc: json['cursNomeVc'] ?? '',
      tpCurCodNr: json['tpCurCodNr'] ?? 0,
      tpCurDescrVc: json['tpCurDescrVc'] ?? '',
      sitpCodNr: json['sitpCodNr'] ?? 0,
      sitpDescrVc: json['sitpDescrVc'] ?? '',
      alCuAnoingNr: json['alCuAnoingNr'] ?? 0,
      alCuPerAnoingNr: json['alCuPerAnoingNr'] ?? 0,
      alCuCategpgNr: json['alCuCategpgNr'] ?? 0,
      nivEnsCursoCodNr: json['nivEnsCursoCodNr'] ?? 0,
      nivEnsDescrVc: json['nivEnsDescrVc'] ?? '',
      alCuOrdemNr: json['alCuOrdemNr'] ?? 0,
      alCuCalouroNr: json['alCuCalouroNr'] ?? 0,
      alCuColacaoDt: json['alCuColacaoDt'],
      alCuPeriodoNr: json['alCuPeriodoNr'] ?? 0,
      gradCodNr: json['gradCodNr'] ?? 0,
      gradDescrVc: json['gradDescrVc'] ?? '',
      alCuCoefNr: (json['alCuCoefNr'] is double)
          ? json['alCuCoefNr']
          : (json['alCuCoefNr'] is int)
              ? (json['alCuCoefNr'] as int).toDouble()
              : (json['alCuCoefNr'] != null
                  ? double.tryParse(json['alCuCoefNr'].toString()) ?? 0.0
                  : 0.0),
      alCuTurnoCh: json['alCuTurnoCh'] ?? '',
      validadeCracha: json['validadeCracha'] ?? '',
      anoVigente: json['anoVigente'] ?? 0,
      periodoVigente: json['periodoVigente'] ?? 0,
    );
  }
}

class Badge {
  final String pessNomeVc;
  final String alunEmailAlternVc;
  final String alunemail;
  final String emInstAluemailVc;
  final int estCivCodNr;
  final String estCivDescrVc;
  final String login;
  final int matrbloqstatusNr;
  final String paisNacioVc;
  final String pessMaeVc;
  final int pessNascDt;
  final String pessPaiVc;
  final String pessSexoCh;
  final int tpBloqCodNr;
  final String tpBloqDescrVc;
  final int situacaoPassaporte;
  final List<CursoBadge> cursos;

  Badge({
    required this.pessNomeVc,
    required this.alunEmailAlternVc,
    required this.alunemail,
    required this.emInstAluemailVc,
    required this.estCivCodNr,
    required this.estCivDescrVc,
    required this.login,
    required this.matrbloqstatusNr,
    required this.paisNacioVc,
    required this.pessMaeVc,
    required this.pessNascDt,
    required this.pessPaiVc,
    required this.pessSexoCh,
    required this.tpBloqCodNr,
    required this.tpBloqDescrVc,
    required this.situacaoPassaporte,
    required this.cursos,
  });

  String get formattedLoginForBarcode {
    if (login.startsWith('a')) {
      return '0${login.substring(1)}';
    }
    return login;
  }

  factory Badge.fromJson(Map<String, dynamic> json) {
    return Badge(
      pessNomeVc: json['pessNomeVc'] ?? '',
      alunEmailAlternVc: json['alunEmailAlternVc'] ?? '',
      alunemail: json['alunemail'] ?? '',
      emInstAluemailVc: json['emInstAluemailVc'] ?? '',
      estCivCodNr: json['estCivCodNr'] ?? 0,
      estCivDescrVc: json['estCivDescrVc'] ?? '',
      login: json['login'] ?? '',
      matrbloqstatusNr: json['matrbloqstatusNr'] ?? 0,
      paisNacioVc: json['paisNacioVc'] ?? '',
      pessMaeVc: json['pessMaeVc'] ?? '',
      pessNascDt: json['pessNascDt'] ?? 0,
      pessPaiVc: json['pessPaiVc'] ?? '',
      pessSexoCh: json['pessSexoCh'] ?? '',
      tpBloqCodNr: json['tpBloqCodNr'] ?? 0,
      tpBloqDescrVc: json['tpBloqDescrVc'] ?? '',
      situacaoPassaporte: json['situacaoPassaporte'] ?? 0,
      cursos: (json['cursos'] as List<dynamic>? ?? [])
          .map((e) => CursoBadge.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }
}
