import 'dart:io';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HeaderState {
  final String? avatarPath;
  final String userName;

  HeaderState({this.avatarPath, this.userName = 'User'});

  HeaderState copyWith({String? avatarPath, String? userName}) {
    return HeaderState(
      avatarPath: avatarPath ?? this.avatarPath,
      userName: userName ?? this.userName,
    );
  }
}

class HeaderCubit extends Cubit<HeaderState> {
  HeaderCubit() : super(HeaderState());

  Future<void> loadUserData() async {
    final prefs = await SharedPreferences.getInstance();
    final savedPath = prefs.getString('avatar_path');
    final userName = prefs.getString('user_name') ?? 'User';

    emit(state.copyWith(
      avatarPath: savedPath,
      userName: userName,
    ));
  }

  Future<void> pickImage(ImageSource source) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: source);

    if (pickedFile != null) {
      File imageFile = File(pickedFile.path);
      String savedPath = await _saveImageToStorage(imageFile);

      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('avatar_path', savedPath);

      emit(state.copyWith(avatarPath: savedPath));
    }
  }

  Future<String> _saveImageToStorage(File imageFile) async {
    final directory = await getApplicationDocumentsDirectory();

    // Delete old avatar if it exists
    if (state.avatarPath != null) {
      final oldFile = File(state.avatarPath!);
      if (oldFile.existsSync()) {
        await oldFile.delete();
      }
    }

    // Generate a unique filename
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    final newPath = '${directory.path}/avatar_$timestamp.png';

    await imageFile.copy(newPath);
    return newPath;
  }

  void saveUserName(String name) async {
    if (name.isEmpty) return;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('user_name', name);
    emit(state.copyWith(userName: name));
  }
}

