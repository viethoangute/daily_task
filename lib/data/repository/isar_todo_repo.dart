import 'package:daily_task/data/model/isar_todo.dart';
import 'package:daily_task/domain/model/todo.dart';
import 'package:daily_task/domain/repository/todo_repo.dart';
import 'package:isar/isar.dart';

class IsarTodoRepo implements TodoRepo {
  final Isar db;

  IsarTodoRepo(this.db);

  @override
  Future<List<Todo>> getAllTodos() async {
    final todos = await db.todoIsars.where().findAll();
    return todos.map((todoIsar) => todoIsar.toDomain()).toList();
  }

  @override
  Future<List<Todo>> getTodos({required DateTime time}) async {
    final normalizedDate = DateTime(time.year, time.month, time.day);

    final todos =
        await db.todoIsars.filter().dateEqualTo(normalizedDate).findAll();

    return todos.map((todoIsar) => todoIsar.toDomain()).toList();
  }

  @override
  Future<void> addTodo({required Todo newTodo}) async {
    final todoIsar = TodoIsar.fromDomain(newTodo);
    return db.writeTxn(() => db.todoIsars.put(todoIsar));
  }

  @override
  Future<void> updateTodo({required Todo todo}) async {
    final todoIsar = TodoIsar.fromDomain(todo);
    return db.writeTxn(() => db.todoIsars.put(todoIsar));
  }

  @override
  Future<void> deleteTodo({required Todo todo}) async {
    await db.writeTxn(() => db.todoIsars.delete(todo.id));
  }
}
