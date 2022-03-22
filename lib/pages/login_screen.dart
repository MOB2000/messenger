import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutterfire_ui/auth.dart';
import 'package:messenger/constants/assets.dart';
import 'package:messenger/constants/configurations.dart';
import 'package:messenger/pages/home_screen.dart';
import 'package:messenger/providers/auth_provider.dart';
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
    AuthProvider authProvider = Provider.of<AuthProvider>(context);
    //TODO: remove stream and add actions
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      initialData: FirebaseAuth.instance.currentUser,
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return SignInScreen(
            showAuthActionSwitch: true,
            providerConfigs: providerConfigs,
            headerBuilder: (context, constraints, _) {
              return Image.asset(
                Assets.kAppIcon,
              );
            },
          );
        }
        authProvider.saveUser();

        return const HomeScreen();
      },
    );
  }
}
