import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:flutter/material.dart';
import 'package:messenger/constants/assets.dart';
import 'package:messenger/constants/configurations.dart';
import 'package:messenger/providers/auth_provider.dart';
import 'package:messenger/screens/home_screen.dart';
import 'package:messenger/services/fire_auth.dart';
import 'package:provider/provider.dart';

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
      providers: providerConfigs,
      actions: [
        AuthStateChangeAction<SignedIn>(
          (context, state) async {
            await FireAuth.instance.initUser();
            final authProvider =
                Provider.of<MyAuthProvider>(context, listen: false);
            await authProvider.saveUser();
            Navigator.pushReplacementNamed(context, HomeScreen.routeName);
          },
        ),
      ],
      headerBuilder: (context, constraints, shrinkOffset) =>
          Image.asset(Assets.kAppIcon),
    );
  }
}
