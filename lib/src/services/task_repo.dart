



import 'package:todo_list_app/src/models/models.dart';


abstract class TaskRepository {
  // Método para obtener todas las tareas asociadas a un usuario
  Future<List<TareaModel>> getTareas(String userId);

  // Método para obtener todas las tareas completadas asociadas a un usuario
  Future<List<TareaModel>> getTareasCompletadas(String userId, ); 

  // Método para obtener las tareas pendientes asociadas a un usuario
  Future<List<TareaModel>> getTareasPendientes(String userId, ); 

  // Método para eliminar una tarea por su ID, asociada a un usuario
  Future<void> eliminarTareaPorId(String userId, int taskId); 

  // Método para agregar una tarea asociada a un usuario
  Future<void> agregarTareaModel(String userId, TareaModel tarea); 
}


 // Future<void> agregarTarea(String tarea, DateTime fecha, String nota, Icon categoria);
    // Future<void> completarTarea(int index);
    // Future<void> eliminarTarea(int index);
