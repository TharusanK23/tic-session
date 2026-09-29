import 'package:flutter/material.dart';
import '../models/task.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final tasks = [
      Task(id: '1', title: 'Buy groceries', description: 'Milk, eggs, rice', createdAt: DateTime.now()),
      Task(id: '2', title: 'Finish Flutter homework', isDone: true, createdAt: DateTime.now()),
      Task(id: '3', title: 'Call the bank', createdAt: DateTime.now()),
    ];

    return Scaffold(
      appBar: AppBar(title: const Text('TaskFlow')),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: double.infinity,
            margin: const EdgeInsets.all(12),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primaryContainer,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                const Icon(Icons.today, size: 32),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'You have ${tasks.where((t) => !t.isDone).length} tasks to do today',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: tasks.length,
              itemBuilder: (context, index) {
                final task = tasks[index];
                return Card(
                  margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  child: ListTile(
                    leading: Icon(
                      task.isDone ? Icons.check_circle : Icons.radio_button_unchecked,
                      color: task.isDone ? Colors.green : null,
                    ),
                    title: Text(task.title),
                    subtitle: task.description.isEmpty ? null : Text(task.description),
                    trailing: const Icon(Icons.chevron_right),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
