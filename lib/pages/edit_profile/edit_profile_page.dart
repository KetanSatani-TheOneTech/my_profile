import 'dart:io';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:image_picker/image_picker.dart';
import 'package:my_profile_ketan/models/user_model.dart';
import 'package:my_profile_ketan/utils/constants.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:my_profile_ketan/utils/preference_keys.dart';
import 'package:my_profile_ketan/utils/validators.dart';
import 'package:my_profile_ketan/providers/user_provider.dart';
import 'package:my_profile_ketan/pages/home/home_page.dart';

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({
    super.key,
  });

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final _formKey = GlobalKey<FormState>();
  String? password;
  ValueNotifier<String> savedImagePath = ValueNotifier('');
  SharedPreferences? prefs;
  ValueNotifier<UserModel> userModel =
      ValueNotifier(UserModel(email: '', name: '', avatar: '', skills: '', workExperience: ''));

  final userNameTextController = TextEditingController();
  final userEmailTextController = TextEditingController();
  final userSkillsTextController = TextEditingController();
  final userWorkExperienceTextController = TextEditingController();

  String? emailLoadedValue;
  String? nameLoadedValue;
  String? passwordLoadedValue;
  String? skillsLoadedValue;
  String? workExperienceLoadedValue;
  String? savedPathLoadedValue;

  @override
  void initState() {
    super.initState();
    init();
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        title: const Text('Edit Profile'),
        automaticallyImplyLeading: false,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            if (isDataChanged()) {
              //Show dialog
              _showDiscardChangesDialog(context);
            } else {
              Navigator.of(context).pop();
            }
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(18),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Stack(
                    children: [
                      ValueListenableBuilder(
                        valueListenable: savedImagePath,
                        builder: (context, value, child) {
                          if (savedImagePath.value.isEmpty) {
                            return const CircleAvatar(
                              radius: 70,
                              backgroundImage: AssetImage('assets/images/user_placeholder.png'),
                            );
                          } else {
                            return CircleAvatar(
                              radius: 70,
                              backgroundImage: Image.file(File(savedImagePath.value)).image,
                            );
                          }
                        },
                      ),
                      Positioned(
                        /// 0 value is important here as it will indicate where to position from bottom side
                        bottom: 0,

                        /// 0 value is important here as it will indicate where to position from right side
                        right: 0,
                        child: FilledButton(
                          style: FilledButton.styleFrom(minimumSize: const Size(50, 30)),
                          child: const Text('Edit'),
                          onPressed: () => pickImage(),
                        ),
                      )
                    ],
                  )
                ],
              ),
              Form(
                key: _formKey,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Gap(30),
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
                                  }
                                  return null;
                                },
                              ),
                            ],
                          ),
                        ),
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
                              TextFormField(
                                controller: userEmailTextController,
                                onTapOutside: (event) => FocusManager.instance.primaryFocus?.unfocus(),
                                autocorrect: false,
                                autovalidateMode: AutovalidateMode.onUserInteraction,
                                keyboardType: TextInputType.emailAddress,
                                textInputAction: TextInputAction.next,
                                decoration: InputDecoration(
                                  border: const UnderlineInputBorder(),
                                  labelText: Constants.userEmail,
                                ),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return Constants.userEmailEmptyValidationMessage;
                                  } else if (!Validators.validateEmail(value)) {
                                    return Constants.userEmailValidationMessage;
                                  }
                                  return null;
                                },
                              ),
                            ],
                          ),
                        ),
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
                              TextFormField(
                                controller: userSkillsTextController,
                                onTapOutside: (event) => FocusManager.instance.primaryFocus?.unfocus(),
                                autocorrect: false,
                                autovalidateMode: AutovalidateMode.onUserInteraction,
                                keyboardType: TextInputType.text,
                                textInputAction: TextInputAction.next,
                                decoration: InputDecoration(
                                  border: const UnderlineInputBorder(),
                                  labelText: Constants.userSkills,
                                ),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return Constants.userSkillsEmptyValidationMessage;
                                  }
                                  return null;
                                },
                              ),
                            ],
                          ),
                        ),
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
                              TextFormField(
                                controller: userWorkExperienceTextController,
                                onTapOutside: (event) => FocusManager.instance.primaryFocus?.unfocus(),
                                autocorrect: false,
                                autovalidateMode: AutovalidateMode.onUserInteraction,
                                keyboardType: TextInputType.emailAddress,
                                textInputAction: TextInputAction.done,
                                decoration: InputDecoration(
                                  border: const UnderlineInputBorder(),
                                  labelText: Constants.userWorkExperience,
                                ),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return Constants.userWorkEmptyValidationMessage;
                                  }
                                  return null;
                                },
                              ),
                            ],
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),

              const Gap(20),

              ///Save your data
              Container(
                width: double.infinity,
                margin: const EdgeInsets.symmetric(vertical: 20),
                child: FilledButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      userProvider.updateRememberMe(
                        value: userProvider.rememberMe.value,
                        username: userNameTextController.text,
                        email: userEmailTextController.text,
                        password: password ?? '',
                        skills: userSkillsTextController.text,
                        workExperience: userWorkExperienceTextController.text,
                        avatarFilePath: savedImagePath.value,
                      );

                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => const HomePage()),
                      );
                    }
                  },
                  child: Text(Constants.saveButton),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Future<void> init() async {
    prefs = await SharedPreferences.getInstance();
    var email = prefs?.getString(PreferenceKeys.keyUserEmail) ?? '';
    var name = prefs?.getString(PreferenceKeys.keyUserName) ?? '';
    password = prefs?.getString(PreferenceKeys.keyUserPassword) ?? '';
    var skills = prefs?.getString(PreferenceKeys.keyUserSkills) ?? '';
    var workExperience = prefs?.getString(PreferenceKeys.keyUserWorkExperience) ?? '';
    var avatar = prefs?.getString(PreferenceKeys.keyUserAvatarFilePath) ?? '';

    userModel.value =
        UserModel(email: email, name: name, avatar: avatar, skills: skills, workExperience: workExperience);

    setState(() {
      userNameTextController.text = userModel.value.name;
      userEmailTextController.text = userModel.value.email;
      userSkillsTextController.text = userModel.value.skills;
      userWorkExperienceTextController.text = userModel.value.workExperience;
      savedImagePath.value = avatar;
    });

    emailLoadedValue = email;
    nameLoadedValue = name;
    passwordLoadedValue = password ?? '';
    skillsLoadedValue = skills;
    workExperienceLoadedValue = workExperience;
    savedPathLoadedValue = savedImagePath.value;
  }

  bool isDataChanged() {
    if (emailLoadedValue != userEmailTextController.text ||
        nameLoadedValue != userNameTextController.text ||
        skillsLoadedValue != userSkillsTextController.text ||
        workExperienceLoadedValue != userWorkExperienceTextController.text ||
        savedPathLoadedValue != savedImagePath.value) {
      context.read<UserProvider>().updateOnDataChanges();
      return true;
    } else {
      return false;
    }
  }

  Future<void> pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);

    if (image == null) return;

    // Save the picked image to the device
    await saveImageToDevice(image.path);
  }

  Future<void> saveImageToDevice(String imagePath) async {
    final Directory appDocDir = await getApplicationDocumentsDirectory();
    final String appDocPath = appDocDir.path;
    final String fileName = '${DateTime.now().millisecondsSinceEpoch}.png';
    final String filePath = '$appDocPath/$fileName';

    // Copy the picked image to the app's documents directory
    await File(imagePath).copy(filePath);

    // Set the saved image path in the state
    setState(() {
      savedImagePath.value = filePath;
    });

    // Show a message or perform any other actions after saving the image
    debugPrint('Image saved to: $filePath');
  }

  Future<bool> _showDiscardChangesDialog(BuildContext context) async {
    return await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Discard Changes?'),
          content: const Text('Do you want to discard your changes?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context, true); // Discard changes
                Navigator.pop(context, true); // Discard changes
              },
              child: const Text('Yes'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context, false); // Continue editing
              },
              child: const Text('No'),
            ),
          ],
        );
      },
    );
  }
}
