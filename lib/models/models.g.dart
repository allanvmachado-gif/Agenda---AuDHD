// GENERATED CODE - DO NOT MODIFY BY HAND
// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

part of 'models.dart';

// ─── TarefaAdapter ────────────────────────────────────────
class TarefaAdapter extends TypeAdapter<Tarefa> {
  @override
  final int typeId = 0;

  @override
  Tarefa read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Tarefa()
      ..id = fields[0] as String
      ..titulo = fields[1] as String
      ..descricao = fields[2] as String
      ..tipo = fields[3] as String
      ..dificuldade = fields[4] as String
      ..area = fields[5] as String
      ..concluida = fields[6] as bool
      ..delegada = fields[7] as bool
      ..delegadoPara = fields[8] as String
      ..dataPrazo = fields[9] as DateTime?
      ..criadaEm = fields[10] as DateTime
      ..concluidaEm = fields[11] as DateTime?
      ..xpGanho = fields[12] as int
      ..notificar = fields[13] as bool;
  }

  @override
  void write(BinaryWriter writer, Tarefa obj) {
    writer
      ..writeByte(14)
      ..writeByte(0)..write(obj.id)
      ..writeByte(1)..write(obj.titulo)
      ..writeByte(2)..write(obj.descricao)
      ..writeByte(3)..write(obj.tipo)
      ..writeByte(4)..write(obj.dificuldade)
      ..writeByte(5)..write(obj.area)
      ..writeByte(6)..write(obj.concluida)
      ..writeByte(7)..write(obj.delegada)
      ..writeByte(8)..write(obj.delegadoPara)
      ..writeByte(9)..write(obj.dataPrazo)
      ..writeByte(10)..write(obj.criadaEm)
      ..writeByte(11)..write(obj.concluidaEm)
      ..writeByte(12)..write(obj.xpGanho)
      ..writeByte(13)..write(obj.notificar);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TarefaAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

// ─── BlocoRotinaAdapter ────────────────────────────────────
class BlocoRotinaAdapter extends TypeAdapter<BlocoRotina> {
  @override
  final int typeId = 1;

  @override
  BlocoRotina read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return BlocoRotina()
      ..id = fields[0] as String
      ..titulo = fields[1] as String
      ..horarioInicio = fields[2] as String
      ..horarioFim = fields[3] as String
      ..icone = fields[4] as String
      ..cor = fields[5] as String
      ..diasSemana = (fields[6] as List).cast<int>()
      ..ativo = fields[7] as bool
      ..descricao = fields[8] as String
      ..notificar = fields[9] as bool;
  }

  @override
  void write(BinaryWriter writer, BlocoRotina obj) {
    writer
      ..writeByte(10)
      ..writeByte(0)..write(obj.id)
      ..writeByte(1)..write(obj.titulo)
      ..writeByte(2)..write(obj.horarioInicio)
      ..writeByte(3)..write(obj.horarioFim)
      ..writeByte(4)..write(obj.icone)
      ..writeByte(5)..write(obj.cor)
      ..writeByte(6)..write(obj.diasSemana)
      ..writeByte(7)..write(obj.ativo)
      ..writeByte(8)..write(obj.descricao)
      ..writeByte(9)..write(obj.notificar);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is BlocoRotinaAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

// ─── CheckInAdapter ────────────────────────────────────────
class CheckInAdapter extends TypeAdapter<CheckIn> {
  @override
  final int typeId = 2;

  @override
  CheckIn read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return CheckIn()
      ..id = fields[0] as String
      ..blocoId = fields[1] as String
      ..data = fields[2] as String
      ..status = fields[3] as String
      ..registradoEm = fields[4] as DateTime;
  }

  @override
  void write(BinaryWriter writer, CheckIn obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)..write(obj.id)
      ..writeByte(1)..write(obj.blocoId)
      ..writeByte(2)..write(obj.data)
      ..writeByte(3)..write(obj.status)
      ..writeByte(4)..write(obj.registradoEm);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CheckInAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

// ─── ReuniaoAdapter ────────────────────────────────────────
class ReuniaoAdapter extends TypeAdapter<Reuniao> {
  @override
  final int typeId = 3;

  @override
  Reuniao read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Reuniao()
      ..id = fields[0] as String
      ..titulo = fields[1] as String
      ..dataHora = fields[2] as DateTime
      ..duracaoMinutos = fields[3] as int
      ..local = fields[4] as String
      ..participantes = fields[5] as String
      ..notas = fields[6] as String
      ..notificar = fields[7] as bool
      ..cor = fields[8] as String;
  }

  @override
  void write(BinaryWriter writer, Reuniao obj) {
    writer
      ..writeByte(9)
      ..writeByte(0)..write(obj.id)
      ..writeByte(1)..write(obj.titulo)
      ..writeByte(2)..write(obj.dataHora)
      ..writeByte(3)..write(obj.duracaoMinutos)
      ..writeByte(4)..write(obj.local)
      ..writeByte(5)..write(obj.participantes)
      ..writeByte(6)..write(obj.notas)
      ..writeByte(7)..write(obj.notificar)
      ..writeByte(8)..write(obj.cor);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ReuniaoAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

// ─── CompromissoAdapter ───────────────────────────────────
class CompromissoAdapter extends TypeAdapter<Compromisso> {
  @override
  final int typeId = 4;

  @override
  Compromisso read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Compromisso()
      ..id = fields[0] as String
      ..titulo = fields[1] as String
      ..dataHora = fields[2] as DateTime
      ..local = fields[3] as String
      ..notas = fields[4] as String
      ..notificar = fields[5] as bool
      ..tipo = fields[6] as String
      ..cor = fields[7] as String;
  }

  @override
  void write(BinaryWriter writer, Compromisso obj) {
    writer
      ..writeByte(8)
      ..writeByte(0)..write(obj.id)
      ..writeByte(1)..write(obj.titulo)
      ..writeByte(2)..write(obj.dataHora)
      ..writeByte(3)..write(obj.local)
      ..writeByte(4)..write(obj.notas)
      ..writeByte(5)..write(obj.notificar)
      ..writeByte(6)..write(obj.tipo)
      ..writeByte(7)..write(obj.cor);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CompromissoAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

// ─── EntradaDiarioAdapter ─────────────────────────────────
class EntradaDiarioAdapter extends TypeAdapter<EntradaDiario> {
  @override
  final int typeId = 5;

  @override
  EntradaDiario read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return EntradaDiario()
      ..id = fields[0] as String
      ..data = fields[1] as String
      ..conteudo = fields[2] as String
      ..humor = fields[3] as String
      ..criadoEm = fields[4] as DateTime
      ..energiaNivel = fields[5] as int;
  }

  @override
  void write(BinaryWriter writer, EntradaDiario obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)..write(obj.id)
      ..writeByte(1)..write(obj.data)
      ..writeByte(2)..write(obj.conteudo)
      ..writeByte(3)..write(obj.humor)
      ..writeByte(4)..write(obj.criadoEm)
      ..writeByte(5)..write(obj.energiaNivel);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is EntradaDiarioAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

// ─── ConquistaAdapter ─────────────────────────────────────
class ConquistaAdapter extends TypeAdapter<Conquista> {
  @override
  final int typeId = 6;

  @override
  Conquista read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Conquista()
      ..id = fields[0] as String
      ..titulo = fields[1] as String
      ..descricao = fields[2] as String
      ..icone = fields[3] as String
      ..desbloqueada = fields[4] as bool
      ..desbloquadaEm = fields[5] as DateTime?
      ..xpBonus = fields[6] as int;
  }

  @override
  void write(BinaryWriter writer, Conquista obj) {
    writer
      ..writeByte(7)
      ..writeByte(0)..write(obj.id)
      ..writeByte(1)..write(obj.titulo)
      ..writeByte(2)..write(obj.descricao)
      ..writeByte(3)..write(obj.icone)
      ..writeByte(4)..write(obj.desbloqueada)
      ..writeByte(5)..write(obj.desbloquadaEm)
      ..writeByte(6)..write(obj.xpBonus);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ConquistaAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

// ─── PerfilAdapter ─────────────────────────────────────────
class PerfilAdapter extends TypeAdapter<Perfil> {
  @override
  final int typeId = 7;

  @override
  Perfil read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Perfil()
      ..nome = fields[0] as String
      ..descricao = fields[1] as String
      ..xpTotal = fields[2] as int
      ..nivel = fields[3] as int
      ..streakAtual = fields[4] as int
      ..streakMaximo = fields[5] as int
      ..fotoPath = fields[6] as String?
      ..ultimoCheckin = fields[7] as DateTime?
      ..totalTarefasConcluidas = fields[8] as int
      ..totalBlocosFeitos = fields[9] as int;
  }

  @override
  void write(BinaryWriter writer, Perfil obj) {
    writer
      ..writeByte(10)
      ..writeByte(0)..write(obj.nome)
      ..writeByte(1)..write(obj.descricao)
      ..writeByte(2)..write(obj.xpTotal)
      ..writeByte(3)..write(obj.nivel)
      ..writeByte(4)..write(obj.streakAtual)
      ..writeByte(5)..write(obj.streakMaximo)
      ..writeByte(6)..write(obj.fotoPath)
      ..writeByte(7)..write(obj.ultimoCheckin)
      ..writeByte(8)..write(obj.totalTarefasConcluidas)
      ..writeByte(9)..write(obj.totalBlocosFeitos);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PerfilAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
