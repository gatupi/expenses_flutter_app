import 'dart:math';
import 'package:expenses/models/transaction.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

void main() => runApp(ExpensesApp());

class Utils {
  static int? fromHexToDecimal(String hex) {
    // validar hex param com regex (pattern: /^(0x)?[0-9A-Fa-f]+$/)

    final exp = RegExp(r'^(0x)?[0-9A-Fa-f]+$');
    if (!exp.hasMatch(hex)) {
      return null;
    }

    final digits = [
      '0',
      '1',
      '2',
      '3',
      '4',
      '5',
      '6',
      '7',
      '8',
      '9',
      'A',
      'B',
      'C',
      'D',
      'E',
      'F'
    ];
    var decimal = 0;

    hex
        .split('')
        .map((h) => digits.indexOf(h))
        .toList()
        .asMap()
        .entries
        .forEach((e) =>
            decimal += e.value * pow(16, hex.length - e.key - 1).toInt());
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

  String _formatDateTime(DateTime dateTime) {
    final parts = {
      'date': [dateTime.day, dateTime.month, dateTime.year],
      'time': [dateTime.hour, dateTime.minute]
    };

    return parts['date']!
            .asMap()
            .entries
            .map((e) => e.value.toString().padLeft(e.key > 1 ? 4 : 2, '0'))
            .join('/') +
        ' ' +
        parts['time']!.map((e) => e.toString().padLeft(2, '0')).join(':');
  }

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
              'R\$ ${_transaction.value.toStringAsFixed(2).replaceFirst('.', ',')}',
              style: const TextStyle(
                color: Colors.purple,
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                _transaction.title,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              Text(
                DateFormat('d MMM y hh:mm').format(_transaction.dateTime),
                style: const TextStyle(color: Colors.grey),
              )
            ],
          )
        ]),
      );
}

class ExpenseFormState extends State<ExpenseForm> {

  double? _value;
  String? _title;
  void Function(Transaction)? _onExpenseAdded;

  ExpenseFormState(this._onExpenseAdded);

  @override
  Widget build(BuildContext context) => Card(
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(children: <Widget>[
            Container(
                margin: const EdgeInsets.only(bottom: 10),
                child: TextField(
                  decoration: const InputDecoration(labelText: 'Título'),
                  onChanged: (value) => setState(() => _title = value),
                )),
            TextField(
              decoration: const InputDecoration(
                labelText: 'Valor (R\$)',
              ),
              onChanged: (value) => setState(() {
                _value = double.parse(value);
              }),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () => _onExpenseAdded!.call((Transaction(id: '123', title: _title!, value: _value!))),
                  style: const ButtonStyle(
                      foregroundColor:
                          MaterialStatePropertyAll<Color>(Colors.purple)),
                  child: const Text('Nova Transação'),
                ),
              ],
            )
          ]),
        ),
      );
}

class ExpenseForm extends StatefulWidget {

  void Function(Transaction)? _onExpenseAdded;

  ExpenseForm(this._onExpenseAdded);

  @override
  ExpenseFormState createState() => ExpenseFormState(_onExpenseAdded);
}

class MyHomePage extends StatefulWidget {
  @override
  MyHomePageState createState() => MyHomePageState();
}

class MyHomePageState extends State<MyHomePage> {
  final List<Transaction> _transactions = [
    Transaction(id: '123', title: 'Tênis de corrida', value: 123.45),
    Transaction(
        id: 'GIFT',
        title: 'Presente Mariana',
        value: 200.5,
        dateTime: DateTime(2023, 5, 30, 10)),
    Transaction(id: 'TUPI', title: 'Macbook', value: 10000.99)
  ];

  MyHomePageState() {
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
            ),
            ExpenseForm((t) => setState(() => _transactions.add(t)))
          ],
        ));
  }
}
