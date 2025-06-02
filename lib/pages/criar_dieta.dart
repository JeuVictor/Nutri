import 'package:flutter/material.dart';
import 'package:nutri/pages/pesquisa_alimentos.dart';
import './dieta/editar_dieta.dart';
import './../repository/alimento_repository.dart';

class CriarDieta extends StatefulWidget {
  @override
  _CriarDieta createState() => _CriarDieta();
}

class _CriarDieta extends State<CriarDieta> {
  List<String> refeicoes = ['Café da manhã', 'Almoço', 'Jantar'];

  String frqueciaSelecionada = 'Todos os dias';
  Map<String, bool> diasSelecionados = {
    'Domingo': false,
    'Segunda': false,
    'Terça': false,
    'Quarta': false,
    'Quinta': false,
    'Sexta': false,
    'Sábado': false,
  };

  void _adicionarRefeicao() {
    setState(() {
      refeicoes.add('Nova Refeição ${refeicoes.length + 1}');
    });
  }

  final double totalKcal = 1800;
  final double totalCarbo = 300;
  final double totalProteina = 120;
  final double totalLipidio = 60;

  Widget _buildResumoNutricional() {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 20.0),
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(12.0),
        boxShadow: [
          BoxShadow(color: Colors.black12, blurRadius: 4, offset: Offset(0, 2)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Resumo nutricional total',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 12),
          Column(
            children: [
              _infoNutricional(
                cor: Colors.orange,
                label: 'kcal',
                valor: totalKcal,
                icon: Icons.local_fire_department,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _infoNutricional(
                    cor: Colors.green,
                    label: 'Carboídratos',
                    valor: totalCarbo,
                    icon: Icons.breakfast_dining,
                  ),
                  _infoNutricional(
                    cor: Colors.blue,
                    label: 'Proteínas',
                    valor: totalProteina,
                    icon: Icons.fitness_center,
                  ),
                  _infoNutricional(
                    cor: Colors.pink,
                    label: 'Lipídios',
                    valor: totalLipidio,
                    icon: Icons.opacity,
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _infoNutricional({
    required Color cor,
    required String label,
    required double valor,
    required IconData icon,
  }) {
    return Column(
      children: [
        Icon(icon, size: 28, color: cor),
        SizedBox(height: 6),
        Text(
          '${valor.toStringAsFixed(0)}',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: cor,
          ),
        ),
        Text(label, style: TextStyle(fontSize: 14, color: cor)),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Criar dieta')),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ReorderableListView(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                onReorder: (oldIndex, newIndex) {
                  setState(() {
                    if (newIndex > oldIndex) newIndex -= 1;
                    final item = refeicoes.removeAt(oldIndex);
                    refeicoes.insert(newIndex, item);
                  });
                },
                children: refeicoes.asMap().entries.map((entry) {
                  int index = entry.key;
                  String refeicao = entry.value;

                  return Card(
                    key: ValueKey(refeicao),
                    margin: const EdgeInsets.symmetric(
                      vertical: 6.0,
                      horizontal: 4,
                    ),
                    child: ListTile(
                      title: Text(refeicao),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.drag_handle),
                          const SizedBox(width: 12),
                          Icon(Icons.edit),
                        ],
                      ),
                      onTap: () async {
                        final resultado = await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => EditarDieta(nomeInicial: refeicao),
                          ),
                        );
                        if (resultado != null && resultado['nome'] != null) {
                          setState(() {
                            refeicoes[index] = resultado['nome'];
                          });
                        }
                      },
                    ),
                  );
                }).toList(),
              ),

              GestureDetector(
                onTap: _adicionarRefeicao,
                child: Card(
                  color: Colors.grey[100],
                  margin: const EdgeInsets.symmetric(vertical: 6.0),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      vertical: 16.0,
                      horizontal: 12.0,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.add, color: Colors.green),
                        SizedBox(width: 8),
                        Text(
                          'Criar uma nova refeição',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.green[800],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),

              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Frequencia da dieta',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              DropdownButton<String>(
                value: frqueciaSelecionada,
                isExpanded: true,
                items: ['Todos os dias', 'Segunda a sexta', 'Personalizado']
                    .map((opcao) {
                      return DropdownMenuItem(child: Text(opcao), value: opcao);
                    })
                    .toList(),
                onChanged: (novaOpcao) {
                  if (novaOpcao != null) {
                    setState(() {
                      frqueciaSelecionada = novaOpcao;
                    });
                  }
                },
              ),
              if (frqueciaSelecionada == 'Personalizado')
                Column(
                  children: diasSelecionados.keys.map((dia) {
                    return CheckboxListTile(
                      title: Text(dia),
                      value: diasSelecionados[dia],
                      onChanged: (bool? value) {
                        setState(() {
                          diasSelecionados[dia] = value ?? false;
                        });
                      },
                    );
                  }).toList(),
                ),
              _buildResumoNutricional(),
            ],
          ),
        ),
      ),
    );
  }
}
