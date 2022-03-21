import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:messenger/constants/colors.dart';
import 'package:messenger/constants/strings.dart';
import 'package:messenger/models/auth_status.dart';
import 'package:messenger/pages/home_screen.dart';
import 'package:messenger/providers/auth_provider.dart';
import 'package:messenger/widgets/loading_view.dart';
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
    switch (authProvider.status) {
      case AuthStatus.authenticateError:
        Fluttertoast.showToast(msg: kSignInFail);
        break;
      case AuthStatus.authenticateCanceled:
        Fluttertoast.showToast(msg: kSignInCanceled);
        break;
      case AuthStatus.authenticated:
        Fluttertoast.showToast(msg: kSignInSuccess);
        break;
      default:
        break;
    }
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          kLogin,
          style: TextStyle(color: kPrimaryColor),
        ),
        centerTitle: true,
      ),
      body: Stack(
        children: <Widget>[
          Center(
            child: TextButton(
              onPressed: () async {
                bool isSuccess = await authProvider.handleSignIn();
                if (isSuccess) {
                  Navigator.pushReplacementNamed(
                    context,
                    HomeScreen.routeName,
                  );
                }
              },
              child: const Text(
                kSignInWithGoogle,
                style: TextStyle(fontSize: 16, color: Colors.white),
              ),
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.resolveWith<Color>(
                  (Set<MaterialState> states) {
                    if (states.contains(MaterialState.pressed)) {
                      return const Color(0xffdd4b39).withOpacity(0.8);
                    }
                    return const Color(0xffdd4b39);
                  },
                ),
                splashFactory: NoSplash.splashFactory,
                padding: MaterialStateProperty.all<EdgeInsets>(
                  const EdgeInsets.fromLTRB(30, 15, 30, 15),
                ),
              ),
            ),
          ),
          Positioned(
            child: authProvider.status == AuthStatus.authenticating
                ? const LoadingView()
                : const SizedBox.shrink(),
          ),
        ],
      ),
    );
  }
}
