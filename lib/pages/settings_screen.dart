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
import 'package:messenger/models/custom_user.dart';
import 'package:messenger/providers/setting_provider.dart';
import 'package:messenger/widgets/loading_view.dart';
import 'package:provider/provider.dart';

class SettingsScreen extends StatelessWidget {
  static const routeName = 'SettingsScreen';

  const SettingsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          kSettings,
          style: TextStyle(color: kPrimaryColor),
        ),
        centerTitle: true,
      ),
      body: const SettingsPageState(),
    );
  }
}

class SettingsPageState extends StatefulWidget {
  const SettingsPageState({Key? key}) : super(key: key);

  @override
  State createState() => SettingsPageStateState();
}

class SettingsPageStateState extends State<SettingsPageState> {
  TextEditingController? controllerNickname;
  TextEditingController? controllerAboutMe;

  String id = '';
  String nickname = '';
  String aboutMe = '';
  String photoUrl = '';

  bool isLoading = false;
  File? avatarImageFile;
  late SettingProvider settingProvider;

  final FocusNode focusNodeNickname = FocusNode();
  final FocusNode focusNodeAboutMe = FocusNode();

  @override
  void initState() {
    super.initState();
    settingProvider = Provider.of<SettingProvider>(context);
    readLocal();
  }

  void readLocal() {
    setState(() {
      id = settingProvider.getPref(Keys.id);
      nickname = settingProvider.getPref(Keys.nickname);
      aboutMe = settingProvider.getPref(Keys.aboutMe);
      photoUrl = settingProvider.getPref(Keys.photoUrl);
    });

    controllerNickname = TextEditingController(text: nickname);
    controllerAboutMe = TextEditingController(text: aboutMe);
  }

  Future getImage() async {
    ImagePicker imagePicker = ImagePicker();
    final pickedFile = await imagePicker
        .pickImage(source: ImageSource.gallery)
        .catchError((err) {
      Fluttertoast.showToast(msg: err.toString());
    });
    File? image;
    if (pickedFile != null) {
      image = File(pickedFile.path);
    }
    if (image != null) {
      setState(() {
        avatarImageFile = image;
        isLoading = true;
      });
      uploadFile();
    }
  }

  Future uploadFile() async {
    String fileName = id;
    UploadTask uploadTask =
        settingProvider.uploadFile(avatarImageFile!, fileName);
    try {
      TaskSnapshot snapshot = await uploadTask;
      photoUrl = await snapshot.ref.getDownloadURL();
      CustomUser updateInfo = CustomUser(
        id: id,
        photoUrl: photoUrl,
        nickname: nickname,
        aboutMe: aboutMe,
      );
      settingProvider
          .updateDataFirestore(Keys.pathUserCollection, id, updateInfo.toMap())
          .then((data) async {
        await settingProvider.setPref(Keys.photoUrl, photoUrl);
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

  void handleUpdateData() {
    focusNodeNickname.unfocus();
    focusNodeAboutMe.unfocus();

    setState(() {
      isLoading = true;
    });
    CustomUser updateInfo = CustomUser(
      id: id,
      photoUrl: photoUrl,
      nickname: nickname,
      aboutMe: aboutMe,
    );
    settingProvider
        .updateDataFirestore(Keys.pathUserCollection, id, updateInfo.toMap())
        .then((data) async {
      await settingProvider.setPref(Keys.nickname, nickname);
      await settingProvider.setPref(Keys.aboutMe, aboutMe);
      await settingProvider.setPref(Keys.photoUrl, photoUrl);

      setState(() {
        isLoading = false;
      });

      Fluttertoast.showToast(msg: kUpdateSuccess);
    }).catchError((err) {
      setState(() {
        isLoading = false;
      });

      Fluttertoast.showToast(msg: err.toString());
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              CupertinoButton(
                onPressed: getImage,
                child: Container(
                  margin: const EdgeInsets.all(20),
                  child: avatarImageFile == null
                      ? photoUrl.isNotEmpty
                          ? ClipRRect(
                              borderRadius: BorderRadius.circular(45),
                              child: Image.network(
                                photoUrl,
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
                                loadingBuilder: (BuildContext context,
                                    Widget child,
                                    ImageChunkEvent? loadingProgress) {
                                  if (loadingProgress == null) return child;
                                  return SizedBox(
                                    width: 90,
                                    height: 90,
                                    child: Center(
                                      child: CircularProgressIndicator(
                                        color: kThemeColor,
                                        value: loadingProgress
                                                    .expectedTotalBytes !=
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
                children: <Widget>[
                  Container(
                    child: const Text(
                      kNickname,
                      style: TextStyle(
                          fontStyle: FontStyle.italic,
                          fontWeight: FontWeight.bold,
                          color: kPrimaryColor),
                    ),
                    margin: const EdgeInsets.only(left: 10, bottom: 5, top: 10),
                  ),
                  Container(
                    child: Theme(
                      data: Theme.of(context)
                          .copyWith(primaryColor: kPrimaryColor),
                      child: TextField(
                        decoration: const InputDecoration(
                          hintText: kSweetie,
                          contentPadding: EdgeInsets.all(5),
                          hintStyle: TextStyle(color: kGreyColor),
                        ),
                        controller: controllerNickname,
                        onChanged: (value) {
                          nickname = value;
                        },
                        focusNode: focusNodeNickname,
                      ),
                    ),
                    margin: const EdgeInsets.only(left: 30, right: 30),
                  ),
                  Container(
                    child: const Text(
                      kAboutMe,
                      style: TextStyle(
                          fontStyle: FontStyle.italic,
                          fontWeight: FontWeight.bold,
                          color: kPrimaryColor),
                    ),
                    margin: const EdgeInsets.only(left: 10, top: 30, bottom: 5),
                  ),
                  Container(
                    child: Theme(
                      data: Theme.of(context)
                          .copyWith(primaryColor: kPrimaryColor),
                      child: TextField(
                        decoration: const InputDecoration(
                          hintText: kFun,
                          contentPadding: EdgeInsets.all(5),
                          hintStyle: TextStyle(color: kGreyColor),
                        ),
                        controller: controllerAboutMe,
                        onChanged: (value) {
                          aboutMe = value;
                        },
                        focusNode: focusNodeAboutMe,
                      ),
                    ),
                    margin: const EdgeInsets.only(left: 30, right: 30),
                  ),
                ],
                crossAxisAlignment: CrossAxisAlignment.start,
              ),
              Container(
                child: TextButton(
                  onPressed: handleUpdateData,
                  child: const Text(
                    kUpdate,
                    style: TextStyle(fontSize: 16, color: Colors.white),
                  ),
                  style: ButtonStyle(
                    backgroundColor:
                        MaterialStateProperty.all<Color>(kPrimaryColor),
                    padding: MaterialStateProperty.all<EdgeInsets>(
                      const EdgeInsets.fromLTRB(30, 10, 30, 10),
                    ),
                  ),
                ),
                margin: const EdgeInsets.only(top: 50, bottom: 50),
              ),
            ],
          ),
          padding: const EdgeInsets.only(left: 15, right: 15),
        ),
        Positioned(
            child: isLoading ? const LoadingView() : const SizedBox.shrink()),
      ],
    );
  }
}
