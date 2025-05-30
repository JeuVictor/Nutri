import 'package:flutter/material.dart';
import './pages/pesquisa_paciente.dart';
import './pages/login.dart';
import './pages/pacientes.dart';
import './pages/myapp.dart';
import './pages/cadastro_paciente.dart';
import './database/db.dart';
import 'package:flutter/foundation.dart';
import './pages/criar_dieta.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

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
      },
    ),
  );
}
