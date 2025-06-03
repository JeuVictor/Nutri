import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import './../models/pacientesModels.dart';

class ChartsPacientes extends StatelessWidget {
  final Map<String, double> dados;

  const ChartsPacientes({super.key, required this.dados});

  @override
  Widget build(BuildContext context) {
    final cores = [
      Colors.blue,
      Colors.red,
      Colors.green,
      Colors.orange,
      Colors.purple,
      Colors.cyan,
      Colors.brown,
    ];

    final sections = <PieChartSectionData>[];
    final legenda = <Widget>[];

    int i = 0;
    dados.forEach((nome, valor) {
      final cor = cores[i % cores.length];
      sections.add(
        PieChartSectionData(
          color: cor,
          value: valor,
          title: valor >= 5 ? '${valor.toStringAsFixed(0)}%' : '',
          titleStyle: const TextStyle(color: Colors.white, fontSize: 14),
        ),
      );

      legenda.add(
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 2),
          child: Row(
            children: [
              Container(width: 16, height: 16, color: cor),
              const SizedBox(width: 8),
              Text(nome),
            ],
          ),
        ),
      );
      i++;
    });

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Distribuição de macronutrientes',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 200,
          child: PieChart(
            PieChartData(
              sections: sections,
              centerSpaceRadius: 40,
              sectionsSpace: 2,
            ),
          ),
        ),
        const SizedBox(height: 12),
        Column(crossAxisAlignment: CrossAxisAlignment.start, children: legenda),
      ],
    );
  }
}

class PacienteActions extends StatelessWidget {
  final Pacientesmodels paciente;
  final VoidCallback onTap;
  final VoidCallback onEditar;
  final Future<void> Function(Pacientesmodels paciente) onExcluir;
  final VoidCallback onCriarDieta;

  const PacienteActions({
    Key? key,
    required this.paciente,
    required this.onTap,
    required this.onEditar,
    required this.onExcluir,
    required this.onCriarDieta,
  }) : super(key: key);

  Widget itens(
    BuildContext context,
    VoidCallback onEditar,
    VoidCallback onCriarDieta,
    Pacientesmodels paciente,
  ) {
    return PopupMenuButton<String>(
      onSelected: (value) async {
        switch (value) {
          case 'editar':
            onEditar();
            break;

          case 'excluir':
            final confimar = await showDialog<bool>(
              context: context,
              builder: (context) => AlertDialog(
                title: const Text('Confirmar a exclusão'),
                content: Text('Deseja excluir ${paciente.nome}?'),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context, false),
                    child: const Text('Cancelar'),
                  ),
                  TextButton(
                    onPressed: () => Navigator.pop(context, true),
                    child: const Text(
                      'Excluir',
                      style: TextStyle(color: Colors.red),
                    ),
                  ),
                ],
              ),
            );
            if (confimar == true) {
              await onExcluir(paciente);
            }
            break;
          case 'dieta':
            onCriarDieta();
            break;
        }
      },
      itemBuilder: (context) => const [
        PopupMenuItem(child: Text('Editar'), value: 'editar'),
        PopupMenuItem(child: Text('Excluir'), value: 'excluir'),
        PopupMenuItem(child: Text('Criar Dieta'), value: 'dieta'),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Card(
      child: ListTile(
        title: Text(paciente.nome),
        subtitle: Text(
          '${paciente.idade} anos | ${paciente.email ?? paciente.celular ?? ''}',
        ),
        onTap: onTap,
        trailing: itens(context, onEditar, onCriarDieta, paciente),
      ),
    );
  }
}
