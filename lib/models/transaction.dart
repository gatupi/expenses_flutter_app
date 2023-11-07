import 'package:expenses/main.dart';
import 'package:flutter/cupertino.dart';

class Transaction {
  String id;
  String title;
  double value;
  late DateTime dateTime;

  Transaction(
      {required this.id,
      required this.title,
      required this.value,
      DateTime? dateTime}) {
    this.dateTime = dateTime ?? DateTime.now();
  }

  @override
  String toString() {
    final lines = [
      'ID: $id',
      'Title: $title',
      'Value: R\$$value',
      'Date & Time: $dateTime'
    ];

    int longest = 0;
    lines.asMap().entries.forEach((entry) => longest =
        entry.value.length > lines[longest].length ? entry.key : longest);

    final ref = '| ${lines[longest]} |';
    final length = ref.length;
    const strTitle = 'TRANSACTION';
    final l = length - strTitle.length - 2;

    var objString =  '+${strTitle.padLeft((strTitle.length + l / 2).floor(), '-').padRight(length - 2, '-')}+';
    lines.forEach((line) {
      final part = '| ${line}'.padRight(length - 2) + ' |';
      objString += '\n$part';
    });
    objString += '\n+' + ''.padLeft(length - 2, '-') + '+';

    print(Utils.fromHexToDecimal('AA'));
    print(Utils.fromHexToDecimal('ABCg'));

    return objString;
  }
}
