class Question {
  final String uuid;
  final String title;
  final String question;

  Question({
    required this.uuid,
    required this.title,
    required this.question,
  });

  factory Question.fromJson(Map<String, dynamic> json) {
    return Question(
      uuid: json['uuid'],
      title: json['title'],
      question: json['question'],
    );
  }
}
