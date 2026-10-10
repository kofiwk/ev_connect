import 'package:flutter/material.dart';

class AppMenuDrawer extends StatelessWidget {
  const AppMenuDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      elevation: 0,
      shape: BeveledRectangleBorder(
        borderRadius: BorderRadiusGeometry.circular(12)
      ),
      child: ListView(
        children: [
          ListTile(
            leading: Icon(Icons.abc),
            title: Text('Hello'),
          ),
          ListTile(
            leading: Icon(Icons.abc),
            title: Text('Hello'),
          ),
          ListTile(
            leading: Icon(Icons.abc),
            title: Text('Hello'),
          ),
          ListTile(
            leading: Icon(Icons.abc),
            title: Text('Hello'),
          ),
        ],
      )
    );
  }
}
