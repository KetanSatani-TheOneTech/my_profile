import 'dart:io';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:my_profile_ketan/models/user_model.dart';
import 'package:my_profile_ketan/pages/home/widgets/common_edit_button.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:my_profile_ketan/utils/preference_keys.dart';

import '../../edit_profile/edit_profile_page.dart';


class UserInfoWidget extends StatefulWidget {
  const UserInfoWidget({super.key, required this.userModel});

  final ValueNotifier<UserModel> userModel;

  @override
  State<UserInfoWidget> createState() => _UserInfoWidgetState();
}

class _UserInfoWidgetState extends State<UserInfoWidget> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: ValueListenableBuilder(
        valueListenable: widget.userModel,
        builder: (context, value, child) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Stack(
                    children: [
                      if (widget.userModel.value.avatar.isEmpty) ...[
                        const CircleAvatar(
                          radius: 70,
                          backgroundImage: AssetImage('assets/images/user_placeholder.png'),
                        )
                      ] else ...[
                        CircleAvatar(
                          radius: 70,
                          backgroundImage: Image.file(File(widget.userModel.value.avatar)).image,
                        )
                      ],
                      Positioned(
                        /// 0 value is important here as it will indicate where to position from bottom side
                        bottom: 0,

                        /// 0 value is important here as it will indicate where to position from right side
                        right: 0,
                        child: CommonButton(
                          onClick: () {
                            var isBackEvent = Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const EditProfilePage(),
                              ),
                            );

                            if (isBackEvent.toString().isNotEmpty) {
                              updateUserModel();
                            }
                          },
                        ),
                      )
                    ],
                  )
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Gap(30),
                        const Text('Name:'),
                        Text(
                          widget.userModel.value.name,
                          maxLines: 3,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                  const Gap(20),
                  CommonButton(
                    onClick: () {
                      var isBackEvent = Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const EditProfilePage(),
                        ),
                      );

                      if (isBackEvent.toString().isNotEmpty) {
                        updateUserModel();
                      }
                    },
                  )
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Gap(30),
                        const Text('Email:'),
                        Text(
                          widget.userModel.value.email,
                          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                  const Gap(20),
                  CommonButton(
                    onClick: () {
                      var isBackEvent = Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const EditProfilePage(),
                        ),
                      );

                      if (isBackEvent.toString().isNotEmpty) {
                        updateUserModel();
                      }
                    },
                  )
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Gap(30),
                        const Text('Skills:'),
                        Text(
                          widget.userModel.value.skills,
                          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                  const Gap(20),
                  CommonButton(
                    onClick: () {
                      var isBackEvent = Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const EditProfilePage(),
                        ),
                      );

                      if (isBackEvent.toString().isNotEmpty) {
                        updateUserModel();
                      }
                    },
                  )
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Gap(30),
                        const Text('Work experience:'),
                        Text(
                          widget.userModel.value.workExperience,
                          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                  const Gap(20),
                  CommonButton(
                    onClick: () {
                      var isBackEvent = Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const EditProfilePage(),
                        ),
                      );

                      if (isBackEvent.toString().isNotEmpty) {
                        updateUserModel();
                      }
                    },
                  )
                ],
              ),
            ],
          );
        },
      ),
    );
  }

  Future<void> updateUserModel() async {
    final prefs = await SharedPreferences.getInstance();

    var email = prefs.getString(PreferenceKeys.keyUserEmail) ?? '';
    var name = prefs.getString(PreferenceKeys.keyUserName) ?? '';
    var skills = prefs.getString(PreferenceKeys.keyUserSkills) ?? '';
    var workExperience = prefs.getString(PreferenceKeys.keyUserWorkExperience) ?? '';
    var avatar = prefs.getString(PreferenceKeys.keyUserAvatarFilePath) ?? '';

    setState(() {
      widget.userModel.value = UserModel(
          email: email,
          name: name,
          avatar: avatar,
          skills: skills,
          workExperience: workExperience);
    });
  }
}
