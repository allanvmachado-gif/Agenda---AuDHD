// ═══════════════════════════════════════════════════════════
//  diario_screen.dart
// ═══════════════════════════════════════════════════════════
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

import '../models/models.dart';
import '../services/app_state.dart';
import '../theme/app_theme.dart';

class DiarioScreen extends StatefulWidget {
  const DiarioScreen({super.key});

  @override
  State<DiarioScreen> createState() => _DiarioScreenState();
}

class _DiarioScreenState extends State<DiarioScreen> {
  @override
  Widget build(BuildContext context) {
    return Consumer<AppState>(builder: (context, state, _) {
      return Scaffold(
        backgroundColor: AppTheme.bg,
        appBar: AppBar(
          title: const Text('📓 Diário'),
          actions: [
            IconButton(
              icon: const Icon(Icons.edit_rounded),
              onPressed: () => _showEntradaDialog(context, state),
              tooltip: 'Nova entrada',
            ),
          ],
        ),
        body: _buildBody(context, state),
        floatingActionButton: FloatingActionButton(
          onPressed: () => _showEntradaDialog(context, state),
          child: const Icon(Icons.add_rounded),
        ),
      );
    });
  }

  Widget _buildBody(BuildContext context, AppState state) {
    final entradas = state.boxDiario.values.toList()
      ..sort((a, b) => b.data.compareTo(a.data));

    if (entradas.isEmpty) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.auto_stories_rounded, color: AppTheme.textMuted, size: 48),
            SizedBox(height: 16),
            Text('Nenhuma entrada no diário ainda',
                style: TextStyle(color: AppTheme.textMuted)),
            SizedBox(height: 8),
            Text('Registre seu dia, humor e energia',
                style: TextStyle(color: AppTheme.textMuted, fontSize: 12)),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.only(bottom: 80),
      itemCount: entradas.length,
      itemBuilder: (_, i) => _EntradaCard(
        entrada: entradas[i],
        onEdit: () => _showEntradaDialog(context, state, existing: entradas[i]),
      ),
    );
  }

  void _showEntradaDialog(BuildContext context, AppState state,
      {EntradaDiario? existing}) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppTheme.surface,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      builder: (_) => _EntradaForm(state: state, existing: existing),
    );
  }
}

class _EntradaCard extends StatelessWidget {
  final EntradaDiario entrada;
  final VoidCallback onEdit;
  const _EntradaCard({required this.entrada, required this.onEdit});

  Color _humorColor(String humor) {
    switch (humor) {
      case 'otimo': return AppTheme.green;
      case 'bom': return AppTheme.blue;
      case 'neutro': return AppTheme.textMuted;
      case 'ruim': return AppTheme.orange;
      case 'pessimo': return AppTheme.red;
      default: return AppTheme.textMuted;
    }
  }

  String _humorEmoji(String humor) {
    const m = {
      'otimo': '😄', 'bom': '🙂', 'neutro': '😐',
      'ruim': '😕', 'pessimo': '😞'
    };
    return m[humor] ?? '😐';
  }

  @override
  Widget build(BuildContext context) {
    final color = _humorColor(entrada.humor);
    return Card(
      child: InkWell(
        onTap: onEdit,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    DateFormat('dd/MM/yyyy', 'pt_BR').format(DateTime.parse(entrada.data)),
                    style: const TextStyle(
                        color: AppTheme.text, fontWeight: FontWeight.w600),
                  ),
                  const Spacer(),
                  Text(_humorEmoji(entrada.humor),
                      style: const TextStyle(fontSize: 20)),
                  const SizedBox(width: 8),
                  Row(
                    children: List.generate(
                      entrada.energiaNivel,
                      (_) => const Icon(Icons.bolt_rounded,
                          color: AppTheme.gold, size: 14),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                entrada.conteudo.length > 200
                    ? '${entrada.conteudo.substring(0, 200)}...'
                    : entrada.conteudo,
                style: const TextStyle(color: AppTheme.textMuted, fontSize: 13),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _EntradaForm extends StatefulWidget {
  final AppState state;
  final EntradaDiario? existing;
  const _EntradaForm({required this.state, this.existing});

  @override
  State<_EntradaForm> createState() => _EntradaFormState();
}

class _EntradaFormState extends State<_EntradaForm> {
  final _uuid = const Uuid();
  late final TextEditingController _contentCtrl;
  String _humor = 'neutro';
  int _energia = 5;
  late String _data;

  @override
  void initState() {
    super.initState();
    final e = widget.existing;
    _contentCtrl = TextEditingController(text: e?.conteudo ?? '');
    _humor = e?.humor ?? 'neutro';
    _energia = e?.energiaNivel ?? 5;
    _data = e?.data ?? DateFormat('yyyy-MM-dd').format(DateTime.now());
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
          left: 24, right: 24, top: 24,
          bottom: MediaQuery.of(context).viewInsets.bottom + 24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(widget.existing != null ? 'Editar entrada' : 'Nova entrada',
              style: const TextStyle(
                  color: AppTheme.text, fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 4),
          Text(
            DateFormat('dd/MM/yyyy', 'pt_BR').format(DateTime.parse(_data)),
            style: const TextStyle(color: AppTheme.textMuted, fontSize: 12),
          ),
          const SizedBox(height: 16),

          // Humor
          const Text('Humor', style: TextStyle(color: AppTheme.textMuted, fontSize: 12)),
          const SizedBox(height: 6),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ('😄', 'otimo'), ('🙂', 'bom'), ('😐', 'neutro'),
              ('😕', 'ruim'), ('😞', 'pessimo'),
            ].map((e) {
              final sel = _humor == e.$2;
              return GestureDetector(
                onTap: () => setState(() => _humor = e.$2),
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: sel ? AppTheme.accent.withOpacity(0.2) : AppTheme.card,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                        color: sel ? AppTheme.accent : AppTheme.divider),
                  ),
                  child: Text(e.$1, style: const TextStyle(fontSize: 24)),
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 12),

          // Energia
          Row(
            children: [
              const Text('Energia: ', style: TextStyle(color: AppTheme.textMuted, fontSize: 12)),
              Text('$_energia/10',
                  style: const TextStyle(color: AppTheme.gold, fontSize: 12, fontWeight: FontWeight.bold)),
            ],
          ),
          Slider(
            value: _energia.toDouble(),
            min: 1, max: 10, divisions: 9,
            activeColor: AppTheme.gold,
            inactiveColor: AppTheme.divider,
            onChanged: (v) => setState(() => _energia = v.round()),
          ),

          // Conteúdo
          TextField(
            controller: _contentCtrl,
            decoration: const InputDecoration(
              labelText: 'Como foi seu dia?',
              alignLabelWithHint: true,
            ),
            style: const TextStyle(color: AppTheme.text),
            maxLines: 5,
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _salvar,
              child: const Text('Salvar entrada'),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _salvar() async {
    final entrada = widget.existing ??
        (EntradaDiario()
          ..id = _uuid.v4()
          ..criadoEm = DateTime.now());
    entrada
      ..data = _data
      ..conteudo = _contentCtrl.text.trim()
      ..humor = _humor
      ..energiaNivel = _energia;
    await widget.state.salvarEntradaDiario(entrada);
    if (context.mounted) Navigator.pop(context);
  }
}
