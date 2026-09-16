class Student {
  final String id;
  final String name;
  final DateTime createdAt;

  const Student({
    required this.id,
    required this.name,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  factory Student.fromMap(Map<dynamic, dynamic> map) {
    return Student(
      id: map['id']?.toString() ?? '',
      name: map['name']?.toString() ?? '',
      createdAt: DateTime.tryParse(
        map['createdAt']?.toString() ?? '',
      ) ??
          DateTime.now(),
    );
  }
}