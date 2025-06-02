import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import './cadastro_paciente.dart';
import './../database/db.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  void _mostrarMensagem(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(
          'Estamos preparando essa novidade 😊. Aguarde um pouquinho!',
        ),
        duration: Duration(seconds: 3),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Nutri Duda'),
        actions: [
          IconButton(
            onPressed: () => {print("Logout")},
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
              onTap: () => Navigator.pushNamed(context, '/pesquisa_paciente'),
            ),
            _buildCard(
              context,
              icon: Icons.food_bank,
              title: "Dietas",
              onTap: () => Navigator.pushNamed(context, '/criar_dieta'),
            ),
            _buildCard(
              context,
              icon: Icons.edit,
              title: "Editar Alimmentos",
              onTap: () => _mostrarMensagem(context),
            ),
            _buildCard(
              context,
              icon: Icons.person_pin,
              title: "Perfil do usuário.",
              onTap: () => _mostrarMensagem(context),
            ),

            //Botão para excluir o banco de dados
            IconButton(
              onPressed: () => DB.instance.deletarBanco(),
              icon: Icon(Icons.delete_outline),
            ),
          ],
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
