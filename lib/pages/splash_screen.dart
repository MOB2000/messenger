import 'package:flutter/material.dart';
import 'package:messenger/constants/assets.dart';
import 'package:messenger/constants/colors.dart';
import 'package:messenger/pages/home_screen.dart';
import 'package:messenger/pages/login_screen.dart';
import 'package:messenger/providers/auth_provider.dart';
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
      const Duration(seconds: 3),
      checkSignedIn,
    );
  }

  void checkSignedIn() async {
    AuthProvider authProvider = Provider.of<AuthProvider>(context);
    bool isLoggedIn = await authProvider.isLoggedIn();
    if (isLoggedIn) {
      Navigator.pushReplacementNamed(context, HomeScreen.routeName);
      return;
    }
    Navigator.pushReplacementNamed(context, LoginScreen.routeName);
  }

  @override
  Widget build(BuildContext context) {
    //TODO use mediaQuerySize
    final mediaQuerySize = MediaQuery.of(context).size;
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset(
              Assets.kAppIcon,
              width: 200,
              height: 100,
            ),
            const SizedBox(height: 24),
            const SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(
                color: kThemeColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
