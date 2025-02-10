import 'package:daily_task/di/service_locator.dart';
import 'package:daily_task/domain/repository/todo_repo.dart';
import 'package:daily_task/presentation/todo_page/cubit/todo_cubit.dart';
import 'package:daily_task/presentation/todo_page/ui/header_widget.dart';
import 'package:daily_task/presentation/todo_page/ui/tasks_list_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../cubit/header_cubit.dart';

class TodoPage extends StatefulWidget {
  const TodoPage({super.key});

  @override
  State<TodoPage> createState() => _TodoPageState();
}

class _TodoPageState extends State<TodoPage> {
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => HeaderCubit()),
        BlocProvider(create: (_) => TodoCubit(getIt<TodoRepo>())),
      ],
      child: const Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: Color(0xFFEEEEEE),
        body: Column(
          children: [
            HeaderWidget(),
            Expanded(
              child: TasksListWidget(),
            ),
          ],
        ),
      ),
    );
  }
}
