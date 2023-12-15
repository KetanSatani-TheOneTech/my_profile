import 'package:flutter/cupertino.dart';
import 'package:my_profile_ketan/utils/preference_keys.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserProvider extends ChangeNotifier {
  ValueNotifier<bool> rememberMe = ValueNotifier(false);
  ValueNotifier<bool> isPasswordVisible = ValueNotifier(false);

  bool isDataChanged = false;

  void updateOnDataChanges() {
    isDataChanged = true;
    notifyListeners();
  }

  void updateRememberMe({
    required bool value,
    required String username,
    required String email,
    required String password,
    required String skills,
    required String workExperience,
    required String avatarFilePath,
  }) {
    rememberMe.value = value;
    notifyListeners();
    if (username.isNotEmpty && password.isNotEmpty) {
      SharedPreferences.getInstance().then(
        (prefs) {
          prefs.setBool(PreferenceKeys.keyRememberMe, rememberMe.value);

          prefs.setString(PreferenceKeys.keyUserName, username);
          prefs.setString(PreferenceKeys.keyUserEmail, email);
          prefs.setString(PreferenceKeys.keyUserPassword, password);
          prefs.setString(PreferenceKeys.keyUserSkills, skills);
          prefs.setString(PreferenceKeys.keyUserWorkExperience, workExperience);
          prefs.setString(PreferenceKeys.keyUserAvatarFilePath, avatarFilePath);
        },
      );
    }
  }
}
