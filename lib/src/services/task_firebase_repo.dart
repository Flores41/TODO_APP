import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:todo_list_app/src/models/task.dart';
import 'package:todo_list_app/src/services/task_repo.dart';

class TaskFirebaseRepo implements TaskRepository {
  final taskCollection = FirebaseFirestore.instance.collection('tasks');

  @override
  Future<void> agregarTareaModel(String userId, TareaModel tarea) async {
    try {
      await taskCollection
          .doc(userId)
          .collection('userTasks')
          .add(tarea.toEntity().toMap());
    } catch (e) {
      log(e.toString());
      rethrow;
    }
  }

  @override
  Future<void> eliminarTareaPorId(String userId, int taskId) async {
    try {
   await taskCollection
          .doc(userId)
          .collection('userTasks')
          .doc(taskId.toString())
          .delete();
    } catch (e) {
      log(e.toString());
      rethrow;
    }
  }

  @override
  Future<List<TareaModel>> getTareas(String userId) async {
    try {
      final querySnapshot =
          await taskCollection.doc(userId).collection('userTasks').get();
      return querySnapshot.docs
          .map((doc) => TareaModel.fromEntity(TareaEntity.fromMap(doc.data())))
          .toList();
    } catch (e) {
      log(e.toString());
      rethrow;
    }
  }

  @override
  Future<List<TareaModel>> getTareasCompletadas(String userId) async {
    try {
      final querySnapshot = await taskCollection
          .doc(userId)
          .collection('userTasks')
          .where('completada', isEqualTo: true)
          .get();
      return querySnapshot.docs
          .map((doc) => TareaModel.fromEntity(TareaEntity.fromMap(doc.data())))
          .toList();
    } catch (e) {
      log(e.toString());
      rethrow;
    }
  }

  @override
  Future<List<TareaModel>> getTareasPendientes(String userId) async {
    try {
      final querySnapshot = await taskCollection
          .doc(userId)
          .collection('userTasks')
          .where('completada', isEqualTo: false)
          .get();
      return querySnapshot.docs
          .map((doc) => TareaModel.fromEntity(TareaEntity.fromMap(doc.data())))
          .toList();
    } catch (e) {
      log(e.toString());
      rethrow;
    }
  }
}
