import 'package:flutter/material.dart';
import '../models/pacientesModels.dart';
import '../repository/pacientes_repository.dart';
import './paciente_detalhes.dart';

/*
class Pacientes extends StatelessWidget {
  final List<Pacientesmodels> pacientes;

  const Pacientes({Key? key, required this.pacientes}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Pacientes')),
      body: ListView.builder(
        itemCount: pacientes.length,
        itemBuilder: (context, index) {
          final paciente = pacientes[index];

          return Card(
            elevation: 4,
            margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadiusGeometry.circular(12),
            ),
            child: ListTile(
              title: Text(
                paciente.nome,
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Text(
                'Sexo: ${paciente.sexo}, Idade: ${paciente.idade}, Peso: ${paciente.peso.toStringAsFixed(1)} kg',
              ),
              trailing: const Icon(Icons.arrow_forward_ios, size: 16),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => PacienteDetalhes(paciente: paciente),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}

*/

class Pacientes extends StatefulWidget {
  const Pacientes({Key? key}) : super(key: key);

  @override
  State<Pacientes> createState() => _PacientesState();
}

class _PacientesState extends State<Pacientes> {
  List<Pacientesmodels> pacientes = [];

  @override
  void initState() {
    super.initState();
    _carregarPacientes();
  }

  Future<void> _carregarPacientes() async {
    final dados = await PacientesRepository().listarPacientes();
    setState(() {
      pacientes = dados;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Pacientes')),
      body: pacientes.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: pacientes.length,
              itemBuilder: (context, index) {
                final paciente = pacientes[index];
                return Card(
                  elevation: 4,
                  margin: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadiusGeometry.circular(12),
                  ),
                  child: ListTile(
                    title: Text(
                      paciente.nome,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(
                      'Sexo: ${paciente.sexo}, Idade: ${paciente.idade}, Peso: ${paciente.peso.toStringAsFixed(1)} kg',
                    ),
                    trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => PacienteDetalhes(paciente: paciente),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
    );
  }
}
