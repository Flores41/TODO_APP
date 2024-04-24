import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:todo_list_app/src/services/services.dart';

import '../models/models.dart';

class TareaProvider extends ChangeNotifier {
  //implementar los metodos de  TaskFirebaseRepository

  final taskRepo = TaskFirebaseRepo();
Timestamp? _seleccionarTimestamp; 
DateTime? get seleccionarFecha => _seleccionarTimestamp?.toDate();



  bool _isSaving = false;
  bool get isSaving => _isSaving;


  String _selectedCategory =  '';
  String get selectedCategory => _selectedCategory;


  void setSelectedCategory(String value) {
    _selectedCategory = value;
    notifyListeners();
  }

  void setIsSaving(bool value) {
    _isSaving = value;
    notifyListeners();
  }



  //metodo para agregar una tarea
  Future<void> agregarTarea(String userId, TareaModel tarea) async {
    try {
      await taskRepo.agregarTareaModel(userId, tarea);
    } catch (e) {
      log(e.toString());
      rethrow;
    }
  }

  //metodo para completar una tarea
  Future<void> completarTarea(String userId) async {
    try {
      await taskRepo.getTareasCompletadas(userId);
    } catch (e) {
      log(e.toString());
      rethrow;
    }
  }

  //metodo para eliminar una tarea
  Future<void> eliminarTarea(String userId, int taskId) async {
    try {
      await taskRepo.eliminarTareaPorId(userId, taskId);
    } catch (e) {
      log(e.toString());
      rethrow;
    }
  }

  //metodo para obtener las tareas pendientes
  Future<List<TareaModel>> getTareasPendientes(String userId) async {
    try {
      return await taskRepo.getTareasPendientes(userId);
    } catch (e) {
      log(e.toString());
      rethrow;
    }
  }

  //metodo para obtener todas las tareas asociadas a un usuario
  Future<List<TareaModel>> getTareas(String userId) async {
    try {
      return await taskRepo.getTareas(userId);
    } catch (e) {
      log(e.toString());
      rethrow;
    }
  }


void updateDate(DateTime date) {
  _seleccionarTimestamp = Timestamp.fromDate(date); // Convierte DateTime a Timestamp
  notifyListeners();
}
void updateTime(DateTime time) {
  final currentTimestamp = _seleccionarTimestamp ?? Timestamp.now();
  _seleccionarTimestamp = Timestamp.fromDate(DateTime(
    currentTimestamp.toDate().year,
    currentTimestamp.toDate().month,
    currentTimestamp.toDate().day,
    time.hour,
    time.minute,
  ));
  notifyListeners();
}
}

List<Icon> categorias = [
  const Icon(
    Icons.person,
    color: Colors.red,
  ),
  const Icon(
    CupertinoIcons.sportscourt,
    color: Colors.lightBlueAccent,
  ),
  const Icon(
    CupertinoIcons.hammer,
    color: Colors.green,
  ),
];
