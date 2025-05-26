import 'package:flutter/material.dart';
import 'package:nutri/pages/cadastro_paciente.dart';
import 'package:nutri/repository/pacientes_repository.dart';
import '../models/pacientesModels.dart';
import '../fuctionsApps/functions_dialogs.dart';
import '../fuctionsApps/charts_pacientes.dart';

class PacienteDetalhes extends StatefulWidget {
  final Pacientesmodels paciente;

  const PacienteDetalhes({Key? key, required this.paciente}) : super(key: key);

  @override
  State<PacienteDetalhes> createState() => _PacientesDetalhesState();
}

class _PacientesDetalhesState extends State<PacienteDetalhes> {
  String nivelAtividade = 'Sedentário';

  final Map<String, double> fatoresAtividade = {
    'Sedentário': 1.2,
    'Leve': 1.375,
    'Moderado': 1.55,
    'Ativo': 1.725,
    'Extremamente ativo': 1.9,
  };

  double get imc {
    double peso = widget.paciente.peso;
    double altura = widget.paciente.altura / 100;
    double imc_calc = peso / (altura * altura);
    return imc_calc;
  }

  String get classificaoIMC {
    if (imc < 18.5) return 'Magreza';
    if (imc < 25) return 'Normal';
    if (imc < 30) return 'Sobrepeso';
    if (imc < 40) return 'Obesidade';
    return "Obesidade grave";
  }

  double get img {
    double s = widget.paciente.sexo.toLowerCase() == 'masculino' ? 1 : 0;
    return (1.2 * imc) - (10.8 * s) + (0.23 * widget.paciente.idade) - 5.4;
  }

  double get calBasal {
    if (widget.paciente.sexo.toLowerCase() == 'masculino') {
      return 88.362 +
          (13.397 * widget.paciente.peso) +
          (4.799 * widget.paciente.altura) -
          (5.677 * widget.paciente.idade);
    } else {
      return 447.593 +
          (9.247 * widget.paciente.peso) +
          (3.098 * widget.paciente.altura) -
          (4.330 * widget.paciente.idade);
    }
  }

  double get calTotal => calBasal * fatoresAtividade[nivelAtividade]!;

  double get carboidratros => (calTotal * 0.5) / 4;
  double get proteina => (calTotal * 0.25) / 4;
  double get gordura => (calTotal * 0.25) / 9;

  Map<String, double> get dadosMacroNutrientes => {
    'Carboidratos': carboidratros,
    'Proteínas': proteina,
    'Gordura': gordura,
  };

  Future<void> _excluirPaciente(BuildContext context) async {
    final confirmar = await mostrarDialogoConfirmacao(
      context: context,
      titulo: 'Confirmar exclusão',
      mensagem: 'Deseja realmente excluir ${widget.paciente.nome}',
    );
    if (confirmar) {
      await PacientesRepository().deletarPaciente(widget.paciente.id!);
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('${widget.paciente.nome} foi excluído.')),
      );
    }
  }

  void _mostrarInfo(String titulo, String mensagem) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(titulo),
        content: Text(mensagem),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Fechar"),
          ),
        ],
      ),
    );
  }

  Widget _infoRow(String label, String value, String tooltip) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Text('$label: $value', style: const TextStyle(fontSize: 16)),
          ),
          IconButton(
            onPressed: () => _mostrarInfo(label, tooltip),
            icon: const Icon(Icons.info_outline),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.paciente.nome)),
      body: LayoutBuilder(
        builder: (context, constrains) {
          final isWide = constrains.maxHeight > 600;
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Wrap(
                  spacing: 16,
                  runSpacing: 8,
                  children: [
                    Text(
                      'Sexo: ${widget.paciente.sexo}',
                      style: TextStyle(fontSize: 18),
                    ),
                    Text(
                      'Idade: ${widget.paciente.idade}',
                      style: TextStyle(fontSize: 18),
                    ),
                    Text(
                      'Altura: ${widget.paciente.altura}',
                      style: TextStyle(fontSize: 18),
                    ),
                    Text(
                      'Peso: ${widget.paciente.peso}',
                      style: TextStyle(fontSize: 18),
                    ),
                    Text(
                      '% Gordura: ${widget.paciente.gordura}',
                      style: TextStyle(fontSize: 18),
                    ),
                    Text(
                      '% Massa muscular: ${widget.paciente.musculo}',
                      style: TextStyle(fontSize: 18),
                    ),
                  ],
                ),
                const Divider(height: 32),

                _infoRow(
                  "IMC",
                  "${imc.toStringAsFixed(1)} - $classificaoIMC",
                  "IMC = Peso / Altura²",
                ),

                _infoRow("IMG", "${img.toStringAsFixed(1)} %", '''
  IMG = (1.2 x IMC) - (10.8 x S) + (0.23 x idade) - 5.4\nS = 1 (homem), 0 (mulher)
'''),

                _infoRow(
                  "Calorias basais",
                  "${calBasal.toStringAsFixed(0)} - kcal",
                  "Homem: 66 + (13,8 x peso) + (5 x altura cm) – (6,8 x idade)\nMulher: 655 + (9,6 x peso) + (1,9 x altura cm) – (4,7 x idade)",
                ),

                const SizedBox(height: 12),
                Text(
                  "Nivel de atividade",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                DropdownButton<String>(
                  value: nivelAtividade,
                  items: fatoresAtividade.keys
                      .map(
                        (nivel) =>
                            DropdownMenuItem(value: nivel, child: Text(nivel)),
                      )
                      .toList(),
                  onChanged: (value) => setState(() => nivelAtividade = value!),
                ),
                _infoRow(
                  'Gasto calórico total',
                  "${calTotal.toStringAsFixed(0)} kcal",
                  "Gasto total = Calorias basais x fator de atividade",
                ),
                const Divider(height: 32),
                Text(
                  "Macronutrientes (baseados nas calorias totais)",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                _infoRow(
                  "Carboidratos",
                  "${carboidratros.toStringAsFixed(0)} g",
                  'Carboidratos = calorias * 0,5/4',
                ),
                _infoRow(
                  "Proteínas",
                  "${proteina.toStringAsFixed(0)} g",
                  'Proteína = calorias * 0,25/4',
                ),
                _infoRow(
                  "Gordura",
                  "${gordura.toStringAsFixed(0)} g",
                  'Gordura = calorias * 0,25/9',
                ),

                const SizedBox(height: 16),
                ChartsPacientes(dados: dadosMacroNutrientes),
              ],
            ),
          );
        },
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: LayoutBuilder(
            builder: (context, constrains) {
              final isWide = constrains.maxWidth > 500;
              final button = _builButtons(context);

              return isWide
                  ? Row(
                      children: button
                          .map((btn) => Expanded(child: btn))
                          .toList(),
                    )
                  : Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: button,
                    );
            },
          ),
        ),
      ),
    );
  }

  List<Widget> _builButtons(BuildContext context) {
    return [
      ElevatedButton.icon(
        onPressed: () => _excluirPaciente(context),
        icon: const Icon(Icons.delete),
        label: const Text('Deletar'),
      ),
      const SizedBox(height: 8),
      ElevatedButton.icon(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => CadastroPaciente(paciente: widget.paciente),
            ),
          ).then((_) => Navigator.pop(context));
        },
        icon: const Icon(Icons.edit),
        label: const Text('Editar.'),
      ),
      const SizedBox(height: 8),
      ElevatedButton.icon(
        onPressed: () {},
        icon: Icon(Icons.history),
        label: const Text('Historico'),
      ),
    ];
  }
}
