import 'package:daily_task/presentation/todo_page/cubit/todo_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../domain/model/todo.dart';
import '../../../utils/date_time_util.dart';

class TasksListWidget extends StatefulWidget {
  const TasksListWidget({super.key});

  @override
  State<TasksListWidget> createState() => _TasksListWidgetState();
}

class _TasksListWidgetState extends State<TasksListWidget> {
  DateTime currentDay = DateTime.now();

  void showAddTodoBox() {
    final todoCubit = context.read<TodoCubit>();
    final textController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'Add new task',
          style: GoogleFonts.poppins(fontSize: 18),
        ),
        content: SizedBox(
          width: MediaQuery.of(context).size.width,
          child: TextFormField(
            autofocus: true,
            controller: textController,
            decoration: InputDecoration(
                border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
            )),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(
              'Cancel',
              style: GoogleFonts.poppins(fontWeight: FontWeight.normal),
            ),
          ),
          TextButton(
            onPressed: () {
              if (textController.text.isNotEmpty) {
                DateTime now = DateTime.now();
                todoCubit.addTodo(
                    text: textController.text,
                    day: DateTime(now.year, now.month, now.day));
                Navigator.of(context).pop();
              }
            },
            child: Text(
              'Add',
              style: GoogleFonts.poppins(fontWeight: FontWeight.normal),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _selectDate(BuildContext context) async {
    final todoCubit = context.read<TodoCubit>();

    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: currentDay,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );

    if (pickedDate != null) {
      todoCubit.loadTodosByDay(day: pickedDate);
      setState(() {
        currentDay = pickedDate;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: const Color(0xFFEEEEEE),
        body: Container(
          margin:
              const EdgeInsets.only(top: 36, bottom: 23, left: 20, right: 20),
          width: double.infinity,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SvgPicture.asset('assets/images/svg/clock.svg'),
              Container(
                margin: const EdgeInsets.only(top: 18, bottom: 8),
                width: double.infinity,
                child: Row(
                  children: [
                    Text(
                      'Task List',
                      style: GoogleFonts.poppins(
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                          fontSize: 22),
                      textAlign: TextAlign.start,
                    ),
                    const Spacer(),
                    IconButton(
                      icon: const Icon(Icons.calendar_month_rounded, size: 24),
                      onPressed: () => _selectDate(context),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        spreadRadius: 2,
                        blurRadius: 10,
                        offset: const Offset(4, 4),
                      ),
                    ],
                  ),
                  child: BlocBuilder<TodoCubit, List<Todo>>(
                    builder: (context, todos) {
                      return Column(
                        children: [
                          Padding(
                            padding:
                                const EdgeInsets.only(left: 21.0, right: 4),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  DateTimeUtil.formatDateTime(currentDay),
                                  style: GoogleFonts.poppins(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                    fontSize: 17,
                                  ),
                                ),
                                IconButton(
                                  icon: const Icon(
                                      Icons.add_circle_outline_rounded),
                                  iconSize: 24,
                                  color: const Color(0xFF56C5B6),
                                  onPressed: () => showAddTodoBox(),
                                ),
                              ],
                            ),
                          ),
                          Expanded(
                            child: todos.isEmpty
                                ? Center(
                                    child: Text(
                                      'Nothing to show',
                                      style: GoogleFonts.poppins(fontSize: 20),
                                    ),
                                  )
                                : ListView.builder(
                                    padding: const EdgeInsets.only(
                                        top: 0, bottom: 8),
                                    itemCount: todos.length,
                                    itemBuilder: (context, index) {
                                      final todo = todos[index];

                                      return Dismissible(
                                        key: Key(
                                          todo.id.toString(),
                                        ),
                                        direction: DismissDirection.endToStart,
                                        background: Container(
                                          alignment: Alignment.centerRight,
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 20),
                                          color: Colors.red,
                                          child: const Icon(Icons.delete,
                                              color: Colors.white),
                                        ),
                                        onDismissed: (direction) {
                                          context
                                              .read<TodoCubit>()
                                              .deleteTodo(todo: todo);
                                        },
                                        child: ListTile(
                                          horizontalTitleGap: 8,
                                          leading: Checkbox(
                                            onChanged: (value) {
                                              // Call to toggle
                                              context
                                                  .read<TodoCubit>()
                                                  .toggleCompletion(todo: todo);
                                            },
                                            value: todo.isCompleted,
                                            activeColor: Colors.green,
                                            checkColor: Colors.white,
                                          ),
                                          title: Text(
                                            todo.text,
                                            style: GoogleFonts.poppins(
                                              fontWeight: FontWeight.normal,
                                              fontSize: 15,
                                              color: todo.isCompleted
                                                  ? Colors.green
                                                  : const Color(0xCC000000),
                                            ),
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                          )
                        ],
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        ));
  }
}
