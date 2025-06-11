import 'package:flutter/material.dart';
import 'package:nutri/models/alimento_models.dart';
import '../../repository/alimento_repository.dart';
import '../../widgets/custom_drawer.dart';
import '../../fuctionsApps/custom_app_bar.dart';
import '../../models/dieta_models.dart';
import '../../models/refeicao_models.dart';
import '../../models/refeicao_alimentos_models.dart';
import '../../repository/refeicao_alimento_repository.dart';
import '../../repository/refeicao_repository.dart';

class EditarDieta extends StatefulWidget {
  final Map<String, dynamic> dataRefeicao;
  const EditarDieta({Key? key, required this.dataRefeicao}) : super(key: key);

  @override
  _EditarDietaState createState() => _EditarDietaState();
}

class _EditarDietaState extends State<EditarDieta> {
  late TextEditingController _nomeController;
  late TextEditingController _obsController;
  late TextEditingController _searchController;
  TimeOfDay _horario = TimeOfDay.now();
  List<String> _alimentosFiltrados = [];
  List<AlimentoModels> _alimentosSelecionados = [];

  bool _mostrarBuscaAvancada = true;
  String? _campoSelecionado;
  final TextEditingController _minController = TextEditingController();
  final TextEditingController _maxController = TextEditingController();

  final Map<String, String> _microNutrientes = {
    'energia_kcal': 'Calórias',
    'proteinas_g': 'Proteínas (g)',
    'lipidios_g': 'Lipidios (g)',
    'glicidios_g': 'Glicidios (g)',
    'calcio_mg': 'Calcio (mg)',
    'ferro_mg': 'Ferro (mg)',
    'vit_a_mmg': 'Vitamina A (mmg)',
    'vit_c_mg': 'Vitamina C (mg)',
    'tiamina_mg': 'Tiamina (mg)',
    'riboflavina_mg': 'Riboflavina (mg)',
    'niacina_mg': 'Niacina (mg)',
    'sodio_mg': 'Sódio (mg)',
    'fibra_alimentar_g': 'Fibras alimentares (g)',
  };

  @override
  void initState() {
    super.initState();
    _nomeController = TextEditingController(text: widget.dataRefeicao['nome']);
    _obsController = TextEditingController(
      text: widget.dataRefeicao['observacoes'],
    );

    _searchController = TextEditingController();
    receberAlimentos();
  }

