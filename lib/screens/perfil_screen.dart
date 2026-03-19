// ═══════════════════════════════════════════════════════════
//  perfil_screen.dart
// ═══════════════════════════════════════════════════════════
import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:provider/provider.dart';

import '../services/app_state.dart';
import '../theme/app_theme.dart';
import '../widgets/xp_badge.dart';

class PerfilScreen extends StatefulWidget {
  const PerfilScreen({super.key});

  @override
  State<PerfilScreen> createState() => _PerfilScreenState();
}

class _PerfilScreenState extends State<PerfilScreen> {
  @override
  Widget build(BuildContext context) {
    return Consumer<AppState>(builder: (context, state, _) {
      final p = state.perfil;
      return Scaffold(
        backgroundColor: AppTheme.bg,
        appBar: AppBar(
          title: const Text('👤 Perfil'),
          actions: [
            IconButton(
              icon: const Icon(Icons.edit_rounded),
              onPressed: () => _showEditDialog(context, state),
              tooltip: 'Editar perfil',
            ),
          ],
        ),
        body: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // Avatar + info
            Card(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    CircleAvatar(
                      radius: 40,
                      backgroundColor: AppTheme.accent.withOpacity(0.2),
                      child: Text(
                        p.nome.isNotEmpty ? p.nome[0].toUpperCase() : 'A',
                        style: const TextStyle(
                            color: AppTheme.accentLight,
                            fontSize: 32,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(p.nome,
                        style: const TextStyle(
                            color: AppTheme.text,
                            fontSize: 20,
                            fontWeight: FontWeight.bold)),
                    if (p.descricao.isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.only(top: 4),
                        child: Text(p.descricao,
                            style: const TextStyle(
                                color: AppTheme.textMuted, fontSize: 13),
                            textAlign: TextAlign.center),
                      ),
                    const SizedBox(height: 16),
                    XpBadge(
                      nivel: p.nivel,
                      xpAtual: p.xpTotal,
                      xpProximo: AppTheme.xpParaNivel(p.nivel),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 8),

            // Stats rápidas
            Row(
              children: [
                _StatCard(
                    label: 'Tarefas\nconcluídas',
                    value: '${p.totalTarefasConcluidas}',
                    icon: Icons.task_alt_rounded,
                    color: AppTheme.green),
                const SizedBox(width: 8),
                _StatCard(
                    label: 'Blocos\nfeitos',
                    value: '${p.totalBlocosFeitos}',
                    icon: Icons.check_circle_rounded,
                    color: AppTheme.blue),
                const SizedBox(width: 8),
                _StatCard(
                    label: 'Streak\nmáximo',
                    value: '${p.streakMaximo}🔥',
                    icon: Icons.local_fire_department_rounded,
                    color: AppTheme.orange),
              ],
            ),
            const SizedBox(height: 8),

            // Guia XP
            _buildXpGuide(),
            const SizedBox(height: 8),

            // Segurança
            _buildSeguranca(context),
            const SizedBox(height: 80),
          ],
        ),
      );
    });
  }

  Widget _buildXpGuide() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('⚡ Guia de XP',
                style: TextStyle(
                    color: AppTheme.text, fontWeight: FontWeight.w600)),
            const SizedBox(height: 12),
            ...[
              ('Criar tarefa', '+5 XP', AppTheme.blue),
              ('Delegar tarefa', '+3 XP', AppTheme.blue),
              ('Bloco Feito ✅', '+10 XP', AppTheme.green),
              ('Bloco Parcial ⚡', '+5 XP', AppTheme.orange),
              ('Streak a cada 3 dias', '+30 XP', AppTheme.gold),
              ('Tarefa Comum × Fácil', '15 XP', AppTheme.green),
              ('Tarefa Comum × Épico', '75 XP', AppTheme.green),
              ('Tarefa Crítica × Fácil', '60 XP', AppTheme.red),
              ('Tarefa Crítica × Épico', '300 XP', AppTheme.red),
            ].map((item) => Padding(
                  padding: const EdgeInsets.only(bottom: 6),
                  child: Row(
                    children: [
                      Text(item.$1,
                          style: const TextStyle(
                              color: AppTheme.textMuted, fontSize: 12)),
                      const Spacer(),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(
                          color: item.$3.withOpacity(0.15),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(item.$2,
                            style: TextStyle(
                                color: item.$3,
                                fontSize: 12,
                                fontWeight: FontWeight.bold)),
                      ),
                    ],
                  ),
                )),
          ],
        ),
      ),
    );
  }

  Widget _buildSeguranca(BuildContext context) {
    final box = Hive.box('config');
    final lockType = box.get('lockType', defaultValue: 'none') as String;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('🔒 Segurança',
                style: TextStyle(
                    color: AppTheme.text, fontWeight: FontWeight.w600)),
            const SizedBox(height: 12),
            Row(
              children: [
                Icon(
                  lockType == 'none'
                      ? Icons.lock_open_rounded
                      : Icons.lock_rounded,
                  color: lockType == 'none' ? AppTheme.textMuted : AppTheme.green,
                  size: 18,
                ),
                const SizedBox(width: 8),
                Text(
                  lockType == 'none'
                      ? 'Sem proteção'
                      : 'Protegido com ${lockType == "pin" ? "PIN" : "senha"}',
                  style: const TextStyle(color: AppTheme.textMuted, fontSize: 13),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              children: [
                if (lockType == 'none') ...[
                  ElevatedButton.icon(
                    icon: const Icon(Icons.pin_rounded, size: 16),
                    label: const Text('Configurar PIN'),
                    onPressed: () => _showLockSetup(context, 'pin'),
                    style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 8)),
                  ),
                  OutlinedButton.icon(
                    icon: const Icon(Icons.password_rounded, size: 16),
                    label: const Text('Configurar senha'),
                    onPressed: () => _showLockSetup(context, 'password'),
                    style: OutlinedButton.styleFrom(
                        foregroundColor: AppTheme.accentLight,
                        side: const BorderSide(color: AppTheme.accent),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 8)),
                  ),
                ] else
                  OutlinedButton.icon(
                    icon: const Icon(Icons.lock_open_rounded, size: 16),
                    label: const Text('Remover proteção'),
                    onPressed: () {
                      box.put('lockType', 'none');
                      box.delete('lockHash');
                      setState(() {});
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Proteção removida')),
                      );
                    },
                    style: OutlinedButton.styleFrom(
                        foregroundColor: AppTheme.red,
                        side: const BorderSide(color: AppTheme.red),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 8)),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _showLockSetup(BuildContext context, String type) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppTheme.surface,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      builder: (_) => _LockSetupSheet(
        type: type,
        onSaved: () => setState(() {}),
      ),
    );
  }

  void _showEditDialog(BuildContext context, AppState state) {
    final nomeCtrl = TextEditingController(text: state.perfil.nome);
    final descCtrl = TextEditingController(text: state.perfil.descricao);
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppTheme.surface,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      builder: (_) => Padding(
        padding: EdgeInsets.only(
            left: 24, right: 24, top: 24,
            bottom: MediaQuery.of(context).viewInsets.bottom + 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Editar Perfil',
                style: TextStyle(
                    color: AppTheme.text, fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            TextField(
              controller: nomeCtrl,
              decoration: const InputDecoration(labelText: 'Nome'),
              style: const TextStyle(color: AppTheme.text),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: descCtrl,
              decoration: const InputDecoration(labelText: 'Descrição'),
              style: const TextStyle(color: AppTheme.text),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  final p = state.perfil;
                  p.nome = nomeCtrl.text.trim();
                  p.descricao = descCtrl.text.trim();
                  p.save();
                  state.notifyListeners();
                  Navigator.pop(context);
                },
                child: const Text('Salvar'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── StatCard ─────────────────────────────────────────────
class _StatCard extends StatelessWidget {
  final String label, value;
  final IconData icon;
  final Color color;
  const _StatCard(
      {required this.label, required this.value, required this.icon, required this.color});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: AppTheme.card,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppTheme.divider),
        ),
        child: Column(
          children: [
            Icon(icon, color: color, size: 22),
            const SizedBox(height: 6),
            Text(value,
                style: TextStyle(
                    color: color, fontWeight: FontWeight.bold, fontSize: 16)),
            Text(label,
                style:
                    const TextStyle(color: AppTheme.textMuted, fontSize: 10),
                textAlign: TextAlign.center),
          ],
        ),
      ),
    );
  }
}

