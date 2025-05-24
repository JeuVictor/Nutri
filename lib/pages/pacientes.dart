import 'package:flutter/material.dart';
import '../models/pacientesModels.dart';
import '../repository/pacientes_repository.dart';

class Pacientes extends StatefulWidget {
  const Pacientes({super.key});

  @override
  State<Pacientes> createState() => _PacientesState();
}

class _PacientesState extends State<Pacientes> {
  late Future<List<Pacientesmodels>> _pacientes;

  @override
  void initState() {
    super.initState();
    _pacientes = PacientesRepository().listarPacientes();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Lista de Pacientes')),
      body: FutureBuilder(
        future: _pacientes,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          final pacientes = snapshot.data ?? [];
          if (pacientes.isEmpty) {
            return const Center(child: Text('Nenhum paciente cadastrado.'));
          }

          return ListView.builder(
            itemCount: pacientes.length,
            itemBuilder: (context, index) {
              final paciente = pacientes[index];
              return ListTile(
                title: Text(paciente.nome),
                subtitle: Text(
                  'Email: ${paciente.email} | Idade: ${paciente.idade}',
                ),
              );
            },
          );
        },
      ),
    );
  }
}
