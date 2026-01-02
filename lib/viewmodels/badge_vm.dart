// ESTA VIEWMODEL ESTA EM DESUSO.
import 'package:flutter/material.dart';
import '../models/badge.dart' as badge_model;

enum BadgeState { initial, loading, loaded, error }

class BadgeViewModel extends ChangeNotifier {
  BadgeState _state = BadgeState.initial;
  BadgeState get state => _state;

  badge_model.Badge? _badge;
  badge_model.Badge? get badge => _badge;

  String? _error;
  String? get error => _error;

  Future<void> fetchBadge() async {
    _state = BadgeState.loading;
    notifyListeners();

    await Future.delayed(const Duration(seconds: 1)); // Simula carregamento

    try {
      // mock dos dados do crachá
      final mock = {
        "pessNomeVc": "RYAN MIURA CARRASCO",
        "alunEmailAlternVc": "",
        "alunemail": "ryan@gmail.com",
        "emInstAluemailVc": "r@alunos.utfpr.edu.br",
        "estCivCodNr": 1,
        "estCivDescrVc": "Solteiro(a)",
        "login": "a2465779",
        "matrbloqstatusNr": 0,
        "paisNacioVc": "Brasileira",
        "pessMaeVc": "F",
        "pessNascDt": 1000,
        "pessPaiVc": "",
        "pessSexoCh": "M",
        "tpBloqCodNr": 0,
        "tpBloqDescrVc": "",
        "situacaoPassaporte": 1,
        "cursos": [
          {
            "alCuIdVc": "prdpnp",
            "cursAbrevVc": "BACH ENG DE SOFTWARE",
            "unidCodNr": 2,
            "cursCodNr": 65,
            "ultimaModificacao": null,
            "cursNomeVc": "Bacharelado Em Engenharia De Software",
            "tpCurCodNr": 2,
            "tpCurDescrVc": "Bacharelado",
            "sitpCodNr": 0,
            "sitpDescrVc": "Regular",
            "alCuAnoingNr": 2022,
            "alCuPerAnoingNr": 1,
            "alCuCategpgNr": 0,
            "nivEnsCursoCodNr": 3,
            "nivEnsDescrVc": "Ensino Superior",
            "alCuOrdemNr": 1,
            "alCuCalouroNr": 0,
            "alCuColacaoDt": null,
            "alCuPeriodoNr": 4,
            "gradCodNr": 175,
            "gradDescrVc": "Bacharelado Em Engenharia De Software",
            "alCuCoefNr": 0.7748,
            "alCuTurnoCh": "N",
            "validadeCracha": "2025-12-31",
            "anoVigente": 2023,
            "periodoVigente": 2
          }
        ]
      };

      _badge = badge_model.Badge.fromJson(mock);
      _state = BadgeState.loaded;
      _error = null;
    } catch (e) {
      _state = BadgeState.error;
      _error = 'Erro ao carregar crachá';
    }
    notifyListeners();
  }
}
