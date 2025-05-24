import 'package:flutter/material.dart';
import '../models/pacientesModels.dart';

class PacienteDetalhes extends StatelessWidget {
  final Pacientesmodels paciente;

  const PacienteDetalhes({Key? key, required this.paciente}) : super(key: key);

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
    );
  }
}
