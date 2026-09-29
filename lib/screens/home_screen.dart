import 'package:flutter/material.dart';
import '../models/task.dart';
import 'add_edit_task_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final List<Task> _tasks = [];

  int get _remaining => _tasks.where((t) => !t.isDone).length;

  void _toggle(Task task) {
    setState(() {
      final index = _tasks.indexWhere((t) => t.id == task.id);
      _tasks[index] = task.copyWith(isDone: !task.isDone);
    });
  }

  Future<void> _openAddScreen() async {
    final newTask = await Navigator.of(context).push<Task>(
      MaterialPageRoute(builder: (_) => const AddEditTaskScreen()),
    );
    if (newTask == null || !mounted) return; // user pressed back, or screen gone
    setState(() => _tasks.add(newTask));
  }

  Future<void> _openEditScreen(Task task) async {
    final updated = await Navigator.of(context).push<Task>(
      MaterialPageRoute(builder: (_) => AddEditTaskScreen(task: task)),
    );
    if (updated == null || !mounted) return;
    setState(() {
      final index = _tasks.indexWhere((t) => t.id == updated.id);
      _tasks[index] = updated;
    });
  }

  Future<bool> _confirmDelete(Task task) async {
    final result = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete task?'),
        content: Text('"${task.title}" will be removed.'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Cancel')),
          FilledButton(onPressed: () => Navigator.pop(context, true), child: const Text('Delete')),
        ],
      ),
    );
    return result ?? false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('TaskFlow ($_remaining left)')),
      body: _tasks.isEmpty
          ? const Center(child: Text('No tasks yet. Tap + to add one.'))
          : ListView.builder(
              itemCount: _tasks.length,
              itemBuilder: (context, index) {
                final task = _tasks[index];
                return Dismissible(
                  key: ValueKey(task.id),
                  direction: DismissDirection.endToStart,
                  confirmDismiss: (_) => _confirmDelete(task),
                  background: Container(
                    color: Colors.red,
                    alignment: Alignment.centerRight,
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: const Icon(Icons.delete, color: Colors.white),
                  ),
                  onDismissed: (_) {
                    setState(() => _tasks.removeWhere((t) => t.id == task.id));
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Deleted "${task.title}"')),
                    );
                  },
                  child: ListTile(
                    leading: Checkbox(
                      value: task.isDone,
                      onChanged: (_) => _toggle(task),
                    ),
                    title: Text(
                      task.title,
                      style: TextStyle(
                        decoration: task.isDone ? TextDecoration.lineThrough : null,
                      ),
                    ),
                    subtitle: task.description.isEmpty ? null : Text(task.description),
                    onTap: () => _openEditScreen(task),
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: _openAddScreen,
        child: const Icon(Icons.add),
      ),
    );
  }
}
