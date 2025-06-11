import 'package:flutter/material.dart';
import 'package:nutri/models/refeicao_alimentos_models.dart';
import 'package:nutri/models/refeicao_models.dart';
import 'package:nutri/pages/myapp.dart';
import 'package:nutri/repository/dieta_repository.dart';
import 'package:nutri/repository/refeicao_alimento_repository.dart';
import '../repository/refeicao_repository.dart';
import './dieta/editar_dieta.dart';
import '../widgets/custom_drawer.dart';
import '../fuctionsApps/custom_app_bar.dart';
import '../models/pacientesModels.dart';
import '../models/dieta_models.dart';
import '../models/historico_paciente_models.dart';
import '../repository/historico_paciente_repository.dart';

class CriarDieta extends StatefulWidget {
  final Pacientesmodels? paciente;
  const CriarDieta({super.key, this.paciente});

  @override
  State<CriarDieta> createState() => _CriarDieta();
}

class _CriarDieta extends State<CriarDieta> {
  Pacientesmodels? paciente;
  DietaModels? dietaCriada;
  bool dietaCriadaJa = false;

  List<Map<String, dynamic>> refeicao = [];

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    final args = ModalRoute.of(context)?.settings.arguments;
    if (args != null && args is Pacientesmodels) {
      paciente = args;
    } else {
      paciente = widget.paciente;
    }
  }

  List<Map<String, dynamic>> refeicoes = [
    {
      'nome': 'Café da manhã',
      'horario': '',
      'observacoes': '',
      'alimentos': [],
      'calcNutri': [],
    },
    {'nome': 'Almoço', 'horario': '', 'observacoes': '', 'alimentos': [
       
      ],
    },
    {'nome': 'Jantar', 'horario': '', 'observacoes': '', 'alimentos': []},
  ];

  Map<String, double> calcularNutris(List<Map> refeicoes) {
    double kcal = 0.0;
    double carbo = 0.0;
    double prot = 00.0;
    double gord = 00.0;
    double calcio = 00.0;
    double ferro = 00.0;
    double vitA = 00.0;
    double vitc = 0.0;
    double tiamina = 00.0;
    double ribo = 0.0;
    double niacina = 00.0;
    double sodio = 00.0;
    double fibra = 00.0;
    for (final al in refeicoes) {
      final alimentos = List<Map<String, dynamic>>.from(al['alimentos'] ?? []);
      for (var a in alimentos) {
        kcal += parseDouble(a['energia_kcal']);
        carbo += parseDouble(a['glicidios_g']);
        prot += parseDouble(a['proteinas_g']);
        gord += parseDouble(a['lipidios_g']);
        calcio += parseDouble(a['calcio_mg']);
        ferro += parseDouble(a['ferro_mg']);
        vitA += parseDouble(a['vit_a_mmg']);
        vitc += parseDouble(a['vit_c_mg']);
        tiamina += parseDouble(a['tiamina_mg']);
        ribo += parseDouble(a['riboflavina_mg']);
        niacina += parseDouble(a['niacina_mg']);
        sodio += parseDouble(a['sodio_mg']);
        fibra += parseDouble(a['fibra_alimentar_g']);
      }
    }
    return {
      'kcal': kcal,
      'carbo': carbo,
      'prot': prot,
      'gord': gord,
      'calcio': calcio,
      'ferro': ferro,
      'vitA': vitA,
      'vitc': vitc,
      'tiamina': tiamina,
      'ribo': ribo,
      'niacina': niacina,
      'sodio': sodio,
      'fibra': fibra,
    };
  }

  double totalNutri(String tema, List<Map> refeicoes) {
    final result = calcularNutris(refeicoes);
    return result[tema] ?? 0.0;
  }

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
      refeicoes.add({
        'nome': 'Nova Refeição ${refeicoes.length + 1}',
        'horario': '',
        'observacoes': '',
        'alimentos': [],
        'calcNutri': [],
      });
    });
  }

  double get totalKcal => paciente?.calcKcall ?? 0.0;
  double get totalCarbo => paciente?.carboidratros ?? 0.0;
  double get totalProteina => paciente?.proteina ?? 0.0;
  double get totalLipidio => paciente?.lipidios ?? 0.0;

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
            'Quantidade nutricional necessária',
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
                valorAtual: totaisAtuais['kcal'] ?? 0.0,
                valorMeta: totalKcal,
                icon: Icons.local_fire_department,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _infoNutricional(
                    cor: Colors.green,
                    label: 'Carboídratos',
                    valorAtual: totaisAtuais['carbo'] ?? 0.0,
                    valorMeta: totalCarbo,
                    icon: Icons.breakfast_dining,
                  ),
                  _infoNutricional(
                    cor: Colors.blue,
                    label: 'Proteínas',
                    valorAtual: totaisAtuais['prot'] ?? 0.0,
                    valorMeta: totalProteina,
                    icon: Icons.fitness_center,
                  ),
                  _infoNutricional(
                    cor: Colors.pink,
                    label: 'Lipídios',
                    valorAtual: totaisAtuais['gord'] ?? 0.0,
                    valorMeta: totalLipidio,
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
    required double valorAtual,
    required double valorMeta,
    required IconData icon,
  }) {
    return Column(
      children: [
        Icon(icon, size: 28, color: cor),
        SizedBox(height: 4),
        Text(
          '${valorAtual.toStringAsFixed(0)}',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: cor,
          ),
        ),
        SizedBox(height: 2),
        Text(
          'Meta: ${valorMeta.toStringAsFixed(0)}',
          style: TextStyle(fontSize: 11, color: cor.withOpacity(0.7)),
        ),
        SizedBox(height: 2),
        Text(label, style: TextStyle(fontSize: 13, color: cor)),
      ],
    );
  }

  Future<int> salvarDieta() async {
    final novaDieta = DietaModels(
      nome:
          'Dieta de ${paciente!.nome} criada em ${DateTime.now().toLocal().toString().split(' ')[0]}',
      dataCriacao: DateTime.now().toIso8601String(),
      pacienteId: paciente!.id!,
    );

    return await DietaRepository().insert(novaDieta);
  }

  Future<List<int>> salvarRefeicoes(int idDiet) async {
    final refeicaoRepo = RefeicaoRepository();

    List<int> ids = [];

    for (var ref in refeicoes) {
      final novaRefecao = RefeicaoModels(
        nome: ref['nome'],
        horario: ref['horario'],
        observacoes: ref['observacoes'],
        dietaId: idDiet,
      );
      final id = await refeicaoRepo.insert(novaRefecao);
      ids.add(id);
    }
    return ids;
  }

  double parseDouble(dynamic value) {
    if (value is double) return value;
    if (value is int) return value.toDouble();
    if (value is String) return double.tryParse(value) ?? 0.0;
    return 0.0;
  }

  Future<void> salvarRefeicaoAlimentos(List<int> refeicaoIds) async {
    final repo = RefeicaoAlimentoRepository();
    try {
      for (int i = 0; i < refeicoes.length; i++) {
        final alimentos = (refeicoes[i]['alimentos'] as List)
            .map((e) => Map<String, dynamic>.from(e))
            .toList();
        print(
          'Refeição ${refeicoes[i]['nome']} com ${alimentos.length} alimentos',
        );
        for (var alimento in alimentos) {
          final model = RefeicaoAlimentosModels(
            refeicaoId: refeicaoIds[i],
            alimentoId: alimento['id'],
            nome: alimento['nome'],
            quantidade: parseDouble(alimento['quantidade']),
            kcal: parseDouble(alimento['energia_kcal']),
            prot: parseDouble(alimento['proteinas_g']),
            lip: parseDouble(alimento['lipidios_g']),
            glic: parseDouble(alimento['glicidios_g']),
            cal: parseDouble(alimento['calcio_mg']),
            ferro: parseDouble(alimento['ferro_mg']),
            vitA: parseDouble(alimento['vit_a_mmg']),
            vitC: parseDouble(alimento['vit_c_mg']),
            tiamina: parseDouble(alimento['tiamina_mg']),
            ribo: parseDouble(alimento['riboflavina_mg']),
            niacina: parseDouble(alimento['niacina_mg']),
            sodio: parseDouble(alimento['sodio_mg']),
            fibras: parseDouble(alimento['fibra_alimentar_g']),
          );
          try {
            await repo.insert(model);
            print('Sucesso ao inserir model de alimentos_refeicao');
          } catch (e) {
            print('Erro ao inserir o model de alimentos_refeição: e: $e');
          }
        }
      }
      print(
        "Sucesso ao usar a função salvarRefeicaoAlimentos, salvo com sucesso!",
      );
    } catch (e) {
      print('Erro ao salvar os alimentos, linha 308, erro: $e');
    }
  }

  void _salvarDietaTotal() async {
    try {
      final idDiet = await salvarDieta();
      final idsRefeicao = await salvarRefeicoes(idDiet);
      await salvarRefeicaoAlimentos(idsRefeicao);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Dieta salva com sucesso! dieta ID $idDiet')),
      );
      print('id dieta: $idDiet');
      try {
        print('paciente id: ${paciente!.id!}');
        try {
          final histo = await HistoricoPacienteRepository()
              .buscarUltimoHistPaciente(paciente!.id!);

          if (idDiet != null && histo != null) {
            final historicoAtt = histo.copyWith(dietaId: idDiet);
            print('historicoAtt $historicoAtt');
            await HistoricoPacienteRepository().atualizar(historicoAtt);

            print('Sucesso ao atualizar o historico! id dieta: $historicoAtt');
          }
        } catch (e) {
          print('Erro no ultimohistorico $e');
        }
        /*       print('ultimoHist.pacienteId: ${ultimoHist!.pacienteId}');
        print('ultimoHist.peso: ${ultimoHist.peso}');
        print('ultimoHist.nivelAtv: ${ultimoHist.nivelAtv}');
        print('ultimoHist.dataAtt: ${ultimoHist.dataAtt}');

        if (ultimoHist != null) {
          if (idDiet != null) {*/
        /* final historicoAtt = ultimoHist.copyWith(dietaId: idDiet);
            print('historicoAtt $historicoAtt');
            await HistoricoPacienteRepository().atualizar(historicoAtt);
          
            print('Sucesso ao atualizar o historico! id dieta: $historicoAtt');
          
          }
          print('idDiet é nulo: $idDiet');
        }*/
      } catch (e) {
        print('Erro ao atualizar o historico! Erro: $e');
      }
    } catch (e) {
      print('Erro = $e');
    }

    /*final all = await DietaRepository().joinDieta();
    for (var row in all) {
      print(' ---- REGISTRO -----');
      row.forEach((key, value) {
        print('$key: $value');
      });
    }*/

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => MyApp()),
    );
  }

  Map<String, double> get totaisAtuais => calcularNutris(refeicoes);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: paciente != null ? 'Dieta de ${paciente!.nome}' : 'Criar dieta',
      ),
      drawer: CustomDrawer(
        actions: [
          DrawerActionItem(
            icon: Icons.local_print_shop_outlined,
            label: 'Imprimir',
            onTap: () async {
              Navigator.pop(context);

              final dietaRepo = DietaRepository();
              final teste = await dietaRepo.getAll();

              try {
                if (paciente != null) {
                  print('id do paciente: ${paciente!.id}');
                } else {
                  print('Paciente  nulo.');
                }
              } catch (e) {
                print('Erro ao puxar id do paciente: Error $e');
              }
              try {
                for (var t in teste) {
                  print(
                    'Id: ${t.id}, Nome: ${t.nome}, Data: ${t.dataCriacao}, PacienteId: ${t.pacienteId}',
                  );
                }
                print(
                  'BD dietas está operando normalmente ${dietaCriada.toString()}',
                );
              } catch (e) {
                print('BD dietas NÃO está operando normalmente: ERROR $e');
              }
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text(
                    'Função de impressão será implementada futuramente.',
                  ),
                ),
              );
            },
          ),
        ],
      ),
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
                  Map<String, dynamic> refeicao = entry.value;

                  return Card(
                    key: ValueKey(refeicao['nome']),
                    margin: const EdgeInsets.symmetric(
                      vertical: 6.0,
                      horizontal: 4,
                    ),
                    child: ListTile(
                      title: Text(
                        refeicao['nome'] + ' | ' + refeicao['horario'],
                      ),
                      subtitle: Text(
                        ('\n' + refeicao['observacoes']),
                        maxLines: 3,
                      ),

                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            onPressed: () {
                              setState(() {
                                refeicoes.removeAt(index);
                              });
                            },
                            icon: Icon(Icons.delete_outline_rounded),
                          ),
                          const SizedBox(width: 12),
                          Icon(Icons.drag_handle),
                          const SizedBox(width: 12),
                          Icon(Icons.edit),
                        ],
                      ),
                      onTap: () async {
                        final resultado = await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => EditarDieta(dataRefeicao: refeicao),
                          ),
                        );
                        if (resultado != null && resultado['nome'] != null) {
                          setState(() {
                            refeicoes[index] = resultado;
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
              if (paciente != null)
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: () => _salvarDietaTotal(),
                      label: const Text('Salvar dieta'),
                      icon: const Icon(Icons.save),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
