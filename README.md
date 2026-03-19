# Agenda Allan — Guia de Build APK
## Projeto Flutter Completo

### Estrutura do projeto
```
agenda_allan/
├── lib/
│   ├── main.dart                    # Entry point
│   ├── models/
│   │   ├── models.dart              # Modelos Hive
│   │   └── models.g.dart            # Adapters gerados
│   ├── services/
│   │   ├── app_state.dart           # Estado global (ChangeNotifier)
│   │   └── notification_service.dart # Notificações locais
│   ├── screens/
│   │   ├── home_screen.dart         # Shell com bottom nav
│   │   ├── rotina_screen.dart       # Blocos de rotina + check-in
│   │   ├── tarefas_screen.dart      # Tarefas com XP + delegação
│   │   ├── reunioes_screen.dart     # Reuniões com notificações
│   │   ├── compromissos_screen.dart # Compromissos pessoais
│   │   ├── diario_screen.dart       # Diário com humor + energia
│   │   ├── stats_screen.dart        # Estatísticas + heatmap + conquistas
│   │   └── perfil_screen.dart       # Perfil + XP + segurança
│   ├── widgets/
│   │   ├── lock_screen.dart         # Tela de bloqueio PIN/senha
│   │   ├── level_up_overlay.dart    # Animação de level up RPG
│   │   └── xp_badge.dart           # Badge de nível + barra XP
│   └── theme/
│       └── app_theme.dart           # Tema dark + cores + XP calc
├── android/
│   ├── app/
│   │   ├── build.gradle
│   │   └── src/main/
│   │       ├── AndroidManifest.xml
│   │       ├── kotlin/.../MainActivity.kt
│   │       └── res/ (ícones + styles)
│   ├── build.gradle
│   ├── settings.gradle
│   └── gradle.properties
└── pubspec.yaml
```

---

## Como fazer o Build APK

### Opção A — Codemagic (sem instalar nada)

1. Crie conta em https://codemagic.io/start (login com GitHub)
2. Faça upload do projeto no GitHub
3. Conecte o repositório no Codemagic
4. O `codemagic.yaml` está pronto — clique em **Start new build**
5. ~10 min → baixe o `app-release.apk`

### Opção B — Localmente com Flutter instalado

```bash
# 1. Instalar Flutter 3.19+
# https://flutter.dev/docs/get-started/install

# 2. Na pasta do projeto:
flutter pub get
flutter build apk --release

# 3. APK gerado em:
# build/app/outputs/flutter-apk/app-release.apk
```

### Opção C — GitHub Actions (grátis)

Crie `.github/workflows/build.yml` no repositório:

```yaml
name: Build APK
on: [push]
jobs:
  build:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
      - uses: subosito/flutter-action@v2
        with:
          flutter-version: '3.19.6'
      - run: flutter pub get
      - run: flutter build apk --release
      - uses: actions/upload-artifact@v3
        with:
          name: agenda-allan.apk
          path: build/app/outputs/flutter-apk/app-release.apk
```

---

## Funcionalidades

### Sistema de XP (RPG)
| Ação | XP |
|------|----|
| Criar tarefa | +5 XP |
| Delegar tarefa | +3 XP |
| Bloco Feito ✅ | +10 XP |
| Bloco Parcial ⚡ | +5 XP |
| Streak a cada 3 dias | +30 XP |
| Tarefa Comum × Fácil | 15 XP |
| Tarefa Comum × Épico | 75 XP |
| Tarefa Crítica × Fácil | 60 XP |
| Tarefa Crítica × Épico | 300 XP |

### Níveis
| Nível | XP necessário | Título |
|-------|--------------|--------|
| 1 | 0 | Iniciante |
| 2 | 200 | Aprendiz |
| 3 | 500 | Praticante |
| 4 | 1.000 | Competente |
| 5 | 2.000 | Proficiente |
| 6 | 4.000 | Especialista |
| 7 | 7.000 | Mestre |
| 8 | 12.000 | Grão-Mestre |

### Notificações
- Blocos de rotina → notificação diária no horário configurado
- Tarefas com prazo → aviso 15 min antes
- Reuniões → aviso 15 min antes
- Compromissos → aviso 15 min antes
- Conquistas → notificação instantânea ao desbloquear

### Conquistas (12 badges)
- 🌟 Primeira Marca — primeiro check-in
- 🔥 3 em Sequência — streak de 3 dias
- 💪 Semana Completa — 7 dias de streak
- 💎 Dia Perfeito — score 100% em um dia
- 🚀 10 em Sequência — streak de 10 dias
- ⚔️ Caçador de Desafios — tarefa crítica concluída
- 📋 Executor — 10 tarefas concluídas
- 🏆 Campeão — 50 tarefas concluídas
- 📓 Diário Ativo — 3 entradas no diário
- ⭐ Proficiente — nível 5 alcançado
- 👑 Grão-Mestre — nível máximo
- 🤝 Líder Eficiente — tarefa delegada

---

## Instalação no Android

1. Baixe o `app-release.apk`
2. No Android: Configurações → Segurança → Fontes desconhecidas → Ativar
3. Abra o arquivo APK e instale
4. Pronto! 🎉
