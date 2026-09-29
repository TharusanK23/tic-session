// ignore_for_file: avoid_print
// Day 1 practice file. Run with:  dart run practice/day1_dart_basics.dart
// (or paste into https://dartpad.dev)

class Task {
  final String id;
  final String title;
  final String description;
  final bool isDone;
  final DateTime createdAt;

  const Task({
    required this.id,
    required this.title,
    this.description = '',
    this.isDone = false,
    required this.createdAt,
  });

  Task copyWith({String? title, String? description, bool? isDone}) {
    return Task(
      id: id,
      title: title ?? this.title,
      description: description ?? this.description,
      isDone: isDone ?? this.isDone,
      createdAt: createdAt,
    );
  }

  @override
  String toString() => '[${isDone ? 'x' : ' '}] $title';
}

void main() async {
  // Variables and null safety
  const appName = 'TaskFlow';
  String? nickname;
  print('Welcome to $appName, ${nickname ?? 'friend'}!');

  // Lists and classes
  final tasks = <Task>[
    Task(id: '1', title: 'Learn Dart', createdAt: DateTime.now()),
    Task(id: '2', title: 'Install Flutter', createdAt: DateTime.now()),
    Task(id: '3', title: 'Build TaskFlow', createdAt: DateTime.now()),
  ];

  tasks[0] = tasks[0].copyWith(isDone: true); // immutable update
  final pending = tasks.where((t) => !t.isDone).toList();
  print('All: $tasks');
  print('Pending: ${pending.length}');
  print(describe(tasks.last, note: 'this week'));

  // Async: the restaurant token demo
  print('1. Order food');
  final food = cook();
  print('2. Talk with friends');
  print('3. ${await food}');

  try {
    final count = await fetchTaskCount();
    print('Server has $count tasks');
  } catch (e) {
    print('Error: $e');
  }
}

// Named optional parameter
String describe(Task task, {String? note}) =>
    note == null ? 'Task: ${task.title}' : 'Task: ${task.title} ($note)';

Future<String> cook() async {
  await Future.delayed(const Duration(seconds: 2));
  return 'Food is ready!';
}

Future<int> fetchTaskCount() async {
  await Future.delayed(const Duration(seconds: 1)); // simulate network
  return 42;
}
