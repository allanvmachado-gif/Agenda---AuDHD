// ═══════════════════════════════════════════════════════════
//  app_state.dart — ChangeNotifier central
// ═══════════════════════════════════════════════════════════
import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';

import '../models/models.dart';
import '../theme/app_theme.dart';
import 'notification_service.dart';

class AppState extends ChangeNotifier {
  final _uuid = const Uuid();
  DateTime _dataSelecionada = DateTime.now();

  DateTime get dataSelecionada => _dataSelecionada;

  // ─── Boxes ───────────────────────────────────────────────
  Box<Tarefa> get boxTarefas => Hive.box<Tarefa>('tarefas');
  Box<BlocoRotina> get boxBlocos => Hive.box<BlocoRotina>('blocos');
  Box<CheckIn> get boxCheckins => Hive.box<CheckIn>('checkins');
  Box<Reuniao> get boxReunioes => Hive.box<Reuniao>('reunioes');
  Box<Compromisso> get boxCompromissos => Hive.box<Compromisso>('compromissos');
  Box<EntradaDiario> get boxDiario => Hive.box<EntradaDiario>('diario');
  Box<Conquista> get boxConquistas => Hive.box<Conquista>('conquistas');
  Box<Perfil> get boxPerfil => Hive.box<Perfil>('perfil');
  Box get boxConfig => Hive.box('config');

  // ─── Perfil ──────────────────────────────────────────────
  Perfil get perfil {
    if (boxPerfil.isEmpty) {
      final p = Perfil()
        ..nome = 'Allan Vinicius'
        ..descricao = 'Minha agenda pessoal'
        ..xpTotal = 0
        ..nivel = 1
        ..streakAtual = 0
        ..streakMaximo = 0
        ..fotoPath = null
        ..ultimoCheckin = null
        ..totalTarefasConcluidas = 0
        ..totalBlocosFeitos = 0;
      boxPerfil.add(p);
      return p;
    }
    return boxPerfil.getAt(0)!;
  }

  void _salvarPerfil(Perfil p) {
    p.save();
    notifyListeners();
  }

  // ─── Navegação de data ───────────────────────────────────
  void setDataSelecionada(DateTime d) {
    _dataSelecionada = DateTime(d.year, d.month, d.day);
    notifyListeners();
  }

  void avancarDia() => setDataSelecionada(_dataSelecionada.add(const Duration(days: 1)));
  void voltarDia() => setDataSelecionada(_dataSelecionada.subtract(const Duration(days: 1)));
  void irParaHoje() => setDataSelecionada(DateTime.now());

  String get dataFormatada => DateFormat("EEEE, d 'de' MMMM", 'pt_BR').format(_dataSelecionada);
  String get dataChave => DateFormat('yyyy-MM-dd').format(_dataSelecionada);
  bool get isHoje {
    final hoje = DateTime.now();
    return _dataSelecionada.year == hoje.year &&
        _dataSelecionada.month == hoje.month &&
        _dataSelecionada.day == hoje.day;
  }

  // ─── Blocos de Rotina ────────────────────────────────────
  List<BlocoRotina> get blocosAtivos {
    final diaSemana = _dataSelecionada.weekday; // 1=seg..7=dom
    return boxBlocos.values
        .where((b) => b.ativo && b.diasSemana.contains(diaSemana))
        .toList()
      ..sort((a, b) => a.horarioInicio.compareTo(b.horarioInicio));
  }

  List<BlocoRotina> get todosOsBlocos => boxBlocos.values.toList()
    ..sort((a, b) => a.horarioInicio.compareTo(b.horarioInicio));

  Future<void> adicionarBloco(BlocoRotina bloco) async {
    await boxBlocos.add(bloco);
    if (bloco.notificar) _agendarNotificacaoBloco(bloco);
    notifyListeners();
  }

  Future<void> editarBloco(BlocoRotina bloco) async {
    await bloco.save();
    NotificationService.instance.cancel(NotificationService.hashId(bloco.id));
    if (bloco.notificar) _agendarNotificacaoBloco(bloco);
    notifyListeners();
  }

  Future<void> deletarBloco(BlocoRotina bloco) async {
    NotificationService.instance.cancel(NotificationService.hashId(bloco.id));
    await bloco.delete();
    notifyListeners();
  }

  void _agendarNotificacaoBloco(BlocoRotina bloco) {
    final parts = bloco.horarioInicio.split(':');
    final h = int.tryParse(parts[0]) ?? 0;
    final m = int.tryParse(parts[1]) ?? 0;
    NotificationService.instance.scheduleDailyNotification(
      id: NotificationService.hashId(bloco.id),
      title: '${bloco.icone} ${bloco.titulo}',
      body: 'Hora de começar! ${bloco.horarioInicio} - ${bloco.horarioFim}',
      hour: h,
      minute: m,
      payload: 'bloco:${bloco.id}',
    );
  }

