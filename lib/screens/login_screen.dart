import 'package:flutter/material.dart';
import 'package:flutterfire_ui/auth.dart';
import 'package:messenger/constants/assets.dart';
import 'package:messenger/constants/configurations.dart';
import 'package:messenger/screens/home_screen.dart';

class LoginScreen extends StatefulWidget {
  static const routeName = 'LoginScreen';

  const LoginScreen({Key? key}) : super(key: key);

  @override
  LoginScreenState createState() => LoginScreenState();
}

class LoginScreenState extends State<LoginScreen> {
  @override
  Widget build(BuildContext context) {
    return SignInScreen(
      showAuthActionSwitch: true,
      providerConfigs: providerConfigs,
      actions: <FlutterFireUIAction>[
        AuthStateChangeAction<SignedIn>(
          (context, state) {
            Navigator.pushReplacementNamed(context, HomeScreen.routeName);
          },
        ),
      ],
      headerBuilder: (context, constraints, shrinkOffset) {
        return Image.asset(
          Assets.kAppIcon,
        );
      },
    );
  }
}
