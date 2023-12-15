import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:my_profile_ketan/pages/home/home_page.dart';
import 'package:my_profile_ketan/providers/user_provider.dart';
import 'package:my_profile_ketan/utils/constants.dart';
import 'package:my_profile_ketan/utils/validators.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:my_profile_ketan/utils/preference_keys.dart';

class LoginFormWidget extends StatefulWidget {
  const LoginFormWidget({super.key});

  @override
  State<LoginFormWidget> createState() => _LoginFormWidgetState();
}

class _LoginFormWidgetState extends State<LoginFormWidget> {
  final _formKey = GlobalKey<FormState>();
  final userNameTextController = TextEditingController();
  final passwordTextController = TextEditingController();
  String? avatar;
  String? skills;
  String? workExperience;

  @override
  void initState() {
    super.initState();
    _loadUserEmailPassword();
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    return Form(
      key: _formKey,
      child: Column(
        children: [
          ///Greeting title for the user
          Text(
            Constants.loginGreetingTitle,
            style: TextStyle(color: Colors.grey.shade700),
          ),

          ///This widgets adds vertical space between two widgets
          const Gap(10),

          ///Username widget
          TextFormField(
            controller: userNameTextController,
            onTapOutside: (event) => FocusManager.instance.primaryFocus?.unfocus(),
            autocorrect: false,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            keyboardType: TextInputType.emailAddress,
            textInputAction: TextInputAction.next,
            decoration: InputDecoration(
              border: const UnderlineInputBorder(),
              labelText: Constants.userName,
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return Constants.userNameEmptyValidationMessage;
              } else if (!Validators.validateEmail(value)) {
                return Constants.userNameValidationMessage;
              }
              return null;
            },
          ),

          ///This widgets adds vertical space between two widgets
          const Gap(10),

          ///Password widget
          ValueListenableBuilder(
            valueListenable: userProvider.isPasswordVisible,
            builder: (context, value, child) {
              return TextFormField(
                controller: passwordTextController,
                onTapOutside: (event) => FocusManager.instance.primaryFocus?.unfocus(),
                autocorrect: false,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                keyboardType: TextInputType.text,
                textInputAction: TextInputAction.done,
                obscureText: userProvider.isPasswordVisible.value,
                decoration: InputDecoration(
                  border: const UnderlineInputBorder(),
                  labelText: Constants.password,
                  suffixIcon: IconButton(
                    icon: Icon(
                      userProvider.isPasswordVisible.value ? Icons.visibility : Icons.visibility_off,
                      color: Colors.grey.shade700,
                    ),
                    onPressed: () {
                      userProvider.isPasswordVisible.value = !userProvider.isPasswordVisible.value;
                    },
                  ),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return Constants.userPasswordEmptyValidationMessage;
                  }
                  return null;
                },
              );
            },
          ),

          const Gap(20),

          ///Remember me widget
          Consumer<UserProvider>(
            builder: (context, value, child) {
              return GestureDetector(
                onTap: () {
                  value.updateRememberMe(
                    value: !value.rememberMe.value,
                    username: userNameTextController.text.split('@').first,
                    email: userNameTextController.text,
                    password: passwordTextController.text,
                    skills: '',
                    workExperience: '',
                    avatarFilePath: '',
                  );
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: 20,
                      height: 20,
                      child: Checkbox(
                          value: value.rememberMe.value,
                          onChanged: (changedValue) {
                            value.updateRememberMe(
                              value: !value.rememberMe.value,
                              username: userNameTextController.text.split('@').first,
                              email: userNameTextController.text,
                              password: passwordTextController.text,
                              skills: '',
                              workExperience: '',
                              avatarFilePath: '',
                            );
                          }),
                    ),
                    const Gap(10),
                    const Text('Remember me')
                  ],
                ),
              );
            },
          ),

          const Gap(10),

          ///Submit login values widget
          Container(
            width: double.infinity,
            margin: const EdgeInsets.symmetric(vertical: 20),
            child: FilledButton(
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  userProvider.updateRememberMe(
                    value: userProvider.rememberMe.value,
                    username: userNameTextController.text.split('@').first,
                    email: userNameTextController.text,
                    password: passwordTextController.text,
                    skills: skills??'',
                    workExperience: workExperience??'',
                    avatarFilePath: avatar??'',
                  );
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => const HomePage()),
                  );
                }
              },
              child: Text(Constants.submitButton),
            ),
          )
        ],
      ),
    );
  }

  void _loadUserEmailPassword() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();

      var email = prefs.getString(PreferenceKeys.keyUserEmail) ?? '';
      var name = prefs.getString(PreferenceKeys.keyUserName) ?? '';
      var password = prefs.getString(PreferenceKeys.keyUserPassword) ?? "";
      var rememberMe = prefs.getBool(PreferenceKeys.keyRememberMe) ?? false;
      avatar = prefs.getString(PreferenceKeys.keyUserAvatarFilePath) ?? '';
      skills = prefs.getString(PreferenceKeys.keyUserSkills) ?? '';
      workExperience = prefs.getString(PreferenceKeys.keyUserWorkExperience) ?? '';

      if (rememberMe) {
        if (context.mounted) {
          context.read<UserProvider>().updateRememberMe(
                value: rememberMe,
                username: name,
                email: email,
                password: password,
                skills: skills??'',
                workExperience: workExperience??'',
                avatarFilePath: avatar??'',
              );
          userNameTextController.text = email;
          passwordTextController.text = password;
        }
      }
    } catch (e) {
      debugPrint(e.toString());
    }
  }
}
