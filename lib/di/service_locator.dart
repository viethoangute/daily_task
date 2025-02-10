import 'package:get_it/get_it.dart';
import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';

import '../data/model/isar_todo.dart';
import '../data/repository/isar_todo_repo.dart';
import '../domain/repository/todo_repo.dart';

final getIt = GetIt.instance;

Future<void> setupLocator() async {
  final dir = await getApplicationDocumentsDirectory();

  final isar = await Isar.open([TodoIsarSchema], directory: dir.path);

  getIt.registerSingleton<Isar>(isar);

  getIt.registerLazySingleton<TodoRepo>(() => IsarTodoRepo(getIt<Isar>()));
}
