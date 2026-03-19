// ═══════════════════════════════════════════════════════════
//  models.dart — todos os modelos Hive
// ═══════════════════════════════════════════════════════════
import 'package:hive/hive.dart';

part 'models.g.dart';

// ─── Tarefa ─────────────────────────────────────────────────
@HiveType(typeId: 0)
class Tarefa extends HiveObject {
  @HiveField(0) late String id;
  @HiveField(1) late String titulo;
  @HiveField(2) late String descricao;
  @HiveField(3) late String tipo;        // comum | urgente | importante | critica
  @HiveField(4) late String dificuldade; // facil | medio | dificil | epico
  @HiveField(5) late String area;        // trabalho | pessoal | saude | estudos | familia | outro
  @HiveField(6) late bool concluida;
  @HiveField(7) late bool delegada;
  @HiveField(8) late String delegadoPara;
  @HiveField(9) late DateTime? dataPrazo;
  @HiveField(10) late DateTime criadaEm;
  @HiveField(11) late DateTime? concluidaEm;
  @HiveField(12) late int xpGanho;
  @HiveField(13) late bool notificar;
}

// ─── BlocoRotina ────────────────────────────────────────────
@HiveType(typeId: 1)
class BlocoRotina extends HiveObject {
  @HiveField(0) late String id;
  @HiveField(1) late String titulo;
  @HiveField(2) late String horarioInicio; // "06:00"
  @HiveField(3) late String horarioFim;
  @HiveField(4) late String icone;
  @HiveField(5) late String cor;           // hex
  @HiveField(6) late List<int> diasSemana; // 1=seg..7=dom
  @HiveField(7) late bool ativo;
  @HiveField(8) late String descricao;
  @HiveField(9) late bool notificar;
}

// ─── CheckIn ────────────────────────────────────────────────
@HiveType(typeId: 2)
class CheckIn extends HiveObject {
  @HiveField(0) late String id;
  @HiveField(1) late String blocoId;
  @HiveField(2) late String data;   // "yyyy-MM-dd"
  @HiveField(3) late String status; // feito | parcial | pulei
  @HiveField(4) late DateTime registradoEm;
}

// ─── Reuniao ────────────────────────────────────────────────
@HiveType(typeId: 3)
class Reuniao extends HiveObject {
  @HiveField(0) late String id;
  @HiveField(1) late String titulo;
  @HiveField(2) late DateTime dataHora;
  @HiveField(3) late int duracaoMinutos;
  @HiveField(4) late String local;
  @HiveField(5) late String participantes;
  @HiveField(6) late String notas;
  @HiveField(7) late bool notificar;
  @HiveField(8) late String cor;
}

// ─── Compromisso ────────────────────────────────────────────
@HiveType(typeId: 4)
class Compromisso extends HiveObject {
  @HiveField(0) late String id;
  @HiveField(1) late String titulo;
  @HiveField(2) late DateTime dataHora;
  @HiveField(3) late String local;
  @HiveField(4) late String notas;
  @HiveField(5) late bool notificar;
  @HiveField(6) late String tipo; // medico | pessoal | trabalho | outro
  @HiveField(7) late String cor;
}

// ─── EntradaDiario ─────────────────────────────────────────
@HiveType(typeId: 5)
class EntradaDiario extends HiveObject {
  @HiveField(0) late String id;
  @HiveField(1) late String data; // "yyyy-MM-dd"
  @HiveField(2) late String conteudo;
  @HiveField(3) late String humor;   // otimo | bom | neutro | ruim | pessimo
  @HiveField(4) late DateTime criadoEm;
  @HiveField(5) late int energiaNivel; // 1-10
}

// ─── Conquista ─────────────────────────────────────────────
@HiveType(typeId: 6)
class Conquista extends HiveObject {
  @HiveField(0) late String id;
  @HiveField(1) late String titulo;
  @HiveField(2) late String descricao;
  @HiveField(3) late String icone;
  @HiveField(4) late bool desbloqueada;
  @HiveField(5) late DateTime? desbloquadaEm;
  @HiveField(6) late int xpBonus;
}

// ─── Perfil ─────────────────────────────────────────────────
@HiveType(typeId: 7)
class Perfil extends HiveObject {
  @HiveField(0) late String nome;
  @HiveField(1) late String descricao;
  @HiveField(2) late int xpTotal;
  @HiveField(3) late int nivel;
  @HiveField(4) late int streakAtual;
  @HiveField(5) late int streakMaximo;
  @HiveField(6) late String? fotoPath;
  @HiveField(7) late DateTime? ultimoCheckin;
  @HiveField(8) late int totalTarefasConcluidas;
  @HiveField(9) late int totalBlocosFeitos;
}