  // ─── Check-in ────────────────────────────────────────────
  CheckIn? getCheckIn(String blocoId, String data) {
    try {
      return boxCheckins.values.firstWhere(
          (c) => c.blocoId == blocoId && c.data == data);
    } catch (_) {
      return null;
    }
  }

  Future<void> registrarCheckIn(String blocoId, String status) async {
    final data = dataChave;
    final existing = getCheckIn(blocoId, data);
    if (existing != null) {
      existing.status = status;
      existing.registradoEm = DateTime.now();
      await existing.save();
    } else {
      final ci = CheckIn()
        ..id = _uuid.v4()
        ..blocoId = blocoId
        ..data = data
        ..status = status
        ..registradoEm = DateTime.now();
      await boxCheckins.add(ci);
    }
    await _atualizarXpCheckIn(status);
    await _verificarStreak();
    await _verificarConquistas();
    notifyListeners();
  }

  Future<void> _atualizarXpCheckIn(String status) async {
    final p = perfil;
    int xp = 0;
    if (status == 'feito') xp = 10;
    else if (status == 'parcial') xp = 5;
    p.xpTotal += xp;
    p.totalBlocosFeitos += (status == 'feito' ? 1 : 0);
    p.nivel = AppTheme.calcularNivel(p.xpTotal);
    _salvarPerfil(p);
  }

  // ─── Score do dia ────────────────────────────────────────
  double calcularScoreDia(String data) {
    final blocos = boxBlocos.values
        .where((b) => b.ativo)
        .toList();
    if (blocos.isEmpty) return 0;

    final diaSemana = _parseDiaFromData(data);
    final blocosNoDia = blocos
        .where((b) => b.diasSemana.contains(diaSemana))
        .toList();
    if (blocosNoDia.isEmpty) return 0;

    double total = 0;
    for (final b in blocosNoDia) {
      final ci = getCheckIn(b.id, data);
      if (ci == null) continue;
      if (ci.status == 'feito') total += 1.0;
      else if (ci.status == 'parcial') total += 0.5;
    }
    return total / blocosNoDia.length;
  }

  int _parseDiaFromData(String data) {
    try {
      return DateTime.parse(data).weekday;
    } catch (_) {
      return 1;
    }
  }

  double get scoreDiaAtual => calcularScoreDia(dataChave);

  // ─── Streak ──────────────────────────────────────────────
  Future<void> _verificarStreak() async {
    final p = perfil;
    final hoje = DateFormat('yyyy-MM-dd').format(DateTime.now());
    final ontem = DateFormat('yyyy-MM-dd').format(
        DateTime.now().subtract(const Duration(days: 1)));

    if (p.ultimoCheckin == null) {
      p.streakAtual = 1;
      p.ultimoCheckin = DateTime.now();
    } else {
      final ultimo = DateFormat('yyyy-MM-dd').format(p.ultimoCheckin!);
      if (ultimo == hoje) {
        // já contou
      } else if (ultimo == ontem) {
        p.streakAtual++;
        p.ultimoCheckin = DateTime.now();
        // bônus streak a cada 3 dias
        if (p.streakAtual % 3 == 0) {
          p.xpTotal += 30;
          p.nivel = AppTheme.calcularNivel(p.xpTotal);
        }
      } else {
        p.streakAtual = 1;
        p.ultimoCheckin = DateTime.now();
      }
    }
    if (p.streakAtual > p.streakMaximo) p.streakMaximo = p.streakAtual;
    _salvarPerfil(p);
  }

  // ─── Tarefas ─────────────────────────────────────────────
  List<Tarefa> get tarefasPendentes => boxTarefas.values
      .where((t) => !t.concluida)
      .toList()
    ..sort((a, b) {
      final prioA = _prioridadeTipo(a.tipo);
      final prioB = _prioridadeTipo(b.tipo);
      return prioB.compareTo(prioA);
    });

  List<Tarefa> get tarefasConcluidas => boxTarefas.values
      .where((t) => t.concluida)
      .toList()
    ..sort((a, b) => (b.concluidaEm ?? DateTime.now())
        .compareTo(a.concluidaEm ?? DateTime.now()));

  int _prioridadeTipo(String tipo) {
    switch (tipo) {
      case 'critica': return 4;
      case 'importante': return 3;
      case 'urgente': return 2;
      default: return 1;
    }
  }

