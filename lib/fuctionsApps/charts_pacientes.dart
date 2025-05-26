import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

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
