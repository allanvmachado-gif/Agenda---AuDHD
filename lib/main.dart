// ═══════════════════════════════════════════════════════════
//  Agenda Allan — main.dart
// ═══════════════════════════════════════════════════════════
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';
import 'package:timezone/data/latest.dart' as tz;

import 'models/models.dart';
import 'services/app_state.dart';
import 'services/notification_service.dart';
import 'theme/app_theme.dart';
import 'widgets/lock_screen.dart';
import 'screens/home_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Hive
  await Hive.initFlutter();
  Hive.registerAdapter(TarefaAdapter());
  Hive.registerAdapter(BlocoRotinaAdapter());
  Hive.registerAdapter(CheckInAdapter());
  Hive.registerAdapter(ReuniaoAdapter());
  Hive.registerAdapter(CompromissoAdapter());
  Hive.registerAdapter(EntradaDiarioAdapter());
  Hive.registerAdapter(ConquistaAdapter());
  Hive.registerAdapter(PerfilAdapter());

  await Hive.openBox<Tarefa>('tarefas');
  await Hive.openBox<BlocoRotina>('blocos');
  await Hive.openBox<CheckIn>('checkins');
  await Hive.openBox<Reuniao>('reunioes');
  await Hive.openBox<Compromisso>('compromissos');
  await Hive.openBox<EntradaDiario>('diario');
  await Hive.openBox<Conquista>('conquistas');
  await Hive.openBox<Perfil>('perfil');
  await Hive.openBox('config');

  // Timezone e Notificações
  tz.initializeTimeZones();
  await NotificationService.instance.initialize();

  // Orientação
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  runApp(
    ChangeNotifierProvider(
      create: (_) => AppState(),
      child: const AgendaAllanApp(),
    ),
  );
}

class AgendaAllanApp extends StatelessWidget {
  const AgendaAllanApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Agenda Allan',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.dark(),
      home: const AppRoot(),
    );
  }
}

class AppRoot extends StatefulWidget {
  const AppRoot({super.key});

  @override
  State<AppRoot> createState() => _AppRootState();
}

class _AppRootState extends State<AppRoot> {
  bool _unlocked = false;
  bool _checkingLock = true;

  @override
  void initState() {
    super.initState();
    _checkLock();
  }

  Future<void> _checkLock() async {
    final box = Hive.box('config');
    final lockType = box.get('lockType', defaultValue: 'none') as String;
    setState(() {
      _unlocked = lockType == 'none';
      _checkingLock = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_checkingLock) {
      return const Scaffold(
        backgroundColor: Color(0xFF0F0F1A),
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (!_unlocked) {
      return LockScreen(onUnlocked: () => setState(() => _unlocked = true));
    }

    return const HomeScreen();
  }
}
