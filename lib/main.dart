import 'dart:math';
import 'package:expenses/models/transaction.dart';
import 'package:flutter/material.dart';

void main() => runApp(ExpensesApp());

class Utils {
  static int? fromHexToDecimal(String hex) {

    // validar hex param com regex (pattern: /^(0x)?[0-9A-Fa-f]+$/)

    final exp = RegExp(r'^(0x)?[0-9A-Fa-f]+$');
    if (!exp.hasMatch(hex)) {
      return null;
    }

    final digits = ['0','1','2','3','4','5','6','7','8','9','A','B','C','D','E','F'];
    var decimal = 0;

    hex.split('').map((h) => digits.indexOf(h)).toList()
      .asMap().entries.forEach(
        (e) => decimal += e.value * pow(16, hex.length - e.key - 1).toInt()
      );
    return decimal;
  }

  static Color? fromHexColor(String hexColor) {

    if (!RegExp(r'^[\dA-Fa-f]{6}$').hasMatch(hexColor)) {
      return null;
    }

    final Map<String, int> rgb = {
      'red': Utils.fromHexToDecimal(hexColor.substring(0, 2)) ?? 255,
      'green': Utils.fromHexToDecimal(hexColor.substring(2, 4)) ?? 255,
      'blue': Utils.fromHexToDecimal(hexColor.substring(4)) ?? 255
    };

    return Color.fromARGB(255, rgb['red']!, rgb['green']!, rgb['blue']!);
  }
}

class ExpensesApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MyHomePage(),
    );
  }
}

class TransactionCard extends StatelessWidget {
  Transaction _transaction;

  TransactionCard(this._transaction);

  @override
  Widget build(BuildContext context) => Card(
        child: Row(children: <Widget>[
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            padding: EdgeInsets.all(10),
            decoration: BoxDecoration(
                border: Border.all(
              width: 2,
              color: Colors.purple,
            )),
            child: Text(
              _transaction.value.toString(),
              style: const TextStyle(
                color: Colors.purple,
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
          ),
          Column(
            children: <Widget>[
              Text(_transaction.title),
              Text(_transaction.dateTime.toString())
            ],
          )
        ]),
      );
}

class MyHomePage extends StatelessWidget {
  final List<Transaction> _transactions = [
    Transaction(id: '123', title: 'Tênis de corrida', value: 123.45),
    Transaction(id: 'ALSKDJF', title: 'Conta de luz', value: 200.85),
    Transaction(id: 'TUPI', title: 'Macbook', value: 10000.99)
  ];

  MyHomePage() {
    _transactions.forEach((element) => print(element));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Despesas Pessoais'),
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Container(
              color: Utils.fromHexColor('aa4477'),
              child: const Padding(
                padding: EdgeInsets.all(10),
                child: Card(
                  margin: EdgeInsets.all(0),
                  elevation: 0,
                  color: Colors.blue,
                  child: Text(
                    'Gráfico',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.w500),
                  ),
                ),
              ),
            ),
            Column(
              children: _transactions.map((t) => TransactionCard(t)).toList(),
            )
          ],
        ));
  }
}
