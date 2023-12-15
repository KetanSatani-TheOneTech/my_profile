import 'package:flutter/material.dart';
import 'package:my_profile_ketan/models/user_model.dart';
import 'package:my_profile_ketan/pages/login/login_page.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:my_profile_ketan/utils/preference_keys.dart';
import 'widgets/user_info_widget.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  SharedPreferences? prefs;
  ValueNotifier<UserModel> userModel =
      ValueNotifier(UserModel(email: '', name: '', avatar: '', skills: '', workExperience: ''));

  @override
  void initState() {
    super.initState();

    init();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: const Text('Home'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const LoginPage(),
                  ),
                  (route) => false);
            },
            child: Text(
              'Logout',
              style: TextStyle(color: Colors.red.shade400, fontWeight: FontWeight.bold),
            ),
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(18),
        child: UserInfoWidget(
          userModel: userModel,
        ),
      ),
    );
  }

  Future<void> init() async {
    prefs = await SharedPreferences.getInstance();

    var email = prefs?.getString(PreferenceKeys.keyUserEmail) ?? '';
    var name = prefs?.getString(PreferenceKeys.keyUserName) ?? '';
    var skills = prefs?.getString(PreferenceKeys.keyUserSkills) ?? '';
    var workExperience = prefs?.getString(PreferenceKeys.keyUserWorkExperience) ?? '';
    var avatar = prefs?.getString(PreferenceKeys.keyUserAvatarFilePath) ?? '';

    setState(() {
      userModel.value = UserModel(
          email: email,
          name: name,
          avatar: avatar,
          skills: skills,
          workExperience: workExperience);
    });

  }
}
