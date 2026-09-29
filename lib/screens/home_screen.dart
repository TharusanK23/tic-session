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
      appBar: AppBar(
        title: const Text('TaskFlow'),
        actions: [
          IconButton(
            tooltip: 'Import sample tasks',
            icon: const Icon(Icons.cloud_download_outlined),
            onPressed: provider.isLoading
                ? null
                : () => context.read<TaskProvider>().importSampleTasks(),
          ),
        ],
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 600),
          child: Column(
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
              if (provider.error != null)
                Padding(
                  padding: const EdgeInsets.all(8),
                  child: Text(
                    provider.error!,
                    style: TextStyle(color: Theme.of(context).colorScheme.error),
                  ),
                ),
              Expanded(
                child: provider.isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : tasks.isEmpty
                        ? const _EmptyState()
                        : ListView.builder(
                            itemCount: tasks.length,
                            itemBuilder: (context, index) => TaskTile(task: tasks[index]),
                          ),
              ),
            ],
          ),
        ),
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

class _EmptyState extends StatelessWidget {
  const _EmptyState();

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.inbox_outlined, size: 72, color: colors.outline),
          const SizedBox(height: 12),
          Text('No tasks yet', style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 4),
          Text('Tap + to add your first task', style: TextStyle(color: colors.outline)),
        ],
      ),
    );
  }
}
