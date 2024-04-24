

import 'package:cloud_firestore/cloud_firestore.dart';

class TareaEntity {
  String tareaId;
  String task;
  bool completada;
  String categorias;
  Timestamp fecha;
  Timestamp hora;
  String nota;
  String  usuarioId;

  TareaEntity({
    required this.nota,
    required this.hora,
    required this.fecha,
    required this.task,
    required this.categorias,
    this.completada = false,
    required this.tareaId,
    required this.usuarioId,
  });

  factory TareaEntity.fromMap(Map<String, dynamic> json) {
    return TareaEntity(
      tareaId: json['tareaId'],
      task: json['task'],
      completada: json['completada'],
      categorias: json['categorias'],
      fecha: json['fecha'],
      hora: json['hora'],
      nota: json['nota'],
      usuarioId: json['usuarioId'],
    );
  }
  Map<String, dynamic> toMap() {
    return {
      'tareaId': tareaId,
      'task': task,
      'completada': completada,
      'categorias': categorias,
      'fecha': fecha,
      'hora': hora,
      'nota': nota,
      'usuarioId': usuarioId,
    };
  }


}

class TareaModel {
  String tareaId;
  String task;
  bool completada;
  String categorias;
  Timestamp fecha;
  Timestamp hora;
  String nota;
  String  usuarioId;

  TareaModel({
    required this.nota,
    required this.hora,
    required this.fecha,
    required this.task,
    required this.categorias,
    this.completada = false,
    required this.tareaId,
    required this.usuarioId,
  });

  TareaEntity toEntity() {
    return TareaEntity(
      tareaId: tareaId,
      task: task,
      completada: completada,
      categorias: categorias,
      fecha: fecha,
      hora: hora,
      nota: nota,
      usuarioId: usuarioId,
    );
  }

  static TareaModel fromEntity(TareaEntity entity) {
    return TareaModel(
      tareaId: entity.tareaId,
      task: entity.task,
      completada: entity.completada,
      categorias: entity.categorias,
      fecha: entity.fecha,
      hora: entity.hora,
      nota: entity.nota,
      usuarioId: entity.usuarioId,
    );
  }
}
