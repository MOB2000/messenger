import 'dart:async';
import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:messenger/constants/colors.dart';
import 'package:messenger/constants/keys.dart';
import 'package:messenger/constants/strings.dart';
import 'package:messenger/constants/styles.dart';
import 'package:messenger/models/custom_user.dart';
import 'package:messenger/providers/auth_provider.dart';
import 'package:messenger/providers/setting_provider.dart';
import 'package:provider/provider.dart';

class SettingsScreen extends StatefulWidget {
  static const routeName = 'SettingsScreen';

  const SettingsScreen({Key? key}) : super(key: key);

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  late SettingProvider settingProvider;
  late CustomUser customUser;

  bool isLoading = false;
  File? avatarImageFile;

  final focusNodeNickname = FocusNode();
  final focusNodeAboutMe = FocusNode();
  final controllerNickname = TextEditingController();
  final controllerAboutMe = TextEditingController();

  @override
  Widget build(BuildContext context) {
    settingProvider = Provider.of<SettingProvider>(context);
    customUser = Provider.of<AuthProvider>(context).user;

    controllerNickname.text = customUser.nickname;
    controllerAboutMe.text = customUser.aboutMe;

    return Scaffold(
      appBar: AppBar(
        title: const Text(kSettings),
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            CupertinoButton(
              onPressed: getImage,
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: avatarImageFile == null
                    ? customUser.photoUrl.isNotEmpty
                        ? ClipRRect(
                            borderRadius: BorderRadius.circular(45),
                            child: Image.network(
                              customUser.photoUrl,
                              fit: BoxFit.cover,
                              width: 90,
                              height: 90,
                              errorBuilder: (context, object, stackTrace) {
                                return const Icon(
                                  Icons.account_circle,
                                  size: 90,
                                  color: kGreyColor,
                                );
                              },
                              loadingBuilder:
                                  (context, child, loadingProgress) {
                                if (loadingProgress == null) return child;
                                return SizedBox(
                                  width: 90,
                                  height: 90,
                                  child: Center(
                                    child: CircularProgressIndicator(
                                      color: kThemeColor,
                                      value:
                                          loadingProgress.expectedTotalBytes !=
                                                  null
                                              ? loadingProgress
                                                      .cumulativeBytesLoaded /
                                                  loadingProgress
                                                      .expectedTotalBytes!
                                              : null,
                                    ),
                                  ),
                                );
                              },
                            ),
                          )
                        : const Icon(
                            Icons.account_circle,
                            size: 90,
                            color: kGreyColor,
                          )
                    : ClipRRect(
                        borderRadius: BorderRadius.circular(45),
                        child: Image.file(
                          avatarImageFile!,
                          width: 90,
                          height: 90,
                          fit: BoxFit.cover,
                        ),
                      ),
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 10, horizontal: 5),
                  child: Text(
                    kNickname,
                    style: settingsLabelTextStyle,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 30),
                  child: Theme(
                    data:
                        Theme.of(context).copyWith(primaryColor: kPrimaryColor),
                    child: TextField(
                      decoration: const InputDecoration(
                        hintText: kSweetie,
                        contentPadding: EdgeInsets.all(5),
                        hintStyle: TextStyle(color: kGreyColor),
                      ),
                      controller: controllerNickname,
                      onChanged: (value) {
                        customUser.nickname = value;
                      },
                      focusNode: focusNodeNickname,
                    ),
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 10, horizontal: 5),
                  child: Text(
                    kAboutMe,
                    style: settingsLabelTextStyle,
                  ),
                ),
                Padding(
                  child: Theme(
                    data:
                        Theme.of(context).copyWith(primaryColor: kPrimaryColor),
                    child: TextField(
                      decoration: const InputDecoration(
                        hintText: kFun,
                        contentPadding: EdgeInsets.all(5),
                        hintStyle: TextStyle(color: kGreyColor),
                      ),
                      controller: controllerAboutMe,
                      onChanged: (value) {
                        customUser.aboutMe = value;
                      },
                      focusNode: focusNodeAboutMe,
                    ),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 30),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 50),
              child: ElevatedButton(
                child: const Text(kUpdate),
                onPressed: updateProfile,
              ),
            ),
          ],
        ),
        padding: const EdgeInsets.only(left: 15, right: 15),
      ),
    );
  }

  Future<void> getImage() async {
    final imagePicker = ImagePicker();
    final pickedFile = await imagePicker
        .pickImage(source: ImageSource.gallery)
        .catchError((err) {
      Fluttertoast.showToast(msg: err.toString());
    });

    if (pickedFile != null) {
      final image = File(pickedFile.path);

      setState(() {
        avatarImageFile = image;
        isLoading = true;
      });

      await uploadFile();
    }
  }

  Future<void> uploadFile() async {
    String fileName = customUser.id;

    try {
      TaskSnapshot snapshot =
          await settingProvider.putFile(fileName, avatarImageFile!);
      customUser.photoUrl = await snapshot.ref.getDownloadURL();

      settingProvider
          .updateDataFirestore(Keys.users, customUser.id, customUser.toMap())
          .then((data) async {
        setState(() {
          isLoading = false;
        });
        Fluttertoast.showToast(msg: kUploadSuccess);
      }).catchError((err) {
        setState(() {
          isLoading = false;
        });
        Fluttertoast.showToast(msg: err.toString());
      });
    } on FirebaseException catch (e) {
      setState(() {
        isLoading = false;
      });
      Fluttertoast.showToast(msg: e.message ?? e.toString());
    }
  }

  Future<void> updateProfile() async {
    focusNodeNickname.unfocus();
    focusNodeAboutMe.unfocus();

    setState(() {
      isLoading = true;
    });

    String toastMessage = kUpdateSuccess;
    try {
      await settingProvider.updateDataFirestore(
          Keys.users, customUser.id, customUser.toMap());
    } catch (e) {
      toastMessage = e.toString();
    } finally {
      isLoading = false;
      setState(() {});
      Fluttertoast.showToast(msg: toastMessage);
    }
  }
}
