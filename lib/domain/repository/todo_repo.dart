import 'package:daily_task/domain/model/todo.dart';

abstract class TodoRepo {
  Future<List<Todo>> getAllTodos();

  Future<List<Todo>> getTodos({required DateTime time});

  Future<void> addTodo({required Todo newTodo});

  Future<void> updateTodo({required Todo todo});

  Future<void> deleteTodo({required Todo todo});
}
