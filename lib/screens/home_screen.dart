// ═══════════════════════════════════════════════════════════
//  home_screen.dart — shell com bottom navigation
// ═══════════════════════════════════════════════════════════
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../services/app_state.dart';
import '../theme/app_theme.dart';
import '../widgets/level_up_overlay.dart';
import 'rotina_screen.dart';
import 'tarefas_screen.dart';
import 'reunioes_screen.dart';
import 'compromissos_screen.dart';
import 'diario_screen.dart';
import 'stats_screen.dart';
import 'perfil_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;
  int? _levelUpNivel;
  int _lastNivel = 0;

  final List<Widget> _screens = const [
    RotinaScreen(),
    TarefasScreen(),
    ReunioesScreen(),
    CompromissosScreen(),
    DiarioScreen(),
    StatsScreen(),
    PerfilScreen(),
  ];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final state = context.read<AppState>();
      state.inicializarConquistas();
      _lastNivel = state.perfil.nivel;
    });
  }

  void _checkLevelUp(AppState state) {
    final novoNivel = state.perfil.nivel;
    if (novoNivel > _lastNivel && _lastNivel > 0) {
      setState(() => _levelUpNivel = novoNivel);
    }
    _lastNivel = novoNivel;
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AppState>(
      builder: (context, state, _) {
        WidgetsBinding.instance.addPostFrameCallback((_) => _checkLevelUp(state));

        return Stack(
          children: [
            Scaffold(
              backgroundColor: AppTheme.bg,
              body: IndexedStack(
                index: _currentIndex,
                children: _screens,
              ),
              bottomNavigationBar: _buildNavBar(),
            ),
            if (_levelUpNivel != null)
              Positioned.fill(
                child: LevelUpOverlay(
                  novoNivel: _levelUpNivel!,
                  onClose: () => setState(() => _levelUpNivel = null),
                ),
              ),
          ],
        );
      },
    );
  }

  Widget _buildNavBar() {
    final items = [
      const BottomNavigationBarItem(icon: Icon(Icons.view_day_rounded), label: 'Rotina'),
      const BottomNavigationBarItem(icon: Icon(Icons.task_alt_rounded), label: 'Tarefas'),
      const BottomNavigationBarItem(icon: Icon(Icons.groups_rounded), label: 'Reuniões'),
      const BottomNavigationBarItem(icon: Icon(Icons.event_rounded), label: 'Compromissos'),
      const BottomNavigationBarItem(icon: Icon(Icons.auto_stories_rounded), label: 'Diário'),
      const BottomNavigationBarItem(icon: Icon(Icons.bar_chart_rounded), label: 'Stats'),
      const BottomNavigationBarItem(icon: Icon(Icons.person_rounded), label: 'Perfil'),
    ];

    return Container(
      decoration: const BoxDecoration(
        border: Border(top: BorderSide(color: AppTheme.divider)),
      ),
      child: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (i) => setState(() => _currentIndex = i),
        items: items,
        selectedFontSize: 10,
        unselectedFontSize: 10,
      ),
    );
  }
}
