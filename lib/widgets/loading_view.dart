import 'package:flutter/material.dart';
import 'package:messenger/constants/colors.dart';

class LoadingView extends StatelessWidget {
  const LoadingView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: CircularProgressIndicator(
        color: ColorConstants.kThemeColor,
      ),
    );
  }
}