  Future<Tarefa> adicionarTarefa({
    required String titulo,
    String descricao = '',
    String tipo = 'comum',
    String dificuldade = 'medio',
    String area = 'pessoal',
    bool delegada = false,
    String delegadoPara = '',
    DateTime? dataPrazo,
    bool notificar = false,
  }) async {
    final xp = AppTheme.calcularXP(tipo, dificuldade);
    final t = Tarefa()
      ..id = _uuid.v4()
      ..titulo = titulo
      ..descricao = descricao
      ..tipo = tipo
      ..dificuldade = dificuldade
      ..area = area
      ..concluida = false
      ..delegada = delegada
      ..delegadoPara = delegadoPara
      ..dataPrazo = dataPrazo
      ..criadaEm = DateTime.now()
      ..concluidaEm = null
      ..xpGanho = xp
      ..notificar = notificar;
    await boxTarefas.add(t);

    // +5 XP por criar tarefa
    final p = perfil;
    p.xpTotal += 5;
    if (delegada) p.xpTotal += 3;
    p.nivel = AppTheme.calcularNivel(p.xpTotal);
    _salvarPerfil(p);

    // Agendar notificação
    if (notificar && dataPrazo != null) {
      final lembrete = dataPrazo.subtract(const Duration(minutes: 15));
      await NotificationService.instance.scheduleNotification(
        id: NotificationService.hashId(t.id),
        title: '⏰ ${t.titulo}',
        body: 'Tarefa em 15 minutos! (${t.tipo} · ${t.dificuldade})',
        scheduledDate: lembrete,
        high: tipo == 'critica' || tipo == 'urgente',
        payload: 'tarefa:${t.id}',
      );
    }

    notifyListeners();
    return t;
  }

  Future<void> concluirTarefa(Tarefa t) async {
    t.concluida = true;
    t.concluidaEm = DateTime.now();
    await t.save();

    final p = perfil;
    p.xpTotal += t.xpGanho;
    p.totalTarefasConcluidas++;
    p.nivel = AppTheme.calcularNivel(p.xpTotal);
    _salvarPerfil(p);

    NotificationService.instance.cancel(NotificationService.hashId(t.id));
    await _verificarConquistas();
    notifyListeners();
  }

  Future<void> deletarTarefa(Tarefa t) async {
    NotificationService.instance.cancel(NotificationService.hashId(t.id));
    await t.delete();
    notifyListeners();
  }

  // ─── Reuniões ────────────────────────────────────────────
  List<Reuniao> get reunioes => boxReunioes.values.toList()
    ..sort((a, b) => a.dataHora.compareTo(b.dataHora));

  Future<void> adicionarReuniao(Reuniao r) async {
    await boxReunioes.add(r);
    if (r.notificar) {
      final lembrete = r.dataHora.subtract(const Duration(minutes: 15));
      await NotificationService.instance.scheduleNotification(
        id: NotificationService.hashId(r.id),
        title: '📋 ${r.titulo}',
        body: 'Reunião em 15 minutos${r.local.isNotEmpty ? " — ${r.local}" : ""}',
        scheduledDate: lembrete,
        payload: 'reuniao:${r.id}',
      );
    }
    notifyListeners();
  }

  Future<void> deletarReuniao(Reuniao r) async {
    NotificationService.instance.cancel(NotificationService.hashId(r.id));
    await r.delete();
    notifyListeners();
  }

  // ─── Compromissos ────────────────────────────────────────
  List<Compromisso> get compromissos => boxCompromissos.values.toList()
    ..sort((a, b) => a.dataHora.compareTo(b.dataHora));

  Future<void> adicionarCompromisso(Compromisso c) async {
    await boxCompromissos.add(c);
    if (c.notificar) {
      final lembrete = c.dataHora.subtract(const Duration(minutes: 15));
      await NotificationService.instance.scheduleNotification(
        id: NotificationService.hashId(c.id),
        title: '📅 ${c.titulo}',
        body: 'Compromisso em 15 minutos${c.local.isNotEmpty ? " — ${c.local}" : ""}',
        scheduledDate: lembrete,
        payload: 'compromisso:${c.id}',
      );
    }
    notifyListeners();
  }

  Future<void> deletarCompromisso(Compromisso c) async {
    NotificationService.instance.cancel(NotificationService.hashId(c.id));
    await c.delete();
    notifyListeners();
  }

  // ─── Diário ──────────────────────────────────────────────
  EntradaDiario? getEntradaDiario(String data) {
    try {
      return boxDiario.values.firstWhere((e) => e.data == data);
    } catch (_) {
      return null;
    }
  }

  Future<void> salvarEntradaDiario(EntradaDiario entrada) async {
    final existing = getEntradaDiario(entrada.data);
    if (existing != null) {
      existing.conteudo = entrada.conteudo;
      existing.humor = entrada.humor;
      existing.energiaNivel = entrada.energiaNivel;
      await existing.save();
    } else {
      await boxDiario.add(entrada);
    }
    notifyListeners();
  }

