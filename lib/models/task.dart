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

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'description': description,
        'isDone': isDone,
        'createdAt': createdAt.toIso8601String(),
      };

  factory Task.fromJson(Map<String, dynamic> json) => Task(
        id: json['id'] as String,
        title: json['title'] as String,
        description: json['description'] as String? ?? '',
        isDone: json['isDone'] as bool? ?? false,
        createdAt: DateTime.parse(json['createdAt'] as String),
      );
}
