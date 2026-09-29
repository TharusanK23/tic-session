import 'package:flutter/foundation.dart';
import '../models/task.dart';
import '../services/task_storage.dart';

enum TaskFilter { all, active, done }

class TaskProvider extends ChangeNotifier {
  TaskProvider(this._storage);

  final TaskStorage _storage;

  List<Task> _tasks = [];
  TaskFilter _filter = TaskFilter.all;
  bool _isLoading = false;

  TaskFilter get filter => _filter;
  bool get isLoading => _isLoading;
  int get remainingCount => _tasks.where((t) => !t.isDone).length;

  List<Task> get tasks => switch (_filter) {
        TaskFilter.all => List.unmodifiable(_tasks),
        TaskFilter.active => _tasks.where((t) => !t.isDone).toList(),
        TaskFilter.done => _tasks.where((t) => t.isDone).toList(),
      };

  Future<void> loadTasks() async {
    _isLoading = true;
    notifyListeners();
    _tasks = await _storage.loadTasks();
    _isLoading = false;
    notifyListeners();
  }

  void addTask(String title, String description) {
    _tasks.add(Task(
      id: DateTime.now().microsecondsSinceEpoch.toString(),
      title: title,
      description: description,
      createdAt: DateTime.now(),
    ));
    _saveAndNotify();
  }

  void updateTask(Task updated) {
    final index = _tasks.indexWhere((t) => t.id == updated.id);
    if (index == -1) return;
    _tasks[index] = updated;
    _saveAndNotify();
  }

  void toggleDone(String id) {
    final index = _tasks.indexWhere((t) => t.id == id);
    if (index == -1) return;
    _tasks[index] = _tasks[index].copyWith(isDone: !_tasks[index].isDone);
    _saveAndNotify();
  }

  void deleteTask(String id) {
    _tasks.removeWhere((t) => t.id == id);
    _saveAndNotify();
  }

  void setFilter(TaskFilter filter) {
    _filter = filter;
    notifyListeners();
  }

  void _saveAndNotify() {
    notifyListeners();
    _storage.saveTasks(_tasks);
  }
}
