import 'package:flutter/material.dart';

class UserProfile extends StatefulWidget {
  const UserProfile({super.key});

  @override
  State<UserProfile> createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfile> {
  @override
  Widget build(BuildContext context) {
    return Center(
        child: Text(
          'Profile Screen', 
          style: TextStyle(
          fontSize: 30
        )
      )
    );
  }
}