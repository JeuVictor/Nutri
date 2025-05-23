

class Cadastropacientescontroller {
  double calcularGorduraCorporal({
    required double peso,
    required double alturaCm,
    required int idade,
    required String sexo,
  }){
    final alturaM = alturaCm / 100;
    final imc = peso/(alturaM * alturaM);
    final s = sexo.toLowerCase() == 'masculino' ? 1:0 ;
    return (1.2 * imc) - (10.8 * s) + (0.23 * idade) - 5.4;
  }
}