import 'package:flutterfire_ui/auth.dart';
import 'package:messenger/constants/keys.dart';

const providerConfigs = <ProviderConfiguration>[
  EmailProviderConfiguration(),
  GoogleProviderConfiguration(
    clientId: Keys.kGoogleAppId,
  ),
  FacebookProviderConfiguration(clientId: Keys.kFacebookClientId),
];
