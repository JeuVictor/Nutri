import 'dart:math';

import 'package:flutter/material.dart';

class CustomDrawer extends StatelessWidget {
  final List<DrawerActionItem>? actions;

  const CustomDrawer({super.key, this.actions});

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          const DrawerHeader(
            decoration: BoxDecoration(color: Colors.blue),
            child: Text(
              'Menu',
              style: TextStyle(color: Colors.white, fontSize: 24),
            ),
          ),
          _buildMenuItem(
            context,
            icon: Icons.home,
            label: 'Tela Inicial',
            onTap: () => Navigator.popUntil(context, ModalRoute.withName('/')),
          ),
          _buildMenuItem(
            context,
            icon: Icons.people,
            label: 'Pacientes',
            onTap: () => Navigator.pushNamed(context, '/pacientes'),
          ),
          if (actions != null && actions!.isNotEmpty) ...[
            const Divider(),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: Text(
                "Ações",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            ...actions!.map(
              (item) => _buildMenuItem(
                context,
                icon: item.icon,
                label: item.label,
                onTap: item.onTap,
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildMenuItem(
    BuildContext context, {
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Icon(icon),
      title: Text(label),
      onTap: () {
        Navigator.pop(context);
        onTap();
      },
    );
  }
}

class DrawerActionItem {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  DrawerActionItem({
    required this.icon,
    required this.label,
    required this.onTap,
  });
}
