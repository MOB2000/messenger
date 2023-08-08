import 'dart:async';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:messenger/constants/colors.dart';
import 'package:messenger/constants/keys.dart';
import 'package:messenger/constants/strings.dart';
import 'package:messenger/constants/styles.dart';
import 'package:messenger/models/custom_user.dart';
import 'package:messenger/providers/auth_provider.dart';
import 'package:messenger/providers/setting_provider.dart';
import 'package:messenger/services/image_pick.dart';
import 'package:messenger/utils/utilities.dart';
import 'package:messenger/widgets/profile_image.dart';
import 'package:provider/provider.dart';

class SettingsScreen extends StatefulWidget {
  static const routeName = 'SettingsScreen';

  const SettingsScreen({Key? key}) : super(key: key);

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final profileFormKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final settingProvider = Provider.of<SettingProvider>(context);
    final customUser = Provider.of<MyAuthProvider>(context).user;

    return Scaffold(
      appBar: AppBar(
        title: const Text(kSettings),
      ),
      body: Form(
        key: profileFormKey,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Center(
                  child: CupertinoButton(
                    onPressed: () => getImage(settingProvider, customUser),
                    child: ProfileImage(
                      photoUrl: customUser.photoUrl,
                      size: 90,
                    ),
                  ),
                ),
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
                    child: TextFormField(
                      initialValue: customUser.nickname,
                      decoration: const InputDecoration(
                        hintText: kSweetie,
                        contentPadding: EdgeInsets.all(5),
                        hintStyle: TextStyle(color: kGreyColor),
                      ),
                      validator: (value) {
                        if (value!.trim().isEmpty) {
                          return kEnterValue;
                        }
                        return null;
                      },
                      onSaved: (value) {
                        customUser.nickname = value!;
                      },
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 10, horizontal: 5),
                  child: Text(
                    kAboutMe,
                    style: settingsLabelTextStyle,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 30),
                  child: Theme(
                    data:
                        Theme.of(context).copyWith(primaryColor: kPrimaryColor),
                    child: TextFormField(
                      initialValue: customUser.aboutMe,
                      decoration: const InputDecoration(
                        hintText: kFun,
                        contentPadding: EdgeInsets.all(5),
                        hintStyle: TextStyle(color: kGreyColor),
                      ),
                      onSaved: (value) {
                        customUser.aboutMe = value ?? '';
                      },
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 50),
                  child: Center(
                    child: ElevatedButton(
                      child: const Text(kUpdate),
                      onPressed: () =>
                          updateProfile(settingProvider, customUser),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> getImage(
    SettingProvider settingProvider,
    CustomUser customUser,
  ) async {
    final imageFile = await ImagePick.instance.pickImageGallery();

    if (imageFile != null) {
      showWaitingDialog(
        context,
        () => uploadImage(settingProvider, customUser, imageFile),
      );
      setState(() {});
    }
  }

  Future<void> uploadImage(
    SettingProvider settingProvider,
    CustomUser customUser,
    File imageFile,
  ) async {
    try {
      final snapshot = await settingProvider.putFile(customUser.id, imageFile);
      customUser.photoUrl = await snapshot.ref.getDownloadURL();

      settingProvider
          .updateDataFirestore(Keys.users, customUser.id, customUser.toMap())
          .then((data) async {
        Fluttertoast.showToast(msg: kUploadSuccess);
      }).catchError(
        (err) {
          Fluttertoast.showToast(msg: err.toString());
        },
      );
    } catch (e) {
      Fluttertoast.showToast(msg: e.toString());
    }
    setState(() {});
  }

  Future<void> updateProfile(
    SettingProvider settingProvider,
    CustomUser customUser,
  ) async {
    if (!profileFormKey.currentState!.validate()) {
      return;
    }
    profileFormKey.currentState!.save();
    showWaitingDialog(
      context,
      () async {
        String toastMessage = kUpdateSuccess;
        try {
          await settingProvider.updateDataFirestore(
            Keys.users,
            customUser.id,
            customUser.toMap(),
          );
        } catch (e) {
          toastMessage = e.toString();
        }
        Fluttertoast.showToast(msg: toastMessage);
      },
    );
    setState(() {});
  }
}
