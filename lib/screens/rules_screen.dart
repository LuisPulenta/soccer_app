import 'package:flutter/material.dart';

class RulesScreen extends StatefulWidget {
  const RulesScreen({super.key});

  @override
  State<RulesScreen> createState() => _RulesScreenState();
}

class _RulesScreenState extends State<RulesScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF00D99D),
      appBar: AppBar(
        title: const Text('Reglamento'),
        centerTitle: true,
        backgroundColor: const Color.fromARGB(255, 8, 69, 48),
      ),
      body: Column(
        children: [
          Container(
            alignment: Alignment.centerLeft,
            padding: const EdgeInsets.all(10),
            child: const Text(
                'Se pueden cargar las predicciones hasta momentos antes del inicio de cada partido.'),
          ),
          Container(
            alignment: Alignment.centerLeft,
            padding: const EdgeInsets.all(10),
            child: const Text(
                'Cada partido otorga puntos según los siguientes criterios:'),
          ),
          Container(
            alignment: Alignment.centerLeft,
            padding:
                const EdgeInsets.only(left: 30, top: 10, bottom: 10, right: 10),
            child: const Text(
                '- 2 Puntos, por acertar si el ganador fue el Local, si el ganador fue el Visitante, o si fue Empate.'),
          ),
          Container(
            alignment: Alignment.centerLeft,
            padding:
                const EdgeInsets.only(left: 30, top: 10, bottom: 10, right: 10),
            child: const Text(
                '- 1 Punto, por acertar los Goles que hizo el Local.'),
          ),
          Container(
            alignment: Alignment.centerLeft,
            padding:
                const EdgeInsets.only(left: 30, top: 10, bottom: 10, right: 10),
            child: const Text(
                '- 1 Punto, por acertar los Goles que hizo el Visitante.'),
          ),
          Container(
            alignment: Alignment.centerLeft,
            padding:
                const EdgeInsets.only(left: 10, top: 10, bottom: 10, right: 10),
            child: const Text(
              'Ejemplos:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          Center(
              child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Table(
              defaultVerticalAlignment: TableCellVerticalAlignment.bottom,
              //defaultColumnWidth: FixedColumnWidth(100),
              columnWidths: const {
                0: const FractionColumnWidth(0.4),
                1: const FractionColumnWidth(0.4),
                2: const FractionColumnWidth(0.2),
              },
              border: TableBorder.all(),
              children: const [
                TableRow(children: [
                  Text(
                    'Predicción',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  Text(
                    'Real',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  Text(
                    'Puntos',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ]),
                TableRow(children: [
                  Text(
                    '2-1',
                    textAlign: TextAlign.center,
                  ),
                  Text(
                    '2-1',
                    textAlign: TextAlign.center,
                  ),
                  Text(
                    '4',
                    textAlign: TextAlign.center,
                  ),
                ]),
                TableRow(children: [
                  Text(
                    '1-1',
                    textAlign: TextAlign.center,
                  ),
                  Text(
                    '1-1',
                    textAlign: TextAlign.center,
                  ),
                  Text(
                    '4',
                    textAlign: TextAlign.center,
                  ),
                ]),
                TableRow(children: [
                  Text(
                    '0-1',
                    textAlign: TextAlign.center,
                  ),
                  Text(
                    '0-1',
                    textAlign: TextAlign.center,
                  ),
                  Text(
                    '4',
                    textAlign: TextAlign.center,
                  ),
                ]),
                TableRow(children: [
                  Text(
                    '2-1',
                    textAlign: TextAlign.center,
                  ),
                  Text(
                    '2-0',
                    textAlign: TextAlign.center,
                  ),
                  Text(
                    '3',
                    textAlign: TextAlign.center,
                  ),
                ]),
                TableRow(children: [
                  Text(
                    '2-1',
                    textAlign: TextAlign.center,
                  ),
                  Text(
                    '3-1',
                    textAlign: TextAlign.center,
                  ),
                  Text(
                    '3',
                    textAlign: TextAlign.center,
                  ),
                ]),
                TableRow(children: [
                  Text(
                    '2-1',
                    textAlign: TextAlign.center,
                  ),
                  Text(
                    '1-0',
                    textAlign: TextAlign.center,
                  ),
                  Text(
                    '2',
                    textAlign: TextAlign.center,
                  ),
                ]),
                TableRow(children: [
                  Text(
                    '2-2',
                    textAlign: TextAlign.center,
                  ),
                  Text(
                    '1-1',
                    textAlign: TextAlign.center,
                  ),
                  Text(
                    '2',
                    textAlign: TextAlign.center,
                  ),
                ]),
                TableRow(children: [
                  Text(
                    '2-1',
                    textAlign: TextAlign.center,
                  ),
                  Text(
                    '0-1',
                    textAlign: TextAlign.center,
                  ),
                  Text(
                    '1',
                    textAlign: TextAlign.center,
                  ),
                ]),
                TableRow(children: [
                  Text(
                    '1-0',
                    textAlign: TextAlign.center,
                  ),
                  Text(
                    '1-2',
                    textAlign: TextAlign.center,
                  ),
                  Text(
                    '1',
                    textAlign: TextAlign.center,
                  ),
                ]),
                TableRow(children: [
                  Text(
                    '2-1',
                    textAlign: TextAlign.center,
                  ),
                  Text(
                    '0-0',
                    textAlign: TextAlign.center,
                  ),
                  Text(
                    '0',
                    textAlign: TextAlign.center,
                  ),
                ]),
              ],
            ),
          ))
        ],
      ),
    );
  }
}
