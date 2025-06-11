import 'dart:io';
import 'package:flutter/material.dart';
import '../models/usuario_model.dart';
import '../repository/usuario_repository.dart';
import '../models/usuario_model.dart';
import '../fuctionsApps/custom_app_bar.dart';
import '../widgets/custom_drawer.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';

class Usuario extends StatefulWidget {
  const Usuario({super.key});

  @override
  State<Usuario> createState() => _UsuarioState();
}

class _UsuarioState extends State<Usuario> {
  final _formKey = GlobalKey<FormState>();
  final _repo = UsuarioRepository();
  UsuarioModel? _usuario;
  bool _editando = false;
  bool atualizar = false;

  final nomeCtrl = TextEditingController();
  final crnCtrl = TextEditingController();
  final telCtrl = TextEditingController();
  final emailCtrl = TextEditingController();
  final espCtrl = TextEditingController();
  final enderecoCtrl = TextEditingController();
  String? caminhoImg;
  String? corTema;

  @override
  void initState() {
    super.initState();
    _carregarUsuario();
  }

  Future<void> _carregarUsuario() async {
    final usuario = await _repo.obterUsuario();

    if (usuario != null) {
      setState(() {
        _usuario = usuario;
        nomeCtrl.text = usuario.nome;
        crnCtrl.text = usuario.crn;
        telCtrl.text = usuario.telefone;
        emailCtrl.text = usuario.email ?? 'exemplo@nutri.com';
        espCtrl.text = usuario.esp ?? '';
        enderecoCtrl.text = usuario.endereco ?? '';
        caminhoImg = usuario.caminhoImg;
        corTema = usuario.corTema;
      });
    }
  }

  Future<void> _salvar() async {
    if (_formKey.currentState!.validate()) {
      final novoUsuario = UsuarioModel(
        id: _usuario?.id,
        nome: nomeCtrl.text,
        crn: crnCtrl.text,
        telefone: telCtrl.text,
        email: emailCtrl.text,
        esp: espCtrl.text,
        endereco: enderecoCtrl.text,
        caminhoImg: caminhoImg,
        corTema: corTema,
      );

      if (_usuario == null) {
        await _repo.inserirUsuario(novoUsuario);
      } else {
        await _repo.atualizarUsuario(novoUsuario);
      }

      setState(() {
        _editando = false;
        _usuario = novoUsuario;
      });
    }
  }

  Widget _colorBtn(
    Color? corAtual,
    bool editando,
    ValueChanged<String> onCorSelecionada,
    BuildContext context,
  ) {
    corAtual ??= Colors.grey.shade300;

    return Stack(
      children: [
        Positioned.fill(
          child: Container(
            height: 40,
            decoration: BoxDecoration(
              color: corAtual.withOpacity(0.2),
              borderRadius: BorderRadius.circular(6),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
          child: Row(
            children: [
              const Text(
                'Cor do tema:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(width: 12),
              Tooltip(
                message:
                    'Essa cor será utilizada futuramente como tema dos PDFs dos pacientes.',
                child: const Icon(Icons.info_outline, size: 24),
              ),
              const Spacer(),

              GestureDetector(
                onTap: editando
                    ? () => _mostrarDialogoCores(context, onCorSelecionada)
                    : null,
                child: Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: corAtual,
                    border: Border.all(color: Colors.black26),
                  ),
                  child: editando
                      ? const Icon(Icons.edit, size: 18, color: Colors.white)
                      : null,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  void _mostrarDialogoCores(BuildContext context, ValueChanged<String> onCor) {
    List<Color> cores = [
      Colors.blue,
      Colors.green,
      Colors.purple,
      Colors.red,
      Colors.orange,
      Colors.teal,
      Colors.brown,
      Colors.pink,
      Colors.indigo,
    ];

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Escolha uma cor"),
        content: Wrap(
          spacing: 10,
          runSpacing: 10,
          children: cores
              .map(
                (cor) => GestureDetector(
                  onTap: () {
                    onCor(cor.value.toRadixString(16));
                    Navigator.of(context).pop();
                  },
                  child: Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      color: cor,
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.black26),
                    ),
                  ),
                ),
              )
              .toList(),
        ),
      ),
    );
  }

  Future<void> _selecionarImagem() async {
    final picker = ImagePicker();
    final img = await picker.pickImage(source: ImageSource.gallery);

    if (img != null) {
      setState(() {
        caminhoImg = img.path;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: 'Perfil do Usuário',
        actions: _editando
            ? []
            : [
                IconButton(
                  onPressed: () => setState(() => _editando = true),
                  icon: const Icon(Icons.edit_square),
                ),
              ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              Center(
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    GestureDetector(
                      onTap: _editando ? _selecionarImagem : null,
                      child: CircleAvatar(
                        radius: 48,
                        backgroundImage: caminhoImg != null
                            ? FileImage(File(caminhoImg!))
                            : null,
                        child: caminhoImg == null
                            ? const Icon(Icons.person_rounded, size: 48)
                            : null,
                      ),
                    ),
                    if (_editando)
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: CircleAvatar(
                          radius: 16,
                          backgroundColor: Colors.black54,
                          child: const Icon(
                            Icons.camera_alt_outlined,
                            size: 18,
                            color: Colors.white,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: nomeCtrl,
                enabled: _editando,
                decoration: const InputDecoration(labelText: "Nome completo"),
                validator: (v) => v!.isEmpty ? 'Obrigatorio' : null,
              ),
              TextFormField(
                controller: crnCtrl,
                enabled: _editando,
                decoration: const InputDecoration(
                  labelText: "N° inscrição CRN",
                ),
                validator: (v) => v!.isEmpty ? 'Obrigatorio' : null,
              ),
              TextFormField(
                controller: telCtrl,
                enabled: _editando,
                decoration: const InputDecoration(
                  labelText: "Whatsapp ou Celular",
                ),
                validator: (v) => v!.isEmpty ? 'Obrigatorio' : null,
              ),
              TextFormField(
                controller: emailCtrl,
                enabled: _editando,
                decoration: const InputDecoration(
                  labelText: "Email profissional:",
                ),
              ),
              TextFormField(
                controller: espCtrl,
                enabled: _editando,
                decoration: const InputDecoration(
                  labelText: "Especialidade e/ou descrição",
                ),
              ),
              TextFormField(
                controller: enderecoCtrl,
                enabled: _editando,
                decoration: const InputDecoration(
                  labelText: "Endereço Profissional",
                ),
              ),
              const SizedBox(height: 16),

              _colorBtn(corTema?.toColor(), _editando, (novaCor) {
                setState(() {
                  corTema = novaCor;
                });
              }, context),
              const SizedBox(height: 16),
              if (_editando)
                ElevatedButton.icon(
                  icon: Icon(Icons.save),
                  onPressed: _salvar,
                  label: const Text("Salvar"),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
