import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'dart:math' as math;

class WallPost extends StatelessWidget {
  final String message;
  final String user;

  WallPost({
    super.key,
    required this.message,
    required this.user,
  });

  @override
  Widget build(BuildContext context) {
    final currentUser = FirebaseAuth.instance.currentUser!;

    return Row(
      mainAxisAlignment: currentUser.email == user
          ? MainAxisAlignment.end // Pesan di kanan
          : MainAxisAlignment.start,
      children: [
        // Pesan di kiri
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          margin: const EdgeInsets.only(top: 4, bottom: 4, left: 8, right: 8),
          constraints: BoxConstraints(
            maxWidth: MediaQuery.of(context).size.width * 0.7,
          ),
          decoration: BoxDecoration(
            color: currentUser.email == user
                ? Colors.green.shade200
                : Colors.grey.shade200,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Column(
            crossAxisAlignment: currentUser.email == user
                ? CrossAxisAlignment.end
                : CrossAxisAlignment.start,
            children: [
              if (currentUser.email != user)
                Text(
                  user,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              const SizedBox(height: 4),
              SizedBox(
                child: Text(
                  message,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.normal,
                  ),
                ),
              ),
            ],
          ),
        )
      ],
    );
  }
}
