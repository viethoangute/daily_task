import 'package:isar/isar.dart';

import '../../domain/model/todo.dart';

part 'isar_todo.g.dart';

@collection
class TodoIsar {
  Id id = Isar.autoIncrement;
  late String text;
  late bool isCompleted;
  late DateTime date;

  Todo toDomain() {
    return Todo(
      id: id,
      text: text,
      isCompleted: isCompleted,
      date: date,
    );
  }

  static TodoIsar fromDomain(Todo todo) {
    return TodoIsar()
      ..id = todo.id
      ..text = todo.text
      ..isCompleted = todo.isCompleted
      ..date = DateTime(todo.date.year, todo.date.month, todo.date.day);
  }
}
