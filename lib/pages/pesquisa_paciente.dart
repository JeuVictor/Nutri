import 'package:flutter/material.dart';
import '../models/pacientesModels.dart';
import '../repository/pacientes_repository.dart';
import './paciente_detalhes.dart';

class PesquisaPaciente extends StatefulWidget {
  const PesquisaPaciente({Key? key}) : super(key: key);

  @override
  State<PesquisaPaciente> createState() => _PesquisaPacienteState();
}

class _PesquisaPacienteState extends State<PesquisaPaciente> {
  final TextEditingController _nomeEmailController = TextEditingController();
  final TextEditingController _celularController = TextEditingController();
  int? _idadeSelecionada;

  final PacientesRepository _repository = PacientesRepository();
  List<Pacientesmodels> _resultados = [];

  void _buscar(String filtro) async {
    final nomeEmail = _nomeEmailController.text.toLowerCase();
    final celular = _celularController.text.replaceAll(RegExp(r'\D'), '');

    final resultados = await _repository.buscarPacientes(filtro);
    final filtrados = resultados.where((p) {
      final matchNomeEmail =
          nomeEmail.isEmpty ||
          (p.nome.toLowerCase().contains(nomeEmail) ||
              (p.email?.toLowerCase().contains(nomeEmail) ?? false));

      final matchCelular =
          celular.isEmpty ||
          (p.celular?.replaceAll(RegExp(r'\D'), '').contains(celular) ?? false);

      final matchIdade =
          _idadeSelecionada == null ||
          (_idadeSelecionada == 101
              ? p.idade > 100
              : p.idade == _idadeSelecionada);

      return matchNomeEmail && matchCelular && matchIdade;
    }).toList();

    setState(() {
      _resultados = filtrados;
    });
  }

  List<DropdownMenuItem<int?>> getIdadeDropdownItem() {
    List<DropdownMenuItem<int?>> item = [
      const DropdownMenuItem(value: null, child: Text('Idade não selecionada')),
    ];

    item.addAll(
      List.generate(
        101,
        (i) => DropdownMenuItem(child: Text('$i anos'), value: i),
      ),
    );

    item.add(
      const DropdownMenuItem(child: Text('Mais de 100 anos'), value: 101),
    );

    return item;
  }

  @override
  void initState() {
    super.initState();
    _buscar('');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Pesquisar Paciente')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: _nomeEmailController,
              onChanged: (_) => _buscar(''),
              decoration: const InputDecoration(
                labelText: 'Nome ou Email',
                prefixIcon: const Icon(Icons.person),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _celularController,
              keyboardType: TextInputType.phone,
              onChanged: (_) => _buscar(''),
              decoration: const InputDecoration(
                labelText: 'Celular (xx) xxxxx-xxxx',
                prefixIcon: Icon(Icons.phone),
              ),
            ),
            const SizedBox(height: 12),
            DropdownButtonFormField<int?>(
              value: _idadeSelecionada,
              items: getIdadeDropdownItem(),
              onChanged: (value) {
                setState(() {
                  _idadeSelecionada = value;
                });
                _buscar('');
              },
              decoration: const InputDecoration(
                labelText: 'Idade',
                prefixIcon: Icon(Icons.cake),
              ),
              isExpanded: true,
            ),
            const SizedBox(height: 16),
            Expanded(
              child: _resultados.isEmpty
                  ? const Center(child: Text('Nenhum paciente encontrado.'))
                  : ListView.builder(
                      itemCount: _resultados.length,
                      itemBuilder: (context, index) {
                        final paciente = _resultados[index];
                        return Card(
                          child: ListTile(
                            title: Text(paciente.nome),
                            subtitle: Text(
                              '${paciente.idade} anos • ${paciente.email ?? paciente.celular}',
                            ),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) =>
                                      PacienteDetalhes(paciente: paciente),
                                ),
                              );
                            },
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