  // ─── Conquistas ──────────────────────────────────────────
  Future<void> inicializarConquistas() async {
    if (boxConquistas.isNotEmpty) return;
    final conquistas = [
      _mkConquista('primeira_marca', '🌟 Primeira Marca', 'Registre seu primeiro check-in', '🌟', 20),
      _mkConquista('seq_3', '🔥 3 em Sequência', 'Mantenha streak de 3 dias', '🔥', 30),
      _mkConquista('semana_completa', '💪 Semana Completa', '7 dias de streak', '💪', 100),
      _mkConquista('dia_perfeito', '💎 Dia Perfeito', 'Score de 100% em um dia', '💎', 50),
      _mkConquista('seq_10', '🚀 10 em Sequência', '10 dias de streak', '🚀', 200),
      _mkConquista('tarefa_critica', '⚔️ Caçador de Desafios', 'Conclua uma tarefa Crítica', '⚔️', 60),
      _mkConquista('tarefas_10', '📋 Executor', 'Conclua 10 tarefas', '📋', 80),
      _mkConquista('tarefas_50', '🏆 Campeão', 'Conclua 50 tarefas', '🏆', 250),
      _mkConquista('diario_3', '📓 Diário Ativo', 'Escreva 3 entradas no diário', '📓', 30),
      _mkConquista('nivel_5', '⭐ Proficiente', 'Alcance o nível 5', '⭐', 150),
      _mkConquista('nivel_max', '👑 Grão-Mestre', 'Alcance o nível máximo', '👑', 500),
      _mkConquista('delegou', '🤝 Líder Eficiente', 'Delegue uma tarefa', '🤝', 20),
    ];
    for (final c in conquistas) await boxConquistas.add(c);
  }

  Conquista _mkConquista(String id, String titulo, String desc, String icone, int xp) {
    return Conquista()
      ..id = id
      ..titulo = titulo
      ..descricao = desc
      ..icone = icone
      ..desbloqueada = false
      ..desbloquadaEm = null
      ..xpBonus = xp;
  }

  Future<void> _verificarConquistas() async {
    await inicializarConquistas();
    final p = perfil;
    final desbloqueadas = <String>[];

    Future<void> desbloquear(String id) async {
      try {
        final c = boxConquistas.values.firstWhere((c) => c.id == id);
        if (!c.desbloqueada) {
          c.desbloqueada = true;
          c.desbloquadaEm = DateTime.now();
          await c.save();
          p.xpTotal += c.xpBonus;
          desbloqueadas.add(c.titulo);
          await NotificationService.instance.showImmediate(
            id: NotificationService.hashId('conquista_$id'),
            title: '🏅 Conquista Desbloqueada!',
            body: c.titulo,
            high: true,
          );
        }
      } catch (_) {}
    }

    // Verificações
    final checkins = boxCheckins.values.toList();
    if (checkins.isNotEmpty) await desbloquear('primeira_marca');
    if (p.streakAtual >= 3) await desbloquear('seq_3');
    if (p.streakAtual >= 7) await desbloquear('semana_completa');
    if (p.streakAtual >= 10) await desbloquear('seq_10');
    if (scoreDiaAtual >= 1.0) await desbloquear('dia_perfeito');
    if (p.totalTarefasConcluidas >= 10) await desbloquear('tarefas_10');
    if (p.totalTarefasConcluidas >= 50) await desbloquear('tarefas_50');
    if (boxDiario.length >= 3) await desbloquear('diario_3');
    if (p.nivel >= 5) await desbloquear('nivel_5');
    if (p.nivel >= 8) await desbloquear('nivel_max');

    final tCritica = boxTarefas.values.any((t) => t.concluida && t.tipo == 'critica');
    if (tCritica) await desbloquear('tarefa_critica');

    final tDelegada = boxTarefas.values.any((t) => t.delegada);
    if (tDelegada) await desbloquear('delegou');

    p.nivel = AppTheme.calcularNivel(p.xpTotal);
    _salvarPerfil(p);
  }

  // ─── Estatísticas ─────────────────────────────────────────
  Map<String, double> getScores30Dias() {
    final scores = <String, double>{};
    for (int i = 29; i >= 0; i--) {
      final d = DateTime.now().subtract(Duration(days: i));
      final key = DateFormat('yyyy-MM-dd').format(d);
      scores[key] = calcularScoreDia(key);
    }
    return scores;
  }

  double get mediaScore30Dias {
    final scores = getScores30Dias().values.where((v) => v > 0).toList();
    if (scores.isEmpty) return 0;
    return scores.reduce((a, b) => a + b) / scores.length;
  }

  int get diasComCheckin {
    final datas = boxCheckins.values.map((c) => c.data).toSet();
    return datas.length;
  }
}
