import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/task_provider.dart';
import '../widgets/task_tile.dart';
import 'add_edit_task_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<TaskProvider>();
    final tasks = provider.tasks;

    return Scaffold(
      appBar: AppBar(title: const Text('TaskFlow')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: SegmentedButton<TaskFilter>(
              segments: const [
                ButtonSegment(value: TaskFilter.all, label: Text('All')),
                ButtonSegment(value: TaskFilter.active, label: Text('Active')),
                ButtonSegment(value: TaskFilter.done, label: Text('Done')),
              ],
              selected: {provider.filter},
              onSelectionChanged: (selection) =>
                  context.read<TaskProvider>().setFilter(selection.first),
            ),
          ),
          Text('${provider.remainingCount} tasks remaining'),
          Expanded(
            child: provider.isLoading
                ? const Center(child: CircularProgressIndicator())
                : tasks.isEmpty
                    ? const Center(child: Text('No tasks yet. Tap + to add one.'))
                    : ListView.builder(
                        itemCount: tasks.length,
                        itemBuilder: (context, index) => TaskTile(task: tasks[index]),
                      ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        tooltip: 'Add task',
        onPressed: () => Navigator.of(context).push(
          MaterialPageRoute(builder: (_) => const AddEditTaskScreen()),
        ),
        child: const Icon(Icons.add),
      ),
    );
  }
}
