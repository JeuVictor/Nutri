import 'package:flutter/material.dart';
import 'package:nutri/pages/cadastro_paciente.dart';
import 'package:nutri/repository/pacientes_repository.dart';
import '../models/pacientesModels.dart';
import '../fuctionsApps/functions_dialogs.dart';

class PacienteDetalhes extends StatelessWidget {
  final Pacientesmodels paciente;

  const PacienteDetalhes({Key? key, required this.paciente}) : super(key: key);

  Future<void> _excluirPaciente(BuildContext context) async {
    final confirmar = await mostrarDialogoConfirmacao(
      context: context,
      titulo: 'Confirmar exclusão',
      mensagem: 'Deseja realmente excluir ${paciente.nome}',
    );
    if (confirmar) {
      await PacientesRepository().deletarPaciente(paciente.id!);
      Navigator.pop(context);
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('${paciente.nome} foi excluído.')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(paciente.nome)),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Nome: ${paciente.nome}', style: TextStyle(fontSize: 18)),
            SizedBox(height: 8),
            Text('Sexo: ${paciente.sexo}', style: TextStyle(fontSize: 18)),
            SizedBox(height: 8),
            Text('Idade: ${paciente.idade}', style: TextStyle(fontSize: 18)),
            SizedBox(height: 8),
            Text('Altura: ${paciente.altura}', style: TextStyle(fontSize: 18)),
            SizedBox(height: 8),
            Text('Peso: ${paciente.peso}', style: TextStyle(fontSize: 18)),
            SizedBox(height: 8),
            Text(
              '% Gordura: ${paciente.gordura}',
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 8),
            Text(
              '% Massa muscular: ${paciente.musculo}',
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 8),
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Expanded(
              child: ElevatedButton.icon(
                onPressed: () => _excluirPaciente(context),
                icon: const Icon(Icons.delete),
                label: const Text('Deletar'),
              ),
            ),
            Expanded(
              child: ElevatedButton.icon(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => CadastroPaciente(paciente: paciente),
                    ),
                  ).then((_) => Navigator.pop(context));
                },
                icon: const Icon(Icons.edit),
                label: const Text('Editar.'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
