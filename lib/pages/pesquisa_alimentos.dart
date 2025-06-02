import 'package:flutter/material.dart';
import 'package:nutri/pages/cadastro_paciente.dart';
import 'package:nutri/repository/alimento_repository.dart';
import '../../models/alimento_models.dart';
import '../../repository/pacientes_repository.dart';

class editarDieta extends StatefulWidget {
  const editarDieta({Key? key}) : super(key: key);

  @override
  State<editarDieta> createState() => _editarDietaState();
}

class _editarDietaState extends State<editarDieta> {
  List<AlimentoModels> alimentos = [];

  @override
  void initState() {
    super.initState();
    _carregarAlimentos();
  }

  Future<void> _carregarAlimentos() async {
    final dados = await AlimentoRepository().listarAlimentos();
    setState(() {
      alimentos = dados;
    });
  }

  Future<void> _deletarAlimento(AlimentoModels alimento) async {
    final confirmar = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirmar exclusão'),
        content: Text('Tem certeza que deseja excluir ${alimento.nome}?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Excluir', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );

    if (confirmar == true) {
      await AlimentoRepository().deletarAlimentos(alimento.id!);
      _carregarAlimentos();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('${alimento.nome} excluído com sucesso.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Alimentos')),
      body: alimentos.isEmpty
          ? Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    'Sem alimentos cadastro.',
                    style: TextStyle(fontSize: 18),
                  ),
                  const SizedBox(height: 12),
                  ElevatedButton.icon(
                    onPressed: () async {
                      const Text('Botão precionado!');
                    },
                    icon: const Icon(Icons.person_add),
                    label: const Text('Clique aqui para cadastrar.'),
                  ),
                ],
              ),
            )
          : ListView.builder(
              itemCount: alimentos.length,
              itemBuilder: (context, index) {
                final alimento = alimentos[index];
                return Card(
                  elevation: 4,
                  margin: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadiusGeometry.circular(12),
                  ),
                  child: ListTile(
                    title: Text(
                      alimento.nome,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(
                      'Proteina: ${alimento.proteinas_g.toString()} g, Kcal ${alimento.energia_kcal.toString()} g, Lipidios: ${alimento.lipidios_g.toString()} g',
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          onPressed: () => _deletarAlimento(alimento),
                          icon: const Icon(Icons.delete, color: Colors.red),
                        ),
                        const Icon(Icons.arrow_forward_ios, size: 16),
                      ],
                    ),
                    onTap: () async {
                      const Text('Botão precionado!');
                    },
                  ),
                );
              },
            ),
    );
  }
}
