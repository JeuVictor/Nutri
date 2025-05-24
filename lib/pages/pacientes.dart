import 'package:flutter/material.dart';
import 'package:nutri/pages/cadastro_paciente.dart';
import '../models/pacientesModels.dart';
import '../repository/pacientes_repository.dart';
import './paciente_detalhes.dart';

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

  Future<void> _deletarPaciente(Pacientesmodels paciente) async {
    final confirmar = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirmar exclusão'),
        content: Text('Tem certeza que deseja excluir ${paciente.nome}?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Excluir', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );

    if (confirmar == true) {
      await PacientesRepository().deletarPaciente(paciente.id!);
      _carregarPacientes();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('${paciente.nome} excluído com sucesso.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Pacientes')),
      body: pacientes.isEmpty
          ? Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    'Sem pacientes cadastro.',
                    style: TextStyle(fontSize: 18),
                  ),
                  const SizedBox(height: 12),
                  ElevatedButton.icon(
                    onPressed: () async {
                      await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const CadastroPaciente(),
                        ),
                      );
                      _carregarPacientes();
                    },
                    icon: const Icon(Icons.person_add),
                    label: const Text('Clique aqui para cadastrar.'),
                  ),
                ],
              ),
            )
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
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          onPressed: () => _deletarPaciente(paciente),
                          icon: const Icon(Icons.delete, color: Colors.red),
                        ),
                        const Icon(Icons.arrow_forward_ios, size: 16),
                      ],
                    ),
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
