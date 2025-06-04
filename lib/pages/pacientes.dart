import 'package:flutter/material.dart';
import 'package:nutri/pages/cadastro_paciente.dart';
import 'package:nutri/pages/criar_dieta.dart';
import '../models/pacientesModels.dart';
import '../repository/pacientes_repository.dart';
import './paciente_detalhes.dart';
import '../widgets/custom_drawer.dart';
import '../fuctionsApps/custom_app_bar.dart';
import '../fuctionsApps/charts_pacientes.dart';
import './criar_dieta.dart';

class Pacientes extends StatefulWidget {
  const Pacientes({Key? key}) : super(key: key);

  @override
  State<Pacientes> createState() => _PacientesState();
}

class _PacientesState extends State<Pacientes> {
  List<Pacientesmodels> pacientes = [];
  final PacientesRepository _repository = PacientesRepository();

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
      appBar: CustomAppBar(title: 'Pacientes'),
      drawer: CustomDrawer(),
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
                return PacienteActions(
                  paciente: paciente,
                  onTap: () async {
                    await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => PacienteDetalhes(paciente: paciente),
                      ),
                    );
                    _carregarPacientes();
                  },
                  onEditar: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => CadastroPaciente(paciente: paciente),
                      ),
                    );
                  },
                  onExcluir: (paciente) async {
                    await _repository.deletarPaciente(paciente.id!);
                    _carregarPacientes();
                  },
                  onCriarDieta: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => CriarDieta(paciente: paciente),
                      ),
                    );
                  },
                );
              },
            ),
    );
  }
}
