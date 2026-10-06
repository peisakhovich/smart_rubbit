import 'dart:math';

import '../models/task.dart';

class ArithmeticGenerator {
  final Random random = Random();

  Task generate({
    required int number,
    required String name,
    required String type,
    required int count,
    required int multiplicationFactor,
    required int operand1Min,
    required int operand1Max,
    required int operand2Min,
    required int operand2Max,
    required bool addition,
    required bool subtraction,
    required bool multiplication,
    required bool division,
  }) {
    final operations = <String>[];

    if (addition) {
      operations.add('+');
    }

    if (subtraction) {
      operations.add('-');
    }

    if (multiplication) {
      operations.add('×');
    }

    if (division) {
      operations.add('÷');
    }

    final items = <TaskItem>[];

    if (type == 'multiplication_table') {
      for (int i = 1; i <= 10; i++) {
        final operand1 = i;
        final operand2 = multiplicationFactor;
        final result = operand1 * operand2;

        items.add(
          TaskItem(
            number: i,
            operand1: operand1,
            operation: '×',
            operand2: operand2,
            result: result,
            answer: null,
          ),
        );
      }
    } else {
      if (operations.isEmpty) {
        throw Exception('Не выбрана ни одна операция');
      }

      for (int i = 1; i <= count; i++) {
        final operation = operations[random.nextInt(operations.length)];

        int operand1;
        int operand2;

        if (operation == '÷') {
          int quotient;
          int divisor;

          while (true) {
            quotient = _randomNumber(2, 10);

            final maxDivisor = operand1Max ~/ quotient;

            if (maxDivisor < operand2Min) {
              continue;
            }

            final actualMaxDivisor = maxDivisor < operand2Max
                ? maxDivisor
                : operand2Max;

            divisor = _randomNumber(operand2Min, actualMaxDivisor);

            operand1 = divisor * quotient;

            if (operand1 >= operand1Min && operand1 <= operand1Max) {
              break;
            }
          }

          operand2 = divisor;
        } else {
          operand1 = _randomNumber(operand1Min, operand1Max);
          operand2 = _randomNumber(operand2Min, operand2Max);
        }

        if (operation == '-' && operand1 < operand2) {
          final temp = operand1;
          operand1 = operand2;
          operand2 = temp;
        }

        int result;

        if (operation == '+') {
          result = operand1 + operand2;
        } else if (operation == '-') {
          result = operand1 - operand2;
        } else if (operation == '×') {
          result = operand1 * operand2;
        } else {
          result = operand1 ~/ operand2;
        }

        items.add(
          TaskItem(
            number: i,
            operand1: operand1,
            operation: operation,
            operand2: operand2,
            result: result,
            answer: null,
          ),
        );
      }
    }

    return Task(
      number: number,
      name: name,
      type: type,
      settings: TaskSettings(
        count: count,
        operand1Min: operand1Min,
        operand1Max: operand1Max,
        operand2Min: operand2Min,
        operand2Max: operand2Max,
        addition: addition,
        subtraction: subtraction,
        multiplication: multiplication,
        division: division,
        divisionMultiples: false,
        multiplicationFactor: multiplicationFactor,
      ),
      items: items,
      statistics: TaskStatistics(completed: false, correct: 0, score: 0),
    );
  }

  int _randomNumber(int min, int max) {
    return min + random.nextInt(max - min + 1);
  }
}
