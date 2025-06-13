import 'package:flutter/material.dart';
import 'package:nutri/models/historico_paciente_models.dart';
import 'package:nutri/repository/historico_paciente_repository.dart';
import './../controllers/cadastroPacientesController.dart';
import 'package:flutter_multi_formatter/flutter_multi_formatter.dart';
import '../models/pacientesModels.dart';
import '../repository/pacientes_repository.dart';
import '../widgets/custom_drawer.dart';
import '../fuctionsApps/custom_app_bar.dart';

class CadastroPaciente extends StatefulWidget {
  final Pacientesmodels? paciente;

  const CadastroPaciente({super.key, this.paciente});

  @override
  State<CadastroPaciente> createState() => _CadastroPacienteState();
}

class _CadastroPacienteState extends State<CadastroPaciente> {
  final _formKey = GlobalKey<FormState>();
  final controller = Cadastropacientescontroller();

  final nomeController = TextEditingController();
  final celularController = TextEditingController(text: '+55');
  final emailController = TextEditingController();
  String sexoController = 'Feminino';
  final alturaController = TextEditingController();
  final pesoController = TextEditingController();
  final pesoAlvoController = TextEditingController();
  final gorduraController = TextEditingController();
  final musculoController = TextEditingController();
  String nivelAtividade = 'Moderado';
  DateTime? dataAlteracao;
  DateTime? dataNascSelecionada;

  @override
  void initState() {
    super.initState();

    final paciente = widget.paciente;
    if (paciente != null) {
      nomeController.text = paciente.nome;
      celularController.text = paciente.celular;
      emailController.text = paciente.email;
      dataNascSelecionada = DateTime.tryParse(paciente.dataNasc);
      sexoController = paciente.sexo;
      alturaController.text = paciente.altura.toString();
      pesoController.text = paciente.peso.toString();
      pesoAlvoController.text = paciente.peso_alvo.toString();
      gorduraController.text = paciente.gordura.toString();
      musculoController.text = paciente.musculo.toString();
      nivelAtividade = paciente.nivelAtividade;
      dataAlteracao = DateTime.tryParse(paciente.dataCriacao);
    }
  }

