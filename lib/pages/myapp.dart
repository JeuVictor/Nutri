import 'package:flutter/material.dart';
import './cadastro_paciente.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Nutri Duda'),
          actions: [
            IconButton(
              onPressed: () => {print("Logoff")},
              icon: const Icon(Icons.logout),
              tooltip: 'Sair',
            ),
          ],
          centerTitle: true,
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: GridView.count(
            crossAxisCount: 2,
            mainAxisSpacing: 16,
            crossAxisSpacing: 16,
            children: [
              _buildCard(
                context,
                icon: Icons.people,
                title: 'Pacientes',
                onTap: () => Navigator.pushNamed(context, '/pacientes'),
              ),
              _buildCard(
                context,
                icon: Icons.person_add,
                title: "Cadastrar pacientes",
                onTap: () => Navigator.pushNamed(context, '/cadastro_paciente'),
              ),
              _buildCard(
                context,
                icon: Icons.search,
                title: "Procurar pacientes",
                onTap: () => Navigator.pushNamed(context, '/cadastro_paciente'),
              ),
              _buildCard(
                context,
                icon: Icons.show_chart,
                title: "Gráficos",
                onTap: () => Navigator.pushNamed(context, '/cadastro_paciente'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCard(
    BuildContext context, {
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.blue.shade100,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 48, color: Colors.blue.shade900),
            const SizedBox(height: 8),
            Text(title, style: const TextStyle(fontSize: 18)),
          ],
        ),
      ),
    );
  }
}
