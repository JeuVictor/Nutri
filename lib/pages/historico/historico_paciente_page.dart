import 'dart:math';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:nutri/models/pacientesModels.dart';
import '../../models/historico_paciente_models.dart';
import '../../models/histotico_completo_model.dart';
import '../../repository/historico_paciente_repository.dart';
import '../../fuctionsApps/custom_app_bar.dart';
import '../../fuctionsApps/graficoPaciente.dart';

class HistoricoPacientePage extends StatefulWidget {
  final int pacienteId;

  const HistoricoPacientePage({super.key, required this.pacienteId});

  @override
  State<HistoricoPacientePage> createState() => _HistoricoPacienteState();
}

class _HistoricoPacienteState extends State<HistoricoPacientePage> {
  List<HistoricoPaciente> historico = [];
  HistoticoCompletoModel? historicoCompleto;

  int _currentePage = 0;
  int? _selectIndex = 0;
  @override
  void initState() {
    super.initState();
    carregarHistorico();
  }

  String formartDataHora(String dataIso, bool comHora) {
    final data = DateTime.parse(dataIso);
    final formato;

    if (comHora == true) {
      formato = DateFormat('dd/MM/yy \n HH:mm', 'pt_BR');
    } else {
      formato = DateFormat('dd/MM/yy', 'pt_BR');
    }
    return formato.format(data);
  }

  Future<void> carregarHistorico() async {
    final result = await HistoricoPacienteRepository().buscarPorPaciente(
      widget.pacienteId,
    );

    setState(() {
      historico = result;
      if (historico.isNotEmpty) {
        _selectIndex = 0;
        carregarHistoricoCompleto(historico[0].id!);
      }
    });
  }

  Future<void> carregarHistoricoCompleto(int histId) async {
    final result = await HistoricoPacienteRepository().getHistoricoCompleto(
      histId,
    );
    setState(() {
      historicoCompleto = result;
    });
  }

  Widget _timeLineArrow({required int correntPage}) {
    if (correntPage > 0) {
      return IconButton(
        icon: const Icon(Icons.double_arrow_sharp),

        onPressed: () {
          setState(() {
            _currentePage--;
            _selectIndex = null;
          });
        },
      );
    } else {
      return SizedBox();
    }
  }

