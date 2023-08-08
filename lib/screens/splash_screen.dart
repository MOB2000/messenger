import 'package:flutter/material.dart';
import 'package:messenger/constants/assets.dart';
import 'package:messenger/constants/colors.dart';
import 'package:messenger/providers/auth_provider.dart';
import 'package:messenger/screens/home_screen.dart';
import 'package:messenger/screens/login_screen.dart';
import 'package:provider/provider.dart';

class SplashScreen extends StatefulWidget {
  static const routeName = 'SplashScreen';

  const SplashScreen({Key? key}) : super(key: key);

  @override
  SplashScreenState createState() => SplashScreenState();
}

class SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(
      const Duration(seconds: 2),
      checkSignedIn,
    );
  }

  void checkSignedIn() async {
    MyAuthProvider authProvider =
        Provider.of<MyAuthProvider>(context, listen: false);
    final routeName = await authProvider.isLoggedIn
        ? HomeScreen.routeName
        : LoginScreen.routeName;

    Navigator.pushReplacementNamed(context, routeName);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Image.asset(
              Assets.kAppIcon,
              height: 100,
              width: 200,
            ),
            const SizedBox(height: 24),
            const Text(
              'Welcome to Messenger',
              style: TextStyle(
                fontSize: 18,
                color: kThemeColor,
              ),
            ),
            const SizedBox(height: 12),
            const Text(
              'Best Chatting App',
              style: TextStyle(
                fontSize: 12,
                color: kThemeColor,
                fontStyle: FontStyle.italic,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
