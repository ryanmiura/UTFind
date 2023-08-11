import 'package:flutter/material.dart';
import 'dart:convert';




class Cracha extends StatelessWidget {
  const Cracha({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var ryan = {
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
    Map<String, dynamic> ryanMap = ryan;
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          //color: Color.fromRGBO(24, 24, 24, 1),
          alignment: Alignment.center,
          transformAlignment: Alignment.center,
          child: Column(children: [
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
            Container(
              width: 350,
              height: 300,
              color: Color.fromRGBO(255, 205, 0, 1),
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Container(
                      //color: Colors.green,
                      width: 150,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: 20,),
                          Text('NOME'),
                          Text(
                            ryan["pessNomeVc"].toString(),
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                          SizedBox(height: 10,),
                          Text('CAMPUS'),
                          Text(
                            "Cornelio Procopio",
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                          SizedBox(
                            //color: Colors.black,//
                            height: 10,
                          ),
                          Row(
                            children: [
                              Text('CURSO '),
                              Text(
                                ryanMap["cursos"][0]["alCuPeriodoNr"].toString() + "° Periodo",
                                style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold),
                              )
                            ],
                          ),
                          Text(
                            ryanMap["cursos"][0]["cursNomeVc"].toString(),
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Text('VALIDADE'),
                          Text(
                            ryanMap["cursos"][0]["validadeCracha"],
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold),
                          )
                        ],
                      ),
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset('assets/photo.png'),
                        Container(
                          //color: Colors.black,
                          width: 10,
                          height: 10,
                        ),
                        Text('REGISTRO ACADEMICO'),
                        Text(
                          ryanMap["login"],
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ]),
            ),
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
              child: Image.asset('assets/barcode.png'),
            ),
          ]),
        ),
      ],
    );
  }
}
