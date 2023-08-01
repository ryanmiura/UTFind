import 'package:flutter/material.dart';

class Cracha extends StatelessWidget {
  const Cracha({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
                          Container(
                            //color: Colors.black,
                            width: 10,
                            height: 80,
                          ),
                          Text('NOME'),
                          Text(
                            'Ryan Miura Carrasco',
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                          Container(
                            //color: Colors.black,
                            width: 10,
                            height: 10,
                          ),
                          Text('CAMPUS'),
                          Text(
                            'Cornelio Procopio',
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                          Container(
                            //color: Colors.black,
                            width: 10,
                            height: 10,
                          ),
                          Row(
                            children: [
                              Text('CURSO '),
                              Text(
                                '4 Periodo',
                                style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold),
                              )
                            ],
                          ),
                          Text(
                            'Eng. de Software',
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                          Container(
                            //color: Colors.black,
                            width: 10,
                            height: 50,
                          ),
                          Text('VALIDADE'),
                          Text(
                            '31/12/2026',
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
                          '2465778',
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
