class Course {
  final String id;
  String code;
  String title;
  String description;
  int credits;
  String instructor;

  Course({
    required this.id,
    required this.code,
    required this.title,
    required this.description,
    required this.credits,
    required this.instructor,
  });

  Course copyWith({
    String? code,
    String? title,
    String? description,
    int? credits,
    String? instructor,
  }) {
    return Course(
      id: id,
      code: code ?? this.code,
      title: title ?? this.title,
      description: description ?? this.description,
      credits: credits ?? this.credits,
      instructor: instructor ?? this.instructor,
    );
  }
}
