import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class Graficopaciente extends StatelessWidget {
  final double pesoAtual;
  final double? pesoAlvo;
  final double carbo;
  final double lip;
  final double prot;

  const Graficopaciente({
    super.key,
    required this.pesoAtual,
    required this.carbo,
    required this.lip,
    required this.prot,
    this.pesoAlvo,
  });

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Padding(
      padding: const EdgeInsets.all(12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (pesoAlvo != null)
            Expanded(
              child: _buildGraficoCard(
                title: "Peso Atual vs alvo",
                child: BarChart(
                  BarChartData(
                    alignment: BarChartAlignment.spaceAround,
                    barTouchData: BarTouchData(enabled: false),
                    titlesData: FlTitlesData(
                      leftTitles: AxisTitles(
                        sideTitles: SideTitles(showTitles: true),
                      ),
                      bottomTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          getTitlesWidget: (value, meta) {
                            switch (value.toInt()) {
                              case 0:
                                return const Text("Atual");
                              case 1:
                                return const Text("Alvo");
                            }
                            return const SizedBox.shrink();
                          },
                        ),
                      ),
                      topTitles: AxisTitles(
                        sideTitles: SideTitles(showTitles: false),
                      ),
                      rightTitles: AxisTitles(
                        sideTitles: SideTitles(showTitles: false),
                      ),
                    ),
                    borderData: FlBorderData(show: false),
                    barGroups: [
                      BarChartGroupData(
                        x: 0,
                        barRods: [
                          BarChartRodData(
                            toY: pesoAtual,
                            color: Colors.blueAccent,
                            width: 22,
                          ),
                        ],
                      ),
                      BarChartGroupData(
                        x: 1,
                        barRods: [
                          BarChartRodData(
                            toY: pesoAlvo!,
                            color: Colors.green,
                            width: 22,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          const SizedBox(width: 12),

          Expanded(
            child: _buildGraficoCard(
              title: "Distribuição de Macronutrientes",
              child: PieChart(
                PieChartData(
                  sectionsSpace: 2,
                  centerSpaceRadius: 20,
                  sections: _buildMacroSections(),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGraficoCard({required String title, required Widget child}) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: EdgeInsets.all(12),
        child: Column(
          children: [
            Text(
              title,
              style: const TextStyle(fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            SizedBox(height: 130, width: double.infinity, child: child),
          ],
        ),
      ),
    );
  }

  List<PieChartSectionData> _buildMacroSections() {
    final total = carbo + prot + lip;
    return [
      PieChartSectionData(
        color: Colors.orange,
        value: carbo,
        title: "${((carbo / total) * 100).round()}%",
        radius: 40,
        titleStyle: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
      ),
      PieChartSectionData(
        color: Colors.redAccent,
        value: prot,
        title: "${((prot / total) * 100).round()}%",
        radius: 40,
        titleStyle: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
      ),
      PieChartSectionData(
        color: Colors.purple,
        value: lip,
        title: "${((lip / total) * 100).round()}%",
        radius: 40,
        titleStyle: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
      ),
    ];
  }
}
