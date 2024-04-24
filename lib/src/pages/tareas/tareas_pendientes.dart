import 'dart:developer';

import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import 'package:todo_list_app/src/providers/tareas_provider.dart';

import '../../models/models.dart';
import '../../providers/authentication_provider.dart';


class TareasScreen extends StatelessWidget {
  const TareasScreen({
    super.key,
  });
    // Método para obtener las tareas pendientes
  Future<List<TareaModel>> _getTareasPendientes(String userId, TareaProvider task) async {
    try {
      return await task.getTareasPendientes(userId);
    } catch (e) {
      // Manejo de errores
      log('Error al obtener las tareas pendientes: $e');
      return []; // Devuelve una lista vacía en caso de error
    }
  }

  @override
  Widget build(BuildContext context)  {
    final task = context.watch<TareaProvider>();
    final auth = context.watch<AuthenticacionProvider>();
    final userId = auth.getUserId();
   
    return FutureBuilder<List<TareaModel>>(
      future: userId!= null ? _getTareasPendientes(userId, task) : null,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        else if (snapshot.hasError) {
          return Center(
            child: Text(
              'Ocurrió un error al obtener las tareas pendientes',
              style: TextStyle(
                color: Theme.of(context).colorScheme.error,
                fontWeight: FontWeight.bold,
              ),
            ),
          );
        }
        else {
           final List<TareaModel> tareasPendientes = snapshot.data ?? [];
           return Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.width / 1.7,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Theme.of(context).colorScheme.primary.withOpacity(0.15),
              blurRadius: 5,
              spreadRadius: 2,
              offset: const Offset(2, 5),
            ),
          ],
        ),
        child: Center(
          child: tareasPendientes.isEmpty
              ? Center(
                  child: Text(
                    'Sin tareas....'.toUpperCase(),
                    style: TextStyle(
                        color: Theme.of(context)
                            .colorScheme
                            .primary
                            .withOpacity(0.4),
                        fontWeight: FontWeight.w800,
                        fontSize: 13),
                  ),
                )
              : ListView.builder(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 3, vertical: 10),
                  itemCount: tareasPendientes.length,
                  itemBuilder: (context, index) {
                      final data = tareasPendientes[index];
                    return Column(
                      children: [
                        GestureDetector(
                          onDoubleTap: () {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: Text(
                                    "Eliminar Tarea".toUpperCase(),
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14,
                                    ),
                                  ),
                                  content: Text(
                                    "¿Estás seguro de que deseas eliminar esta tarea?"
                                        .toUpperCase(),
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w500,
                                      fontSize: 13,
                                    ),
                                  ),
                                  actions: [
                                    TextButton(
                                      onPressed: () {
                                      
                                      },
                                      child: const Text("Cancelar"),
                                    ),
                                    TextButton(
                                      onPressed: () {
                                       
                                       
                                      },
                                      child: const Text("Eliminar"),
                                    ),
                                  ],
                                );
                              },
                            );
                          },
                          child: Container(
                            width: MediaQuery.of(context).size.width,
                            height: MediaQuery.of(context).size.height * 0.09,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.only(right: 5, left: 5),
                              child: Column(
                                children: [
                                  Row(
                                    children: [
                                      Row(
                                        children: [
                                          // Icono de la categoria
                                          Container(
                                            margin: const EdgeInsets.symmetric(
                                                horizontal: 6),
                                            width: 40,
                                            height: 40,
                                            decoration: BoxDecoration(
                                              color:  data.categorias == 'Personal'
                                                  ? Theme.of(context)
                                                      .colorScheme
                                                      .primary
                                                      .withOpacity(0.3)
                                                  : data.categorias == 'Trabajo'
                                                      ? Theme.of(context)
                                                          .colorScheme
                                                          .secondary
                                                          .withOpacity(0.3)
                                                      : Theme.of(context)
                                                          .colorScheme
                                                          .error
                                                          .withOpacity(0.3),
                                                shape: BoxShape.circle,
                                                border: Border.all(
                                                    color: data.categorias == 'Personal'
                                                        ? Theme.of(context)
                                                            .colorScheme
                                                            .primary
                                                        : data.categorias == 'Trabajo'
                                                            ? Theme.of(context)
                                                                .colorScheme
                                                                .secondary
                                                            : Theme.of(context)
                                                                .colorScheme
                                                                .error,
                                                    width: 2),
                                               ),
                                            // Icono de la tarea
                                             child: Icon(
                                              data.categorias == 'Personal'
                                                  ? Icons.person
                                                  : data.categorias == 'Trabajo'
                                                      ? Icons.work
                                                      : Icons.error,
                                              color: data.categorias == 'Personal'
                                                  ? Theme.of(context).colorScheme.primary
                                                  : data.categorias == 'Trabajo'
                                                      ? Theme.of(context).colorScheme.secondary
                                                      : Theme.of(context).colorScheme.error,
                                            
                                          ),
                                           
                                          ),
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              // Nombre de la tarea
                                              Text(
                                              data.task.toUpperCase(),
                                              style: const TextStyle(
                                                fontWeight: FontWeight.w800,
                                                fontSize: 15,
                                              ),
                                            ),
                                              
                                              Row(
                                                children: [
                                                  // Fecha de la tarea
                                                 Text(
                                                  '${data.fecha}',
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.w800,
                                                      fontSize: 12,
                                                      color:
                                                          Colors.grey.shade400),
                                                ),
                                                  const SizedBox(width: 10),
                                                  // Hora de la tarea
                                                   Text(
                                                  '${data.hora}',
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.w800,
                                                      fontSize: 12,
                                                      color:
                                                          Colors.grey.shade400),
                                                ),
                                                ],
                                              ),
                                              // Nota de la tarea
                                              Text(data.nota.toUpperCase(),
                                                style: TextStyle(
                                                    fontWeight: FontWeight.w800,
                                                    fontSize: 11,
                                                    color:
                                                        Colors.grey.shade600)),
                                            ],
                                          ),
                                        ],
                                      ),
                                      const Spacer(),
                                      Row(
                                        children: [
                                           Checkbox(
                                          value: data.completada,
                                          onChanged: (value) {
                                            task.completarTarea(data.usuarioId);
                                          },
                                        ),
                                          
                                        ],
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            ),
                        ),
                       
                      ],
                    );
                  },
                ),
        ),
      );
          
        }
       
      },

     
    );
  }
}
