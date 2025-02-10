import 'package:daily_task/domain/model/todo.dart';
import 'package:daily_task/domain/repository/todo_repo.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TodoCubit extends Cubit<List<Todo>> {
  final TodoRepo todoRepo;

  TodoCubit(this.todoRepo) : super([]) {
    loadTodayTodos();
  }

  Future<void> loadTodayTodos() async {
    final DateTime now = DateTime.now();
    final DateTime today = DateTime(now.year, now.month, now.day);
    loadTodosByDay(day: today);
  }

  Future<void> loadTodosByDay({required DateTime day}) async {
    final todoList = await todoRepo.getTodos(time: day);
    emit(todoList);
  }

  Future<void> addTodo({required String text, required DateTime day}) async {
    final newTodo = Todo(
        id: DateTime.now().microsecondsSinceEpoch,
        text: text,
        date: DateTime(day.year, day.month, day.day));

    await todoRepo.addTodo(newTodo: newTodo);
    loadTodosByDay(day: day);
  }

  Future<void> deleteTodo({required Todo todo}) async {
    await todoRepo.deleteTodo(todo: todo);
    loadTodosByDay(day: todo.date);
  }

  Future<void> toggleCompletion({required Todo todo}) async {
    final updatedTodo = todo.toggleCompletion();
    await todoRepo.updateTodo(todo: updatedTodo);
    loadTodosByDay(day: updatedTodo.date);
  }
}
