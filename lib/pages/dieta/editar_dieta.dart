import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import './../../database/composicao_alimentos.dart';
import './../criar_dieta.dart';

class EditarDieta extends StatefulWidget {
  final String nomeInicial;

  EditarDieta({required this.nomeInicial});

  @override
  _EditarDietaState createState() => _EditarDietaState();
}

class _EditarDietaState extends State<EditarDieta> {
  late TextEditingController _nomeController;
  TimeOfDay? _horario;
  TextEditingController _obsController = TextEditingController();

  List<Map<String, dynamic>> _alimentos = [];
  List<Map<String, dynamic>> _alimentosFiltrados = [];
  List<Map<String, dynamic>> _alimentosSelecionados = [];

  TextEditingController _buscarController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _nomeController = TextEditingController(text: widget.nomeInicial);
    _carregarAlimentos();
  }

  Future<void> _carregarAlimentos() async {
    try {
      setState(() {
        _alimentos = composicaoQuimicaAlimentos;
        _alimentosFiltrados = [];
      });
      print('Dados carregado com sucesso:');
    } catch (e) {
      print('Erro ao carregar json: $e');
    }
  }

  void _filtrarAlimentos(String query) {
    setState(() {
      _alimentosFiltrados = _alimentos.where((alimento) {
        final nome = alimento['Alimento']?.toString().toLowerCase() ?? '';
        return nome.contains(query.toLowerCase());
      }).toList();
    });
  }

  void _selecionarAlimento(Map<String, dynamic> alimento) {
    if (!_alimentosSelecionados.contains(alimento)) {
      setState(() {
        _alimentosSelecionados.add(alimento);
        _buscarController.clear();
        _alimentosFiltrados.clear();
      });
    }
  }

  void _mostrarDetalhes(Map<String, dynamic> alimentos) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(alimentos['Alimento'] ?? 'Detalhes'),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: alimentos.entries
                .where((e) => e.key.isNotEmpty && e.value.toString().isNotEmpty)
                .map(
                  (e) => Padding(
                    padding: const EdgeInsets.symmetric(vertical: 2),
                    child: Text('${e.key}: ${e.value}'),
                  ),
                )
                .toList(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Fechar'),
          ),
        ],
      ),
    );
  }

  Future<void> _selecionarHorario() async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: _horario ?? TimeOfDay.now(),
      builder: (context, child) {
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: true),
          child: child!,
        );
      },
    );
    if (picked != null) {
      setState(() {
        _horario = picked;
      });
    }
  }

  void _salvar() {
    Navigator.pop(context, {
      'nome': _nomeController.text,
      'horario': _horario,
      'obs': _obsController.text,
      'alimentos': _alimentosSelecionados,
    });
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

  Widget _buildResumoNutricional(
    double kcal,
    double carbo,
    double lipid,
    double protein,
  ) {
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
                valor: kcal,
                icon: Icons.local_fire_department,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _infoNutricional(
                    cor: Colors.green,
                    label: 'Carboídratos',
                    valor: carbo,
                    icon: Icons.breakfast_dining,
                  ),
                  _infoNutricional(
                    cor: Colors.blue,
                    label: 'Proteínas',
                    valor: protein,
                    icon: Icons.fitness_center,
                  ),
                  _infoNutricional(
                    cor: Colors.pink,
                    label: 'Lipídios',
                    valor: lipid,
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

  @override
  Widget build(BuildContext context) {
    final double totalKcal = _alimentosSelecionados.fold(
      0,
      (sum, a) => sum + double.tryParse(a['Energia (kcal)'] ?? '0')!,
    );
    final double totalCarb = _alimentosSelecionados.fold(
      0,
      (sum, a) => sum + double.tryParse(a['Glicídios (g)'] ?? '0')!,
    );
    final double totalProt = _alimentosSelecionados.fold(
      0,
      (sum, a) => sum + double.tryParse(a['Proteínas (g)'] ?? '0')!,
    );
    final double totalLip = _alimentosSelecionados.fold(
      0,
      (sum, a) => sum + double.tryParse(a['Lipídios (g)'] ?? '0')!,
    );

    Widget totalCard = Card(
      color: Colors.grey[200],
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildResumoNutricional(totalKcal, totalCarb, totalLip, totalProt),
        ],
      ),
    );

    // TODO: implement build
    return Scaffold(
      appBar: AppBar(title: Text('Editar Refeição')),
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextField(
                    controller: _nomeController,
                    decoration: InputDecoration(labelText: 'Nome da refeição'),
                  ),
                  SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          _horario == null
                              ? 'Horário recomendado: não definido'
                              : 'Horário: ${_horario!.format(context)}',
                        ),
                      ),
                      TextButton(
                        onPressed: _selecionarHorario,
                        child: Text('Selecionar horário'),
                      ),
                    ],
                  ),
                  if (_alimentosSelecionados.isNotEmpty) ...[
                    Divider(),
                    Text(
                      'Refeição: ',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    ListView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: _alimentosSelecionados.length,
                      itemBuilder: (context, index) {
                        final alimento = _alimentosSelecionados[index];
                        return ListTile(
                          dense: true,
                          title: Text(alimento['Alimento'] ?? ''),
                          subtitle: Text(
                            'Kcal: ${alimento['Energia (kcal)']} | Prot: ${alimento['Proteínas (g)']}g',
                          ),
                          trailing: IconButton(
                            onPressed: () {
                              setState(() {
                                _alimentosSelecionados.removeAt(index);
                              });
                            },
                            icon: Icon(Icons.remove_circle_outline),
                          ),
                        );
                      },
                    ),
                    if (_buscarController.text.isEmpty) totalCard,
                  ],

                  SizedBox(height: 16),
                  TextField(
                    controller: _obsController,
                    maxLines: 3,
                    decoration: InputDecoration(
                      labelText: 'Observações',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  SizedBox(height: 16),
                  TextField(
                    controller: _buscarController,
                    decoration: InputDecoration(
                      labelText: 'Buscar alimento',
                      prefixIcon: Icon(Icons.search),
                    ),
                    onChanged: _filtrarAlimentos,
                  ),

                  SizedBox(height: 16),
                  if (_buscarController.text.isNotEmpty)
                    ListView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: _alimentosFiltrados.length,
                      itemBuilder: (context, index) {
                        final alimento = _alimentosFiltrados[index];
                        return ListTile(
                          title: Text(alimento['Alimento'] ?? ''),
                          subtitle: Text(
                            'Kcal: ${alimento['Energia (kcal)']} | Carb: ${alimento['Glicídios (g)']}g | Prot: ${alimento['Proteínas (g)']}g | Lip: ${alimento['Lipídios (g)']}g',
                          ),
                          trailing: IconButton(
                            onPressed: () => _mostrarDetalhes(alimento),
                            icon: Icon(Icons.info_outline),
                          ),
                          onTap: () => _selecionarAlimento(alimento),
                        );
                      },
                    ),

                  SizedBox(height: 10),
                  ElevatedButton.icon(
                    onPressed: _salvar,
                    icon: Icon(Icons.save),
                    label: Text('Salvar'),
                  ),
                ],
              ),
            ),
          ),
          if (_buscarController.text.isNotEmpty)
            Positioned(
              left: 16,
              right: 16,
              top: 0,
              child: Material(
                elevation: 6,
                borderRadius: BorderRadius.circular(12),
                child: totalCard,
              ),
            ),
        ],
      ),
    );
  }
}
