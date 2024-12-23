import 'package:flutter/material.dart';

class AvatarWidget extends StatelessWidget {
  final String? photoURL;

  const AvatarWidget({super.key, this.photoURL});

  @override
  Widget build(BuildContext context) {
    return photoURL != null
        ? Padding(
            padding: const EdgeInsets.only(right: 10),
            child: CircleAvatar(
              radius: 18,
              backgroundImage: NetworkImage(photoURL!),
            ),
          )
        : const Padding(
            padding: EdgeInsets.only(right: 10),
            child: CircleAvatar(
              radius: 18,
              backgroundColor: Color(0xFF363636),
              child: Icon(Icons.person, color: Colors.white),
            ),
          );
  }
}