  Widget _cabecalhoPaciente(Pacientesmodels pac) {
    final idade = pac.idade;

    return ExpansionTile(
      title: Row(
        children: [
          Expanded(
            child: Text(
              pac.nome ?? 'Sem nome',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          SizedBox(width: 15),
          Row(children: const [Text("Mais detalhes")]),
        ],
      ),
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _infoTexto("Idade", "${pac.idade ?? '-----'} anos"),
              _infoTexto("Email", pac.email ?? '-----'),
              _infoTexto("Celular", pac.celular ?? '-----'),
              _infoTexto("Nível de atividade", pac.nivelAtividade ?? '-----'),
              _infoTexto("Sexo", pac.sexo ?? '-----'),
              _infoTexto("Altura", "${pac.altura?.toString() ?? '-----'} cm"),

              const SizedBox(height: 8),
              _infoTexto(
                "Cadastrado em",
                formartDataHora(pac.dataCriacao, false),
              ),
            ],
          ),
        ),
      ],
    );
  }

  double get imc {
    double altura = historicoCompleto!.paciente!.altura / 100;
    return historicoCompleto!.paciente!.peso / (altura * altura);
  }

  String get imcStr {
    if (imc < 18.5) return 'Magreza';
    if (imc < 25) return 'Normal';
    if (imc < 30) return 'Sobrepeso';
    if (imc < 40) return 'Obesidade';
    return "Obesidade grave";
  }

  Widget _composicaoMetabolica(Pacientesmodels pac) {
    return ExpansionTile(
      title: const Text("Composição Corporal e Metabolismo"),
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _infoTexto("Peso atual", "${pac.peso.toStringAsFixed(1)} kg"),
              if (pac.peso_alvo > 1)
                _infoTexto(
                  "Peso alvo",
                  "${pac.peso_alvo.toStringAsFixed(1)} kg",
                ),

              _infoTexto("IMC", "${imc.toStringAsFixed(1)} - $imcStr"),
              _infoTexto(
                "Gordura corporal",
                "${pac.gordura.toStringAsFixed(1)} %",
              ),
              _infoTexto(
                "Massa muscular",
                "${pac.musculo.toStringAsFixed(1)} %",
              ),
              const SizedBox(height: 8),
              _infoTexto(
                "Taxa metabólica basal",
                "${pac.calBasal.toStringAsFixed(0)} kcal",
              ),
              _infoTexto("GET", "${pac.calcKcall.toStringAsFixed(0)} kcal"),
              _infoTexto("Nível de atividade", pac.nivelAtividade),
              const SizedBox(height: 8),
              _infoTexto(
                "Carboidratos (50%)",
                "${pac.carboidratros.toStringAsFixed(0)} g",
              ),
              _infoTexto(
                "Proteínas (25%)",
                "${pac.proteina.toStringAsFixed(0)} g",
              ),
              _infoTexto(
                "Lipídios (25%)",
                "${pac.lipidios.toStringAsFixed(0)} g",
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _infoTexto(String titulo, String valor) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: 2,
      ), // controla o espaçamento
      child: RichText(
        text: TextSpan(
          style: TextStyle(fontSize: 15, color: Colors.black),
          children: [
            TextSpan(
              text: "$titulo: ",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            TextSpan(text: valor),
          ],
        ),
      ),
    );
  }

  Widget _cardHorarioHistorico({
    required int maxVible,
    required int currentPage,
    required double setaWidth,
  }) {
    return SizedBox(
      height: 100,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: (maxVible * (currentPage + 1)).clamp(0, historico.length),
        itemBuilder: (context, index) {
          int startIndex = currentPage * maxVible;
          if (index < startIndex || index >= startIndex + maxVible) {
            return const SizedBox.shrink();
          }
          final h = historico[index];
          return GestureDetector(
            onTap: () {
              setState(() {
                _selectIndex = index;
              });
              carregarHistoricoCompleto(historico[index].id!);
            },
            child: Container(
              width: setaWidth.clamp(80, 140),
              margin: const EdgeInsets.symmetric(horizontal: 4),
              padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
              decoration: BoxDecoration(
                color: Colors.transparent,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.transparent),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.double_arrow_outlined,
                    size: 40,
                    color: _selectIndex == index
                        ? Colors.blue
                        : Colors.grey.shade600,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    formartDataHora(h.dataAtt, true),
                    style: TextStyle(
                      fontSize: 10,
                      color: _selectIndex == index
                          ? Colors.blue
                          : Colors.grey.shade800,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _iconForward_ios({required int currentPage, required int maxVisible}) {
    if ((currentPage + 1) * maxVisible < historico.length) {
      return IconButton(
        onPressed: () {
          setState(() {
            _currentePage++;
            _selectIndex = null;
          });
        },
        icon: Icon(Icons.arrow_forward_ios),
      );
    } else {
      return SizedBox();
    }
  }

  Widget _detalhesHistorico() {
    if (_selectIndex != null) {
      return Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: _buildDetalhes(historico[_selectIndex!]),
            ),
          ],
        ),
      );
    } else {
      return Padding(
        padding: EdgeInsets.all(12),
        child: Text('Selecione um registro para ver os detalhes.'),
      );
    }
  }

  Widget _buildDetalhes(HistoricoPaciente h) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Peso: ${h.peso.toStringAsFixed(1)} kg'),
        if (h.gordura != null)
          Text('Gordura: ${h.gordura!.toStringAsFixed(1)}%'),
        if (h.musculo != null)
          Text('Musculo: ${h.musculo!.toStringAsFixed(1)}%'),

        Text('Nivel de atividade: ${h.nivelAtv}'),

        if (h.imc != null) Text('IMC: ${h.imc!.toStringAsFixed(1)}%'),
        if (h.img != null) Text('IMG: ${h.img!.toStringAsFixed(1)}%'),
        if (h.pesoAlvo != null)
          Text('Peso alvo: ${h.pesoAlvo!.toStringAsFixed(1)}%'),
        if (h.obs != null && h.obs!.trim().isNotEmpty)
          Text('Observações: ${h.obs}'),
      ],
    );
  }

  /*
  Widget buildHistoricoDieta(List<HistoticoCompletoModel> historico) {
    return ListView.builder(
      itemCount: historico.length,
      itemBuilder: (context, index) {
        final item = historico[index];
        return Card(
          margin: const EdgeInsets.all(12),
          child: ExpansionTile(
            title: Text(item.dieta?.nome ?? 'Dieta'),
            subtitle: Text("Criada em ${item.dieta?.dataCriacao ?? '----'}"),
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  "Frequência: ${item.dieta?.frequencia ?? '---'}\nObs: ${item.dieta?.obs ?? ""}",
                ),
              ),
              ...?item.refeicoes?.map((refeicao) {
                final ref = refeicao.refeicao;
                final alimentos = refeicao.alimentos;

                final corAleatoria = _corAleatoria(ref.nome.hashCode);

                return Card(
                  color: corAleatoria.withOpacity(0.1),
                  margin: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "${ref.nome} - ${ref.horario}",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: corAleatoria,
                        ),
                      ),
                      if (ref.observacoes.trim().isNotEmpty)
                        Padding(
                          padding: const EdgeInsets.only(top: 4.0),
                          child: Text(
                            "Obs: ${ref.observacoes}",
                            style: const TextStyle(fontStyle: FontStyle.italic),
                          ),
                        ),
                      const SizedBox(height: 8),
                      ...alimentos.map(
                        (alimento) => Padding(
                          padding: const EdgeInsets.symmetric(vertical: 2),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(child: Text(alimento.nome)),
                              Text(
                                "${alimento.quantidade.toStringAsFixed(0)}g",
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              }),
            ],
          ),
        );
      },
    );
  }
*/
  Color _corAleatoria(int seed) {
    final random = Random(seed);

    return Colors.primaries[random.nextInt(Colors.primaries.length)];
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    int total = historico.length;
    int maxVisible = 8;
    int pageCount = (total / maxVisible).ceil();
    int currentPage = _currentePage;

    double setaWidth = screenWidth / (total > maxVisible ? maxVisible : total);
    setaWidth = setaWidth.clamp(50, 150);

    // TODO: implement build
    return Scaffold(
      appBar: CustomAppBar(title: 'Historico do paciente'),
      body: historico.isEmpty
          ? const Center(child: Text('Nenhum histórico registrado.'))
          : Column(
              children: [
                Row(
                  children: [
                    _timeLineArrow(correntPage: currentPage),

                    Expanded(
                      child: _cardHorarioHistorico(
                        currentPage: currentPage,
                        maxVible: maxVisible,
                        setaWidth: setaWidth,
                      ),
                    ),
                    _iconForward_ios(
                      currentPage: currentPage,
                      maxVisible: maxVisible,
                    ),
                  ],
                ),
                Expanded(
                  child: historicoCompleto == null
                      ? Center(child: Text('Selecione um registro.'))
                      : ListView(
                          children: [
                            _cabecalhoPaciente(historicoCompleto!.paciente),
                            _composicaoMetabolica(historicoCompleto!.paciente),
                            Graficopaciente(
                              pesoAtual: historicoCompleto!.paciente!.peso,
                              pesoAlvo: historicoCompleto!.paciente!.peso_alvo,
                              carbo: historicoCompleto!.paciente!.carboidratros,
                              lip: historicoCompleto!.paciente!.lipidios,
                              prot: historicoCompleto!.paciente!.proteina,
                            ),
                            // buildHistoricoDieta([historicoCompleto!]),
                          ],
                        ),
                ),
              ],
            ),
    );
  }
}
