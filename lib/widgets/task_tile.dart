import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/task.dart';
import '../providers/task_provider.dart';
import '../screens/add_edit_task_screen.dart';

class TaskTile extends StatelessWidget {
  const TaskTile({super.key, required this.task});

  final Task task;

  @override
  Widget build(BuildContext context) {
    final provider = context.read<TaskProvider>();

    return Dismissible(
      key: ValueKey(task.id),
      direction: DismissDirection.endToStart,
      background: Container(
        color: Colors.red,
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: const Icon(Icons.delete, color: Colors.white),
      ),
      onDismissed: (_) {
        final messenger = ScaffoldMessenger.of(context);
        provider.deleteTask(task.id);
        messenger.showSnackBar(SnackBar(content: Text('Deleted "${task.title}"')));
      },
      child: ListTile(
        leading: Checkbox(
          value: task.isDone,
          onChanged: (_) => provider.toggleDone(task.id),
        ),
        title: Text(
          task.title,
          style: TextStyle(
            decoration: task.isDone ? TextDecoration.lineThrough : null,
          ),
        ),
        subtitle: task.description.isEmpty
            ? null
            : Text(task.description, maxLines: 1, overflow: TextOverflow.ellipsis),
        onTap: () => Navigator.of(context).push(
          MaterialPageRoute(builder: (_) => AddEditTaskScreen(task: task)),
        ),
      ),
    );
  }
}
