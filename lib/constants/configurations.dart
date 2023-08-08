import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:firebase_ui_oauth_facebook/firebase_ui_oauth_facebook.dart';
import 'package:firebase_ui_oauth_google/firebase_ui_oauth_google.dart';
import 'package:messenger/constants/keys.dart';

final providerConfigs = <AuthProvider>[
  EmailAuthProvider(),
  GoogleProvider(clientId: Keys.kGoogleAppId),
  FacebookProvider(clientId: Keys.kFacebookClientId),
];
