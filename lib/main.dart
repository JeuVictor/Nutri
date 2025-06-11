import 'package:flutter/material.dart';
import 'package:nutri/models/pacientesModels.dart';
import './pages/pesquisa_paciente.dart';
import './pages/login.dart';
import './pages/pacientes.dart';
import './pages/myapp.dart';
import './pages/cadastro_paciente.dart';
import './database/db.dart';
import './pages/usuario.dart';
import './pages/pesquisa_alimentos.dart';
import './pages/criar_dieta.dart';
import './repository/alimento_repository.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await DB.instance.database;
  await popularTabelaAlimentos();

  runApp(
    MaterialApp(
      title: 'Nutri Duda',
      initialRoute: '/',
      routes: {
        '/': (context) => const MyApp(),
        '/login': (context) => const Login(),
        '/pacientes': (context) => const Pacientes(),
        '/cadastro_paciente': (context) => const CadastroPaciente(),
        '/pesquisa_paciente': (context) => const PesquisaPaciente(),
        '/criar_dieta': (context) => CriarDieta(),
        '/usuario': (context) => Usuario(),
        '/pesquisa_alimentos': (context) => PesquisaAlimentos(),
      },

      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [Locale('pt', 'BR')],
    ),
  );
}