  @override
  void dispose() {
    _nomeController.dispose();
    _obsController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _selecionarHorario() async {
    final TimeOfDay? selecionado = await showTimePicker(
      context: context,
      initialTime: _horario,
      builder: (context, child) {
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: true),
          child: child!,
        );
      },
    );
    if (selecionado != null && selecionado != _horario) {
      setState(() {
        _horario = selecionado;
      });
    }
  }

  void _filtrarAlimentos(String query) async {
    if (query.isEmpty) {
      setState(() => _alimentosFiltrados.clear());
      return;
    }
    final resultados = await AlimentoRepository().buscarAlimentos(query);

    try {
      setState(() {
        _alimentosFiltrados = resultados.map((e) => e.nome).toList();
      });
    } catch (e) {
      print('Erro ao filtrar alimentos: error-> $e');
    }
  }

  void _selecionarAlimentos(String alimento) async {
    _searchController.clear();
    _filtrarAlimentos('');

    final alimentoEscolhido = (await AlimentoRepository().buscarAlimentos(
      alimento,
    )).first;
    final quantidadeStr = await showDialog<String>(
      context: context,
      builder: (context) {
        final controller = TextEditingController();
        return AlertDialog(
          title: Text('Quantidade em gramas'),
          content: TextField(
            controller: controller,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(hintText: 'Ex: 150'),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Cancelar'),
            ),
            ElevatedButton(
              onPressed: () => Navigator.pop(context, controller.text),
              child: Text('Adicionar'),
            ),
          ],
        );
      },
    );
    if (quantidadeStr == null || quantidadeStr.isEmpty) return;
    final quantidade = double.tryParse(quantidadeStr.replaceAll(',', '.')) ?? 0;
    if (quantidade <= 0) return;
    final proporcao = quantidade / 100.0;

    final selecionado = AlimentoModels(
      id: alimentoEscolhido.id,
      nome: alimentoEscolhido.nome,
      quantidade: quantidade,
      energia_kcal: alimentoEscolhido.energia_kcal * proporcao,
      proteinas_g: alimentoEscolhido.proteinas_g * proporcao,
      lipidios_g: alimentoEscolhido.lipidios_g * proporcao,
      glicidios_g: alimentoEscolhido.glicidios_g * proporcao,
      calcio_mg: alimentoEscolhido.calcio_mg * proporcao,
      ferro_mg: alimentoEscolhido.ferro_mg * proporcao,
      vit_a_mmg: alimentoEscolhido.vit_a_mmg * proporcao,
      vit_c_mg: alimentoEscolhido.vit_c_mg * proporcao,
      tiamina_mg: alimentoEscolhido.tiamina_mg * proporcao,
      riboflavina_mg: alimentoEscolhido.riboflavina_mg * proporcao,
      niacina_mg: alimentoEscolhido.niacina_mg * proporcao,
      sodio_mg: alimentoEscolhido.sodio_mg * proporcao,
      fibra_alimentar_g: alimentoEscolhido.fibra_alimentar_g * proporcao,
    );

    setState(() {
      _alimentosSelecionados.add(selecionado);
    });
  }

  void receberAlimentos() {
    final dados = widget.dataRefeicao['alimentos'];

    if (dados != null && dados.length >= 1) {
      for (var item in dados) {
        _alimentosSelecionados.add(AlimentoModels.fromMap(item));
      }
    }
  }

  Widget _buildListarAlimentos() {
    if (_alimentosSelecionados.isEmpty) return SizedBox.shrink();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 16),
        const Text(
          'Alimentos selecionados: ',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        ..._alimentosSelecionados.map(
          (a) => Card(
            child: ListTile(
              title: Text('${a.nome} (${a.quantidade!.toStringAsFixed(0)}g)'),
              subtitle: Text(
                'Kcal: ${a.energia_kcal.toStringAsFixed(1)}, Prot: ${a.proteinas_g.toStringAsFixed(1)}g, Glic: ${a.glicidios_g.toStringAsFixed(1)}g, Lip: ${a.lipidios_g.toStringAsFixed(1)}g',
              ),
              trailing: IconButton(
                icon: Icon(Icons.delete, color: Colors.red),
                onPressed: () {
                  setState(() {
                    _alimentosSelecionados.remove(a);
                  });
                },
              ),
            ),
          ),
        ),
      ],
    );
  }

  AlimentoModels calcularTotais() {
    double kcal = 0,
        carbo = 0,
        prot = 0,
        gord = 0,
        calcio = 0,
        ferro = 0,
        vitA = 0,
        vitc = 0,
        tiamina = 0,
        ribo = 0,
        niacina = 0,
        sodio = 0,
        fibra = 0;
    for (final a in _alimentosSelecionados) {
      kcal += a.energia_kcal;
      carbo += a.glicidios_g;
      prot += a.proteinas_g;
      gord += a.lipidios_g;
      calcio += a.calcio_mg;
      ferro += a.ferro_mg;
      vitA += a.vit_a_mmg;
      vitc += a.vit_c_mg;
      tiamina += a.tiamina_mg;
      ribo += a.riboflavina_mg;
      niacina += a.niacina_mg;
      sodio += a.sodio_mg;
      fibra += a.fibra_alimentar_g;
    }

    return AlimentoModels(
      nome: 'Totais',
      energia_kcal: kcal,
      proteinas_g: prot,
      lipidios_g: gord,
      glicidios_g: carbo,
      calcio_mg: calcio,
      ferro_mg: ferro,
      vit_a_mmg: vitA,
      vit_c_mg: vitc,
      tiamina_mg: tiamina,
      riboflavina_mg: ribo,
      niacina_mg: niacina,
      sodio_mg: sodio,
      fibra_alimentar_g: fibra,
    );
  }

  Widget _buildTotaisNutrientes() {
    final totais = calcularTotais();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 16),
        const Text(
          'Totais da Refeição',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.grey[200],
            borderRadius: BorderRadius.circular(8),
          ),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Kcal: ${totais.energia_kcal.toStringAsFixed(1)}',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Text('Carbo: ${totais.glicidios_g.toStringAsFixed(1)}g'),
                  Text('Prot: ${totais.proteinas_g.toStringAsFixed(1)}g'),
                  Text('Lip: ${totais.lipidios_g.toStringAsFixed(1)}g'),
                ],
              ),
              const SizedBox(height: 8),
              TextButton.icon(
                onPressed: () {
                  _mostrarMicroDialog(totais);
                },
                icon: Icon(Icons.info_outline),
                label: const Text('Ver micronutrientes'),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buscaAvancada() {
    if (_mostrarBuscaAvancada == true) {
      return ExpansionTile(
        title: const Text('Busca Avançada'),
        initiallyExpanded: true,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                DropdownButtonFormField<String>(
                  items: _microNutrientes.entries.map((entry) {
                    return DropdownMenuItem(
                      value: entry.key,
                      child: Text(entry.value),
                    );
                  }).toList(),
                  onChanged: (value) =>
                      setState(() => _campoSelecionado = value!),
                  decoration: const InputDecoration(
                    labelText: 'escolha o micronutriente',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _minController,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          labelText: 'Valor mínimo',
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: TextField(
                        controller: _maxController,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          labelText: 'Valor máximo',
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                ElevatedButton.icon(
                  icon: const Icon(Icons.search),
                  label: const Text('Buscar alimentos'),
                  onPressed: () async {
                    final campo = _campoSelecionado;
                    final min = double.tryParse(
                      _minController.text.replaceAll(',', '.'),
                    );
                    final max = double.tryParse(
                      _maxController.text.replaceAll(',', '.'),
                    );

                    if (campo == null || min == null || max == null) return;

                    final resultado = await AlimentoRepository().buscaAvancada(
                      campo: campo,
                      minimo: min,
                      maximo: max,
                    );

                    setState(() {
                      _alimentosFiltrados = resultado
                          .map((a) => a.nome)
                          .toList();
                      _mostrarBuscaAvancada = false;
                    });
                  },
                ),
              ],
            ),
          ),
        ],
      );
    }

    return TextButton(
      onPressed: () {
        setState(() {
          _mostrarBuscaAvancada = true;
        });
      },
      child: const Text('Busca avançada'),
    );
  }

  Map<String, String> medidaMg(double unidade) {
    String medida = 'mg';
    String valor = unidade.toStringAsFixed(1);
    if (unidade > 999) {
      medida = 'g';
      valor = (unidade / 1000).toStringAsFixed(1);
    } else if (unidade < 1) {
      medida = 'µg';
      valor = (unidade * 1000).toStringAsFixed(1);
    }

    return {'valor': valor, 'medida': medida};
  }

  String textMedidaMg(double valor, String nome) {
    final texto = medidaMg(valor);
    return '$nome: ${texto['valor']} ${texto['medida']}';
  }

  void _mostrarMicroDialog(AlimentoModels totais) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Micronutrientes'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(textMedidaMg(totais.calcio_mg, 'Calcio: ')),
            Text(textMedidaMg(totais.ferro_mg, 'Ferro: ')),
            Text(textMedidaMg(totais.fibra_alimentar_g, 'Fibras: ')),
            Text(textMedidaMg(totais.niacina_mg, 'Niacina: ')),
            Text(textMedidaMg(totais.riboflavina_mg, 'Riboflavina: ')),
            Text(textMedidaMg(totais.sodio_mg, 'Sódio: ')),
            Text(textMedidaMg(totais.tiamina_mg, 'Tiamina: ')),
            Text(textMedidaMg(totais.vit_a_mmg, 'Vit A: ')),
            Text(textMedidaMg(totais.vit_c_mg, 'Vit C: ')),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Fechar"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    final horaFormatada = _horario.format(context);

    return Scaffold(
      appBar: CustomAppBar(title: 'Editar Refeição'),
      drawer: CustomDrawer(),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [
            TextField(
              controller: _nomeController,
              decoration: const InputDecoration(labelText: 'Nome da refeição'),
            ),
            const SizedBox(height: 12),

            Row(
              children: [
                const Text('Horário: ', style: TextStyle(fontSize: 16)),
                const SizedBox(width: 16),
                Text(horaFormatada, style: const TextStyle(fontSize: 16)),
                const SizedBox(width: 8),
                TextButton(
                  onPressed: _selecionarHorario,
                  child: const Text('Mudar horário'),
                ),
              ],
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _searchController,
              decoration: const InputDecoration(
                labelText: 'Buscar Alimentos...',
                prefixIcon: Icon(Icons.search),
              ),
              onChanged: _filtrarAlimentos,
            ),
            const SizedBox(height: 8),
            if (_alimentosFiltrados.isNotEmpty)
              ..._alimentosFiltrados.map(
                (alimento) => ListTile(
                  title: Text(alimento),
                  onTap: () => _selecionarAlimentos(alimento),
                ),
              ),

            _buscaAvancada(),
            _buildListarAlimentos(),
            const SizedBox(height: 16),
            TextField(
              controller: _obsController,
              maxLines: 3,
              decoration: const InputDecoration(
                labelText: 'Observações',
                border: OutlineInputBorder(),
              ),
            ),
            _buildTotaisNutrientes(),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Salvo com sucesso')),
                );
                final resultado = {
                  'nome': _nomeController.text,
                  'horario': horaFormatada.toString(),
                  'observacoes': _obsController.text,
                  'alimentos': _alimentosSelecionados
                      .map((alimento) => alimento.toMap())
                      .toList(),
                  'calcNutri': calcularTotais().toMap(),
                };
                print('Refeção salva!');
                Navigator.pop(context, resultado);
              },
              child: const Text('Salvar'),
            ),
          ],
        ),
      ),
    );
  }
}
