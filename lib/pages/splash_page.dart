import 'package:flutter/material.dart';
import 'package:messenger/constants/colors.dart';
import 'package:messenger/pages/home_page.dart';
import 'package:messenger/pages/login_page.dart';
import 'package:messenger/providers/auth_provider.dart';
import 'package:provider/provider.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({Key? key}) : super(key: key);

  @override
  SplashPageState createState() => SplashPageState();
}

class SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();
    Future.delayed(
      const Duration(seconds: 3),
      checkSignedIn,
    );
  }

  void checkSignedIn() async {
    AuthProvider authProvider = context.read<AuthProvider>();
    bool isLoggedIn = await authProvider.isLoggedIn();
    if (isLoggedIn) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const HomePage()),
      );
      return;
    }
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const LoginPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset(
              "images/app_icon.png",
              width: 200,
              height: 100,
            ),
            const SizedBox(height: 20),
            const SizedBox(
              width: 20,
              height: 20,
              child:
                  CircularProgressIndicator(color: ColorConstants.kThemeColor),
            ),
          ],
        ),
      ),
    );
  }
}