// ─── LockSetupSheet ───────────────────────────────────────
class _LockSetupSheet extends StatefulWidget {
  final String type;
  final VoidCallback onSaved;
  const _LockSetupSheet({required this.type, required this.onSaved});

  @override
  State<_LockSetupSheet> createState() => _LockSetupSheetState();
}

class _LockSetupSheetState extends State<_LockSetupSheet> {
  String _pin = '';
  String _confirm = '';
  bool _confirmStep = false;
  final _passCtrl = TextEditingController();
  final _confirmCtrl = TextEditingController();
  bool _showPass = false;
  String _error = '';

  String _hash(String v) => sha256.convert(utf8.encode(v)).toString();

  @override
  Widget build(BuildContext context) {
    final isPin = widget.type == 'pin';
    return Padding(
      padding: EdgeInsets.only(
          left: 24, right: 24, top: 24,
          bottom: MediaQuery.of(context).viewInsets.bottom + 24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            isPin
                ? (_confirmStep ? 'Confirme o PIN' : 'Criar PIN de 6 dígitos')
                : (_confirmStep ? 'Confirme a senha' : 'Criar senha'),
            style: const TextStyle(
                color: AppTheme.text, fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          if (isPin) ...[
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(6, (i) {
                final val = _confirmStep ? _confirm : _pin;
                final filled = i < val.length;
                return Container(
                  margin: const EdgeInsets.symmetric(horizontal: 6),
                  width: 16, height: 16,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: filled ? AppTheme.accent : AppTheme.divider,
                    border: Border.all(
                        color: filled ? AppTheme.accent : AppTheme.textMuted),
                  ),
                );
              }),
            ),
            const SizedBox(height: 24),
            GridView.count(
              crossAxisCount: 3,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              mainAxisSpacing: 8, crossAxisSpacing: 8,
              childAspectRatio: 1.8,
              children: ['1','2','3','4','5','6','7','8','9','','0','⌫'].map((b) {
                if (b.isEmpty) return const SizedBox();
                return InkWell(
                  onTap: () {
                    setState(() {
                      final cur = _confirmStep ? _confirm : _pin;
                      if (b == '⌫') {
                        if (cur.isNotEmpty) {
                          if (_confirmStep) _confirm = _confirm.substring(0, _confirm.length - 1);
                          else _pin = _pin.substring(0, _pin.length - 1);
                        }
                      } else if (cur.length < 6) {
                        if (_confirmStep) _confirm += b;
                        else _pin += b;
                      }
                      _error = '';
                    });
                    final cur = _confirmStep ? _confirm : _pin;
                    if (!_confirmStep && _pin.length == 6) {
                      Future.delayed(const Duration(milliseconds: 150), () {
                        setState(() => _confirmStep = true);
                      });
                    } else if (_confirmStep && _confirm.length == 6) {
                      Future.delayed(const Duration(milliseconds: 150), () => _salvar());
                    }
                  },
                  borderRadius: BorderRadius.circular(10),
                  child: Container(
                    decoration: BoxDecoration(
                      color: AppTheme.card,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: AppTheme.divider),
                    ),
                    child: Center(
                      child: b == '⌫'
                          ? const Icon(Icons.backspace_outlined, color: AppTheme.textMuted, size: 20)
                          : Text(b, style: const TextStyle(color: AppTheme.text, fontSize: 20)),
                    ),
                  ),
                );
              }).toList(),
            ),
          ] else ...[
            TextField(
              controller: _passCtrl,
              obscureText: !_showPass,
              decoration: InputDecoration(
                labelText: 'Nova senha (mín. 6 caracteres)',
                suffixIcon: IconButton(
                  icon: Icon(_showPass ? Icons.visibility_off : Icons.visibility,
                      color: AppTheme.textMuted),
                  onPressed: () => setState(() => _showPass = !_showPass),
                ),
              ),
              style: const TextStyle(color: AppTheme.text),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _confirmCtrl,
              obscureText: !_showPass,
              decoration: const InputDecoration(labelText: 'Confirmar senha'),
              style: const TextStyle(color: AppTheme.text),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _salvar,
                child: const Text('Salvar senha'),
              ),
            ),
          ],
          if (_error.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(top: 12),
              child: Text(_error,
                  style: const TextStyle(color: AppTheme.red),
                  textAlign: TextAlign.center),
            ),
        ],
      ),
    );
  }

  void _salvar() {
    final box = Hive.box('config');
    if (widget.type == 'pin') {
      if (_pin.length != 6 || _confirm.length != 6) {
        setState(() => _error = 'PIN deve ter 6 dígitos');
        return;
      }
      if (_pin != _confirm) {
        setState(() {
          _error = 'PINs não coincidem';
          _confirm = '';
          _confirmStep = false;
          _pin = '';
        });
        return;
      }
      box.put('lockType', 'pin');
      box.put('lockHash', _hash(_pin));
    } else {
      final p = _passCtrl.text;
      final c = _confirmCtrl.text;
      if (p.length < 6) {
        setState(() => _error = 'Senha deve ter ao menos 6 caracteres');
        return;
      }
      if (p != c) {
        setState(() => _error = 'Senhas não coincidem');
        return;
      }
      box.put('lockType', 'password');
      box.put('lockHash', _hash(p));
    }
    widget.onSaved();
    if (context.mounted) Navigator.pop(context);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Proteção configurada com sucesso!')),
    );
  }
}
