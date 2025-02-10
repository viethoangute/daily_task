class Todo {
  final int id;
  final String text;
  final bool isCompleted;
  final DateTime date;

  Todo(
      {required this.id,
      required this.text,
      this.isCompleted = false,
      required this.date});

  Todo toggleCompletion() {
    return Todo(id: id, text: text, isCompleted: !isCompleted, date: date);
  }
}
