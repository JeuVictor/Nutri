import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import './../../database/composicao_alimentos.dart';

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
        _alimentosFiltrados = composicaoQuimicaAlimentos;
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

  Future<void> _selecionarHorario() async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: _horario ?? TimeOfDay.now(),
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
    });
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(title: Text('Editar Refeição')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
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
            SizedBox(height: 16),
            TextField(
              controller: _obsController,
              maxLines: 5,
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
            Expanded(
              child: ListView.builder(
                itemCount: _alimentosFiltrados.length,
                itemBuilder: (context, index) {
                  final alimento = _alimentosFiltrados[index];
                  return ListTile(
                    title: Text(alimento['Alimento' ?? '']),
                    subtitle: Text(
                      'Kcal: ${alimento['Energia (kcal)']} | Prot: ${alimento['Proteínas (g)']}g',
                    ),
                    onTap: () {
                      //Acao ao escolher.
                    },
                  );
                },
              ),
            ),
            Spacer(),
            ElevatedButton.icon(
              onPressed: _salvar,
              icon: Icon(Icons.save),
              label: Text('Salvar'),
            ),
          ],
        ),
      ),
    );
  }
}
