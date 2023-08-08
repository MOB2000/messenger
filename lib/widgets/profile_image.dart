import 'package:flutter/material.dart';
import 'package:messenger/constants/colors.dart';

class ProfileImage extends StatelessWidget {
  final String photoUrl;

  final double size;
  const ProfileImage({
    Key? key,
    required this.size,
    required this.photoUrl,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Image.network(
        photoUrl,
        fit: BoxFit.cover,
        width: size,
        height: size,
        loadingBuilder: (
          BuildContext context,
          Widget child,
          ImageChunkEvent? loadingProgress,
        ) {
          if (loadingProgress == null) return child;
          return SizedBox(
            width: size,
            height: size,
            child: Center(
              child: CircularProgressIndicator(
                color: kThemeColor,
                value: loadingProgress.expectedTotalBytes != null
                    ? loadingProgress.cumulativeBytesLoaded /
                        loadingProgress.expectedTotalBytes!
                    : null,
              ),
            ),
          );
        },
        errorBuilder: (context, object, stackTrace) {
          return Icon(
            Icons.account_circle,
            size: size,
            color: kGreyColor,
          );
        },
      ),
      borderRadius: const BorderRadius.all(Radius.circular(25)),
      clipBehavior: Clip.hardEdge,
    );
  }
}
