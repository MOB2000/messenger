import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:messenger/constants/colors.dart';
import 'package:messenger/constants/strings.dart';
import 'package:messenger/providers/auth_provider.dart';
import 'package:messenger/providers/chat_provider.dart';
import 'package:messenger/providers/setting_provider.dart';
import 'package:messenger/screens/chat_screen.dart';
import 'package:messenger/screens/full_photo_screen.dart';
import 'package:messenger/screens/home_screen.dart';
import 'package:messenger/screens/login_screen.dart';
import 'package:messenger/screens/settings_screen.dart';
import 'package:messenger/screens/splash_screen.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(const Messenger());
}

class Messenger extends StatelessWidget {
  const Messenger({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<MyAuthProvider>(create: (_) => MyAuthProvider()),
        Provider<ChatProvider>(create: (_) => ChatProvider()),
        Provider<SettingProvider>(create: (_) => SettingProvider()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: kMessenger,
        theme: ThemeData(
          primaryColor: kThemeColor,
        ),
        initialRoute: SplashScreen.routeName,
        routes: {
          SplashScreen.routeName: (context) => const SplashScreen(),
          LoginScreen.routeName: (context) => const LoginScreen(),
          HomeScreen.routeName: (context) => const HomeScreen(),
          ChatScreen.routeName: (context) => const ChatScreen(),
          FullPhotoScreen.routeName: (context) => const FullPhotoScreen(),
          SettingsScreen.routeName: (context) => const SettingsScreen(),
        },
      ),
    );
  }
}