  bool _contatoValido() {
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
      return false;
    }
    return true;
  }

  Pacientesmodels _construirPacientes() {
    return Pacientesmodels(
      id: widget.paciente?.id,
      nome: nomeController.text,
      celular: celularController.text,
      email: emailController.text,
      dataNasc: dataNascSelecionada!.toIso8601String(),
      sexo: sexoController,
      altura: int.parse(alturaController.text),
      peso: double.parse(pesoController.text.replaceAll(',', '.')),
      peso_alvo:
          double.tryParse(pesoAlvoController.text.replaceAll(',', '.')) ?? 0.0,
      gordura:
          double.tryParse(gorduraController.text.replaceAll(',', '.')) ?? 0.0,
      musculo:
          double.tryParse(musculoController.text.replaceAll(',', '.')) ?? 0.0,
      dataCriacao: dataAlteracao!.toIso8601String(),
      nivelAtividade: nivelAtividade,
    );
  }

  Future<void> _salvarPaciente(Pacientesmodels paciente) async {
    final isEdicao = widget.paciente != null;

    if (isEdicao) {
      await PacientesRepository().atualizarPaciente(paciente);
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Paciente atualizado!')));
      try {
        await HistoricoPacienteRepository().inserir(
          HistoricoPaciente(
            pacienteId: paciente.id!,
            peso: paciente.peso,
            pesoAlvo: paciente.peso_alvo,
            nivelAtv: paciente.nivelAtividade,
            dataAtt: paciente.dataCriacao,
            gordura: paciente.gordura ?? 0.0,
            musculo: paciente.musculo ?? 0.0,
            
          ),
        );
        print('Novo Historico de atualização de paciente. Salvo com sucesso!');
      } catch (e) {
        print('Erro ao incluir os dados em historico do paciente erro: $e');
      }
      Navigator.pop(context, paciente);
    } else {
      final id = await PacientesRepository().inserirPacientes(paciente);

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Paciente cadastrado!')));
      try {
        await HistoricoPacienteRepository().inserir(
          HistoricoPaciente(
            pacienteId: id,
            peso: paciente.peso,
            pesoAlvo: paciente.peso_alvo,
            nivelAtv: paciente.nivelAtividade,
            dataAtt: paciente.dataCriacao,
            gordura: paciente.gordura ?? 0.0,
            musculo: paciente.musculo ?? 0.0,
          ),
        );
        print('Historico salvo com sucesso!');
      } catch (e) {
        print('Erro ao incluir os dados em historico do paciente erro: $e');
      }
      _limparFormulario();
    }
  }

  void _limparFormulario() {
    nomeController.clear();
    celularController.text = '+55';
    emailController.clear();
    dataNascSelecionada = DateTime(2000, 1, 1);
    alturaController.clear();
    pesoController.clear();
    pesoAlvoController.clear();
    gorduraController.clear();
    musculoController.clear();
    setState(() {
      sexoController = 'Feminino';
      nivelAtividade = 'Moderado';
    });
  }

  Widget selecionarNascimento() {
    return GestureDetector(
      onTap: () async {
        final hoje = DateTime.now();
        final dataSelecionada = await showDatePicker(
          context: context,
          locale: const Locale('pt', 'BR'),
          initialDate: dataNascSelecionada ?? DateTime(2000, 1, 1),
          firstDate: DateTime(1900),
          lastDate: hoje,
        );
        if (dataSelecionada != null) {
          setState(() {
            dataNascSelecionada = dataSelecionada;
          });
          _atualizarGordura();
        }
      },
      child: AbsorbPointer(
        child: TextFormField(
          decoration: const InputDecoration(
            labelText: 'Data de nascimento',
            hintText: 'Seleciona a data',
          ),
          validator: (value) {
            if (dataNascSelecionada == null) {
              return 'informe a data de nascimento';
            }
            return null;
          },
          controller: TextEditingController(
            text: dataNascSelecionada == null
                ? ''
                : '${dataNascSelecionada!.day.toString().padLeft(2, '0')}/'
                      '${dataNascSelecionada!.month.toString().padLeft(2, '0')}/'
                      '${dataNascSelecionada!.year}',
          ),
        ),
      ),
    );
  }

  Widget buttonAtividade() {
    return DropdownButtonFormField(
      value: nivelAtividade,
      decoration: const InputDecoration(labelText: 'Nivel de atividade'),
      items: [
        'Sedentário',
        'Leve',
        'Moderado',
        'Ativo',
        'Extremamente ativo',
      ].map((a) => DropdownMenuItem(value: a, child: Text(a))).toList(),
      onChanged: (value) {
        if (value != null) {
          setState(() => nivelAtividade = value);
        }
      },
    );
  }

  void _atualizarGordura() {
    final peso = double.tryParse(pesoController.text.replaceAll(',', '.'));
    final altura = double.tryParse(alturaController.text.replaceAll(',', '.'));
    final hoje = DateTime.now();
    int idade = hoje.year - dataNascSelecionada!.year;
    if (hoje.month < dataNascSelecionada!.month ||
        (hoje.month == dataNascSelecionada!.month &&
            hoje.day < dataNascSelecionada!.day)) {
      idade--;
    }
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
    alturaController.dispose();
    pesoController.dispose();
    pesoAlvoController.dispose();
    gorduraController.dispose();
    musculoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isEdicao = widget.paciente != null;

    if (isEdicao) {
      final dia = DateTime.parse(widget.paciente!.dataCriacao);
      dataAlteracao = dia;
    } else {
      dataAlteracao = DateTime.now();
    }

    return Scaffold(
      appBar: CustomAppBar(
        title: (isEdicao
            ? 'Editar paciente: ${nomeController.text} '
            : 'Cadastro de paciente'),
      ),
      drawer: CustomDrawer(),
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
              selecionarNascimento(),
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
                  final peso = double.tryParse(value.replaceAll(',', '.'));
                  if (peso == null || peso <= 0) {
                    return 'Peso inválida';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: pesoAlvoController,
                decoration: const InputDecoration(
                  labelText: 'Peso alvo do (kg)',
                ),
                keyboardType: TextInputType.number,
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
              buttonAtividade(),
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
                  if (_formKey.currentState!.validate()) {
                    try {
                      final paciente = _construirPacientes();
                      await _salvarPaciente(paciente);
                    } catch (e) {
                      print('Erro ao salvar paciente: $e');
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Erro ao salvar paciente.'),
                        ),
                      );
                    }
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
