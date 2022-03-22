import 'package:flutter/material.dart';
import 'package:flutterfire_ui/auth.dart';
import 'package:messenger/constants/keys.dart';
import 'package:messenger/constants/strings.dart';
import 'package:messenger/models/popup_choice.dart';

const providerConfigs = <ProviderConfiguration>[
  EmailProviderConfiguration(),
  GoogleProviderConfiguration(
    clientId: Keys.kGoogleAppId,
  ),
];

final choices = <PopupChoice>[
  PopupChoice(title: kProfile, icon: Icons.perm_identity),
  PopupChoice(title: kLogout, icon: Icons.exit_to_app),
];
