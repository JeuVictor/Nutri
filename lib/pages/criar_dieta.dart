import 'package:flutter/material.dart';
import './dieta/editar_dieta.dart';

class CriarDieta extends StatefulWidget {
  @override
  _CriarDieta createState() => _CriarDieta();
}

class _CriarDieta extends State<CriarDieta> {
  List<String> refeicoes = ['Café da manhã', 'Almoço', 'Jantar'];

  void _adicionarRefeicao() {
    setState(() {
      refeicoes.add('Nova Refeição ${refeicoes.length + 1}');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Criar dieta')),
      body: Column(
        children: [
          Expanded(
            child: ReorderableListView(
              onReorder: (oldIndex, newIndex) {
                setState(() {
                  if (newIndex > oldIndex) newIndex--;
                  final item = refeicoes.removeAt(oldIndex);
                  refeicoes.insert(newIndex, item);
                });
              },
              children: [
                for (int index = 0; index < refeicoes.length; index++)
                  ListTile(
                    key: ValueKey(refeicoes[index]),
                    title: Text(refeicoes[index]),
                    trailing: Icon(Icons.drag_handle),
                    onTap: () async {
                      final resultado = await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) =>
                              EditarDieta(nomeInicial: refeicoes[index]),
                        ),
                      );
                      if (resultado != null && resultado['nome'] != null) {
                        setState(() {
                          refeicoes[index] = resultado['nome'];
                        });
                      }
                    },
                  ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton.icon(
              onPressed: _adicionarRefeicao,
              label: Text('Criar uma nova refeição'),
              icon: Icon(Icons.add),
            ),
          ),
        ],
      ),
    );
  }
}
