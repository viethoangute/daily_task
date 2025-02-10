import 'package:daily_task/domain/repository/todo_repo.dart';
import 'package:daily_task/presentation/todo_page/cubit/todo_cubit.dart';
import 'package:daily_task/presentation/todo_page/ui/header_widget.dart';
import 'package:daily_task/presentation/todo_page/ui/tasks_list_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TodoPage extends StatefulWidget {
  final TodoRepo todoRepo;

  const TodoPage({super.key, required this.todoRepo});

  @override
  State<TodoPage> createState() => _TodoPageState();

}

class _TodoPageState extends State<TodoPage> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => TodoCubit(widget.todoRepo),
      child: const Scaffold(
          backgroundColor: Color(0xFFEEEEEE),
          body: Column(
            children: [
              HeaderWidget(),
              Expanded(
                child: TasksListWidget(),
              ),
            ],
          )),
    );
  }
}
