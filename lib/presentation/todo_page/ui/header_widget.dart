import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';

import '../cubit/header_cubit.dart';

class HeaderWidget extends StatelessWidget {
  const HeaderWidget({super.key});

  void showChangeNameBox(BuildContext context) {
    final headerCubit = context.read<HeaderCubit>();
    final textController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'Change user name',
          style: GoogleFonts.poppins(fontSize: 18),
        ),
        content: TextFormField(
          autofocus: true,
          controller: textController,
          decoration: InputDecoration(
            hintText: headerCubit.state.userName,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('Cancel', style: GoogleFonts.poppins()),
          ),
          TextButton(
            onPressed: () {
              if (textController.text.isNotEmpty) {
                headerCubit.saveUserName(textController.text);
              }
              Navigator.of(context).pop();
            },
            child: Text('Change', style: GoogleFonts.poppins()),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HeaderCubit, HeaderState>(
      builder: (context, state) {
        final cubit = context.read<HeaderCubit>();

        return Stack(
          children: [
            Container(
              color: const Color(0xFF62D2C3),
              width: double.infinity,
              height: MediaQuery.of(context).size.height / 3,
            ),
            SvgPicture.asset('assets/images/svg/cloud_light.svg'),
            Positioned(
              bottom: 15,
              left: 0,
              right: 0,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  GestureDetector(
                    onTap: () => cubit.pickImage(ImageSource.gallery),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(90),
                      child: state.avatarPath != null &&
                          File(state.avatarPath!).existsSync()
                          ? Image.file(
                        File(state.avatarPath!),
                        width: 100,
                        height: 100,
                        fit: BoxFit.cover,
                      )
                          : Image.asset(
                        'assets/images/png/default_avt.png',
                        width: 100,
                        height: 100,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  GestureDetector(
                    onTap: () => showChangeNameBox(context),
                    child: Text(
                      'Welcome, ${state.userName}!',
                      style: GoogleFonts.poppins(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        fontSize: 20,
                      ),
                    ),
                  )
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}
