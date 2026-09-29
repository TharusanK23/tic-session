import 'package:flutter_test/flutter_test.dart';
import 'package:taskflow/models/task.dart';
import 'package:taskflow/providers/task_provider.dart';
import 'package:taskflow/services/api_service.dart';
import 'package:taskflow/services/task_storage.dart';

class FakeStorage extends TaskStorage {
  List<Task> saved = [];

  @override
  Future<List<Task>> loadTasks() async => [];

  @override
  Future<void> saveTasks(List<Task> tasks) async => saved = List.of(tasks);
}

void main() {
  group('Task model', () {
    test('toJson and fromJson round trip', () {
      final task = Task(id: '1', title: 'Test', createdAt: DateTime(2026, 1, 1));
      final copy = Task.fromJson(task.toJson());
      expect(copy.id, task.id);
      expect(copy.title, task.title);
      expect(copy.createdAt, task.createdAt);
    });
  });

  group('TaskProvider', () {
    late FakeStorage storage;
    late TaskProvider provider;

    setUp(() {
      storage = FakeStorage();
      provider = TaskProvider(storage, ApiService());
    });

    test('addTask adds a task and saves it', () async {
      provider.addTask('Buy milk', '');
      await Future<void>.delayed(Duration.zero); // let the async save finish
      expect(provider.tasks.length, 1);
      expect(storage.saved.length, 1);
    });

    test('toggleDone updates remainingCount', () {
      provider.addTask('Buy milk', '');
      expect(provider.remainingCount, 1);
      provider.toggleDone(provider.tasks.first.id);
      expect(provider.remainingCount, 0);
    });

    test('filter shows only active tasks', () {
      provider.addTask('A', '');
      provider.addTask('B', '');
      provider.toggleDone(provider.tasks.first.id);
      provider.setFilter(TaskFilter.active);
      expect(provider.tasks.map((t) => t.title), ['B']);
    });
  });
}
