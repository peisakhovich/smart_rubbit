import 'package:flutter/material.dart';

import '../app/rabbit_state.dart';
import '../widgets/rabbit_avatar.dart';
import '../services/arithmetic_generator.dart';
import '../services/task_storage.dart';

class CreateTaskScreen extends StatefulWidget {
  const CreateTaskScreen({super.key});

  @override
  State<CreateTaskScreen> createState() => _CreateTaskScreenState();
}

class _CreateTaskScreenState extends State<CreateTaskScreen> {
  final TextEditingController nameController = TextEditingController();

  bool arithmetic = true;

  int count = 10;

  int operand1Min = 1;
  int operand1Max = 100;

  int operand2Min = 1;
  int operand2Max = 100;

  int multiplicationFactor = 2;

  bool addition = true;
  bool subtraction = true;
  bool multiplication = false;
  bool division = false;

  bool divisionMultiples = false;

  @override
  void dispose() {
    nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Создать задание')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildRabbitHeader(),

            const SizedBox(height: 16),

            _buildNameSection(),

            const SizedBox(height: 16),

            _buildTypeSection(),

            const SizedBox(height: 16),

            if (arithmetic) ...[
              _buildArithmeticSection(),
              const SizedBox(height: 16),
              _buildOperationsSection(),
            ] else ...[
              _buildMultiplicationTableSection(),
            ],

            const SizedBox(height: 24),

            _buildCreateButton(),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildRabbitHeader() {
    return Card(
      elevation: 0,
      color: Colors.blue.shade50,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(
              width: 120,
              height: 120,
              child: RabbitAvatar(state: RabbitState.think),
            ),

            const SizedBox(width: 12),

            Expanded(
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Text(
                  'Привет! Давай создадим новое задание!\n\n'
                  'Выбери параметры, и я помогу '
                  'сгенерировать упражнения.',
                  style: TextStyle(fontSize: 16, height: 1.35),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNameSection() {
    return Card(
      elevation: 0,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Название задания',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 8),

            TextField(
              controller: nameController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Например: Сложение от 1 до 20',
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTypeSection() {
    return Card(
      elevation: 0,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Тип задания',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 8),

            RadioGroup<bool>(
              groupValue: arithmetic,
              onChanged: (value) {
                setState(() {
                  arithmetic = value!;
                });
              },
              child: Column(
                children: const [
                  RadioListTile<bool>(
                    value: true,
                    title: Text('Арифметика'),
                    subtitle: Text('Сложение, вычитание, умножение, деление'),
                  ),
                  RadioListTile<bool>(
                    value: false,
                    title: Text('Таблица умножения'),
                    subtitle: Text('Примеры на умножение одной таблицы'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildArithmeticSection() {
    return Card(
      elevation: 0,
      color: Colors.blue.shade50,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Параметры для арифметики',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 16),

            _buildNumberDropdown(
              title: 'Количество примеров',
              value: count,
              values: [5, 10, 15, 20],
              onChanged: (value) {
                setState(() {
                  count = value!;
                });
              },
            ),

            const SizedBox(height: 12),

            Row(
              children: [
                Expanded(
                  child: _buildNumberDropdown(
                    title: 'Первое число от',
                    value: operand1Min,
                    values: List.generate(100, (index) => index + 1),
                    onChanged: (value) {
                      setState(() {
                        operand1Min = value!;
                      });
                    },
                  ),
                ),

                const SizedBox(width: 12),

                Expanded(
                  child: _buildNumberDropdown(
                    title: 'Первое число до',
                    value: operand1Max,
                    values: List.generate(100, (index) => index + 1),
                    onChanged: (value) {
                      setState(() {
                        operand1Max = value!;
                      });
                    },
                  ),
                ),
              ],
            ),

            const SizedBox(height: 12),

            Row(
              children: [
                Expanded(
                  child: _buildNumberDropdown(
                    title: 'Второе число от',
                    value: operand2Min,
                    values: List.generate(100, (index) => index + 1),
                    onChanged: (value) {
                      setState(() {
                        operand2Min = value!;
                      });
                    },
                  ),
                ),

                const SizedBox(width: 12),

                Expanded(
                  child: _buildNumberDropdown(
                    title: 'Второе число до',
                    value: operand2Max,
                    values: List.generate(100, (index) => index + 1),
                    onChanged: (value) {
                      setState(() {
                        operand2Max = value!;
                      });
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMultiplicationTableSection() {
    return Card(
      elevation: 0,
      color: Colors.purple.shade50,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Параметры для таблицы умножения',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 16),

            _buildNumberDropdown(
              title: 'Таблица умножения на',
              value: multiplicationFactor,
              values: List.generate(10, (index) => index + 1),
              onChanged: (value) {
                setState(() {
                  multiplicationFactor = value!;
                });
              },
            ),

            const SizedBox(height: 16),

            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                'Будут созданы примеры:\n'
                '1 × $multiplicationFactor, '
                '2 × $multiplicationFactor, '
                '3 × $multiplicationFactor, ... '
                '10 × $multiplicationFactor',
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOperationsSection() {
    return Card(
      elevation: 0,
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Выбрать операции',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 6),

            CheckboxListTile(
              value: addition,
              title: const Text('Сложение (+)'),
              onChanged: (value) {
                setState(() {
                  addition = value!;
                });
              },
            ),

            CheckboxListTile(
              value: subtraction,
              title: const Text('Вычитание (−)'),
              onChanged: (value) {
                setState(() {
                  subtraction = value!;
                });
              },
            ),

            CheckboxListTile(
              value: multiplication,
              title: const Text('Умножение (×)'),
              onChanged: (value) {
                setState(() {
                  multiplication = value!;
                });
              },
            ),

            CheckboxListTile(
              value: division,
              title: const Text('Деление (÷)'),
              onChanged: (value) {
                setState(() {
                  division = value!;
                });
              },
            ),

            if (division)
              CheckboxListTile(
                value: divisionMultiples,
                title: const Text('Только деление без остатка'),
                onChanged: (value) {
                  setState(() {
                    divisionMultiples = value!;
                  });
                },
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildNumberDropdown({
    required String title,
    required int value,
    required List<int> values,
    required ValueChanged<int?> onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
        ),

        const SizedBox(height: 6),

        DropdownButtonFormField<int>(
          initialValue: value,
          decoration: const InputDecoration(border: OutlineInputBorder()),
          items: values.map((number) {
            return DropdownMenuItem<int>(
              value: number,
              child: Text(number.toString()),
            );
          }).toList(),
          onChanged: onChanged,
        ),
      ],
    );
  }

  Widget _buildCreateButton() {
    return SizedBox(
      height: 58,
      child: ElevatedButton.icon(
        onPressed: () async {
          if (nameController.text.trim().isEmpty) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Введите название задания')),
            );
            return;
          }

          final storage = TaskStorage();

          final tasks = await storage.loadAllTasks();

          int nextNumber = 1;

          if (tasks.isNotEmpty) {
            nextNumber =
                tasks
                    .map((task) => task.number)
                    .reduce((a, b) => a > b ? a : b) +
                1;
          }

          final generator = ArithmeticGenerator();

          final task = generator.generate(
            number: nextNumber,
            name: nameController.text.trim(),
            type: arithmetic ? 'arithmetic' : 'multiplication_table',
            count: count,
            multiplicationFactor: multiplicationFactor,
            operand1Min: operand1Min,
            operand1Max: operand1Max,
            operand2Min: operand2Min,
            operand2Max: operand2Max,
            addition: addition,
            subtraction: subtraction,
            multiplication: multiplication,
            division: division,
          );

          await storage.saveTask(task);

          if (!mounted) return;

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Задание №$nextNumber создано')),
          );
        },
        icon: const Icon(Icons.check),
        label: const Text('Создать задание', style: TextStyle(fontSize: 18)),
      ),
    );
  }
}
