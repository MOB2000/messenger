import 'dart:async';
import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
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
import 'package:messenger/widgets/profile_image.dart';
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

  // TODO: use form
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
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          CupertinoButton(
            onPressed: getImage,
            child: ProfileImage(
              photoUrl: customUser.photoUrl,
              size: 90,
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
                  data: Theme.of(context).copyWith(primaryColor: kPrimaryColor),
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
                  data: Theme.of(context).copyWith(primaryColor: kPrimaryColor),
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
    );
  }

  Future<void> getImage() async {
    final image = await ImagePick.instance.pickImageGallery();
    if (image != null) {
      setState(() {
        avatarImageFile = image;
        isLoading = true;
      });

      await uploadFile();
    }
    setState(() {});
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
        Keys.users,
        customUser.id,
        customUser.toMap(),
      );
    } catch (e) {
      toastMessage = e.toString();
    } finally {
      setState(() {
        isLoading = false;
      });
      Fluttertoast.showToast(msg: toastMessage);
    }
  }
}
