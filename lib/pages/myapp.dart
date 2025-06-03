import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import './cadastro_paciente.dart';
import './../database/db.dart';
import '../widgets/custom_drawer.dart';
import '../fuctionsApps/custom_app_bar.dart';

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
      appBar: CustomAppBar(
        title: 'Nutri Duda',
        actions: [
          IconButton(
            onPressed: () => {print("Logout")},
            icon: const Icon(Icons.logout),
            tooltip: 'Sair',
          ),
        ],
      ),
      drawer: CustomDrawer(),
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
              onTap: () async {
                final resposta = await showDialog<bool>(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: const Text(" Criar dieta para paciente:"),
                    content: const Text(
                      'Gostaria de criar a dieta para um paciente em especifico?',
                    ),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context, false),
                        child: const Text('Não'),
                      ),
                      ElevatedButton(
                        onPressed: () => Navigator.pop(context, true),
                        child: const Text('Sim'),
                      ),
                    ],
                  ),
                );
                if (resposta == true) {
                  Navigator.pushNamed(context, '/pesquisa_paciente');
                } else {
                  Navigator.pushNamed(context, '/criar_dieta');
                }
              },
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
