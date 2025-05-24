import 'package:flutter/material.dart';
import './../controllers/cadastroPacientesController.dart';
import 'package:flutter_multi_formatter/flutter_multi_formatter.dart';
import '../models/pacientesModels.dart';
import '../repository/pacientes_repository.dart';

class CadastroPaciente extends StatefulWidget {
  const CadastroPaciente({super.key});

  @override
  State<CadastroPaciente> createState() => _CadastroPacienteState();
}

class _CadastroPacienteState extends State<CadastroPaciente> {
  final _formKey = GlobalKey<FormState>();
  final controller = Cadastropacientescontroller();

  final nomeController = TextEditingController();
  final celularController = TextEditingController(text: '+55');
  final emailController = TextEditingController();
  final idadeController = TextEditingController();
  String sexoController = 'Feminino';
  final alturaController = TextEditingController();
  final pesoController = TextEditingController();
  final gorduraController = TextEditingController();
  final musculoController = TextEditingController();

  void _atualizarGordura() {
    final peso = double.tryParse(pesoController.text);
    final altura = double.tryParse(alturaController.text);
    final idade = int.tryParse(idadeController.text);
    if (peso != null && altura != null && idade != null) {
      final gordura = controller.calcularGorduraCorporal(
        peso: peso,
        alturaCm: altura,
        idade: idade,
        sexo: sexoController,
      );
      gorduraController.text = gordura.toStringAsFixed(1);
    }
  }

  @override
  void dispose() {
    nomeController.dispose();
    celularController.dispose();
    emailController.dispose();
    idadeController.dispose();
    alturaController.dispose();
    pesoController.dispose();
    gorduraController.dispose();
    musculoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cadastro de paciente'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: nomeController,
                decoration: const InputDecoration(labelText: 'Nome'),
                validator: (value) =>
                    value == null || value.isEmpty ? 'Informe o nome' : null,
              ),
              TextFormField(
                controller: celularController,
                decoration: const InputDecoration(labelText: 'Celular'),
                keyboardType: TextInputType.phone,
                inputFormatters: [PhoneInputFormatter()],
                validator: (value) {
                  if (value != null && value.isNotEmpty) {
                    final numeroLimpo = value.replaceAll(RegExp(r'\D'), '');
                    if (numeroLimpo.length < 12) {
                      return 'Número de celular inválido. Insira DDD + número.';
                    }
                  }
                  return null;
                },
              ),

              TextFormField(
                controller: emailController,
                decoration: const InputDecoration(labelText: 'Email'),
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  if (value != null && value.isNotEmpty) {
                    final emailRegex = RegExp(r'^[\w\.-]+@[\w\.-]+\.\w+$');
                    if (!emailRegex.hasMatch(value)) {
                      return 'Informe um email válido';
                    }
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: idadeController,
                decoration: const InputDecoration(labelText: 'Idade'),
                keyboardType: TextInputType.number,
                onChanged: (_) => _atualizarGordura(),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Informe a idade';
                  }
                  final idade = double.tryParse(value);
                  if (idade == null || idade <= 0) {
                    return 'Idade inválida';
                  }
                  return null;
                },
              ),
              DropdownButtonFormField(
                value: sexoController,
                decoration: const InputDecoration(labelText: 'Sexo'),
                items: ['Feminino', 'Masculino']
                    .map(
                      (sexo) =>
                          DropdownMenuItem(value: sexo, child: Text(sexo)),
                    )
                    .toList(),
                onChanged: (value) {
                  if (value != null) {
                    setState(() => sexoController = value);
                    _atualizarGordura();
                  }
                },
              ),
              TextFormField(
                controller: pesoController,
                decoration: const InputDecoration(labelText: 'Peso (kg)'),
                keyboardType: TextInputType.number,
                onChanged: (_) => _atualizarGordura(),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Informe o peso';
                  }
                  final peso = double.tryParse(value);
                  if (peso == null || peso <= 0) {
                    return 'Peso inválida';
                  }
                  return null;
                },
              ),

              TextFormField(
                controller: alturaController,
                decoration: const InputDecoration(labelText: 'Altura (cm)'),
                keyboardType: TextInputType.number,
                onChanged: (_) => _atualizarGordura(),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Informe a altura';
                  }
                  final altura = double.tryParse(value);
                  if (altura == null || altura <= 0) {
                    return 'Altura inválida';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: gorduraController,
                decoration: const InputDecoration(
                  labelText: '% Gordura Corporal',
                ),
                keyboardType: TextInputType.number,
              ),
              TextFormField(
                controller: musculoController,
                decoration: const InputDecoration(
                  labelText: '% Massa muscular',
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async {
                  final emailVazio = emailController.text.trim().isEmpty;
                  final celularVazio = celularController.text.trim().isEmpty;

                  if (emailVazio && celularVazio) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text(
                          'Informe ao menos um meio de contato. (Celular ou email) ',
                        ),
                      ),
                    );
                    return;
                  }
                  if (_formKey.currentState!.validate()) {
                    print('nomeController.text testando');

                    final novoPaciente = Pacientesmodels(
                      nome: nomeController.text,
                      celular: celularController.text,
                      email: emailController.text,
                      idade: int.parse(idadeController.text),
                      sexo: sexoController,
                      altura: int.parse(alturaController.text),
                      peso: double.parse(pesoController.text),
                      gordura: double.tryParse(gorduraController.text) ?? 0.0,
                      musculo: double.tryParse(musculoController.text) ?? 0.0,
                    );

                    await PacientesRepository().inserirPacientes(novoPaciente);

                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Paciente cadastrado!')),
                    );
                  } else {
                    print('_formKey.currentState!.validate() invalido');
                  }
                },
                child: const Text('Salvar'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
