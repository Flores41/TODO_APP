import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import 'package:todo_list_app/src/providers/authentication_provider.dart';
import 'package:todo_list_app/src/providers/tareas_provider.dart';
import 'package:uuid/uuid.dart';

import '../../models/models.dart';
import 'fecha.dart';

class AddTask extends StatelessWidget {
  AddTask({super.key});

  final taskController = TextEditingController();
  final notaController = TextEditingController();
  final keyForm = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final taskProvider = context.watch<TareaProvider>();
    final auth = context.watch<AuthenticacionProvider>();

    return Scaffold(
        body: GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: SingleChildScrollView(
        child: Stack(
          children: [
            Container(
              color: Theme.of(context).colorScheme.primary,
              height: MediaQuery.of(context).size.height * 0.15,
              width: MediaQuery.of(context).size.width,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 40),
                  // Barra de navegacion
                  const BarraNavegacion(),

                  const SizedBox(height: 30),

                  // Formulario
                  FormularioTarea(
                      keyForm: keyForm, taskController: taskController),

                  const SizedBox(height: 20),

                  /// Categorias
                  const Categorias(),

                  const SizedBox(height: 10),

                  // Fecha
                  const Fecha(),

                  const SizedBox(height: 20),

                  // Nota
                  FormularioNota(notaController: notaController),

                  const SizedBox(height: 20),

                  /// Boton de guardar
                  ButtonGuardar(
                    keyForm: keyForm,
                    taskProvider: taskProvider,
                    taskController: taskController,
                    notaController: notaController,
                    userId: auth.getUserId()!,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    ));
  }
}

class FormularioNota extends StatelessWidget {
  const FormularioNota({
    super.key,
    required this.notaController,
  });

  final TextEditingController notaController;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Nota'.toUpperCase(),
          textAlign: TextAlign.start,
          style: const TextStyle(
            fontWeight: FontWeight.w900,
            fontSize: 14,
          ),
        ),
        const SizedBox(height: 15),
        TextFormField(
          controller: notaController,
          minLines: 5,
          maxLines: null,
          decoration: InputDecoration(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          validator: (value) {
            if (value!.isEmpty) {
              return 'El Campo Es Obligatorio';
            }

            return null;
          },
          onEditingComplete: () {
            FocusScope.of(context).unfocus();
          },
        ),
      ],
    );
  }
}

class ButtonGuardar extends StatelessWidget {
  const ButtonGuardar({
    Key? key,
    required this.keyForm,
    required this.taskProvider,
    required this.taskController,
    required this.notaController,
    required this.userId,
  }) : super(key: key);

  final GlobalKey<FormState> keyForm;
  final TareaProvider taskProvider;
  final TextEditingController taskController;
  final TextEditingController notaController;
  final String userId;

  @override
  Widget build(BuildContext context) {
    final tarea = context.watch<TareaProvider>();
    final auth = context.watch<AuthenticacionProvider>();
    return InkWell(
      borderRadius: BorderRadius.circular(20),
      onTap: () async {
        if (keyForm.currentState!.validate()) {
          tarea.setIsSaving(true);
          await Future.delayed(const Duration(
              milliseconds: 1500)); // Simulación de tiempo de guardado

          tarea.agregarTarea(
              auth.getUserId()!,
              TareaModel(
                tareaId: const Uuid().v4(),
                nota: notaController.text,
                hora:Timestamp.fromDate(tarea.seleccionarFecha!) ,
                fecha: Timestamp.fromDate(tarea.seleccionarFecha!) ,
                task: taskController.text,
                categorias: tarea.selectedCategory,
                usuarioId: auth.getUserId()!,
              ));

          tarea.setIsSaving(false);
        }
      },
      child: AnimatedContainer(
        duration: const Duration(microseconds: 300),
        curve: Curves.bounceOut,
        decoration: BoxDecoration(
          color: tarea.isSaving
              ? Colors.green.withOpacity(0.5)
              : Theme.of(context).colorScheme.primary.withOpacity(0.3),
          borderRadius: BorderRadius.circular(16),
        ),
        width: MediaQuery.of(context).size.height,
        height: MediaQuery.of(context).size.height * 0.07,
        child: Center(
          child: Text(
            tarea.isSaving
                ? 'Guardando....'.toUpperCase()
                : 'Guardar'.toUpperCase(),
            style: const TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.w900,
            ),
          ),
        ),
      ),
    );
  }
}

class BarraNavegacion extends StatelessWidget {
  const BarraNavegacion({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        InkWell(
          onTap: () {
            Navigator.pop(context);
          },
          child: Container(
            height: 40,
            width: 40,
            decoration: const BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.arrow_back_ios_new_outlined),
          ),
        ),
        const SizedBox(
          width: 20,
        ),
        Text(
          'Nueva Tarea'.toUpperCase(),
          style: const TextStyle(
              fontWeight: FontWeight.bold, fontSize: 18, color: Colors.white),
        ),
      ],
    );
  }
}

class FormularioTarea extends StatelessWidget {
  const FormularioTarea({
    super.key,
    required this.keyForm,
    required this.taskController,
  });

  final GlobalKey<FormState> keyForm;
  final TextEditingController taskController;

  @override
  Widget build(BuildContext context) {
    return Form(
      key: keyForm,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(
            height: 20,
          ),
          Text(
            'Titulo de la tarea'.toUpperCase(),
            style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 14),
          ),
          const SizedBox(
            height: 15,
          ),
          TextFormField(
            controller: taskController,
            decoration: InputDecoration(
              labelText: 'Tarea Nueva',
              prefixIcon: Icon(
                Icons.task,
                color: Theme.of(context).colorScheme.primary,
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(
                    color: Theme.of(context).colorScheme.primary, width: 2.0),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(
                    color:
                        Theme.of(context).colorScheme.primary.withOpacity(0.3),
                    width: 1.0),
              ),
              errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: Colors.red, width: 2.0),
              ),
              focusedErrorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: Colors.red, width: 2.0),
              ),
            ),
            validator: (value) {
              if (value!.isEmpty) {
                return 'El Campo Es Obligatorio';
              }

              return null;
            },
            onEditingComplete: () {
              FocusScope.of(context).unfocus();
            },
          ),
        ],
      ),
    );
  }
}

class Categorias extends StatelessWidget {
  const Categorias({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final tarea = context.watch<TareaProvider>();
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.9,
      height: MediaQuery.of(context).size.height * 0.08,
      child: Row(
        children: [
          Text(
            'Categoria'.toUpperCase(),
            style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 14),
          ),
          const SizedBox(
            width: 10,
          ),
          Expanded(
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: categorias.length,
              itemBuilder: (context, index) {
                final data = categorias[index];
                return InkWell(
                  onTap: () {
                    tarea.setSelectedCategory(data.icon!.toString());
                  },
                  borderRadius: BorderRadius.circular(200),
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 6),
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      color: data.color!.withOpacity(0.3),
                      shape: BoxShape.circle,
                      border: tarea.selectedCategory == data.icon!.toString()
                          ? Border.all(width: 2, color: data.color!)
                          : null,
                      boxShadow: tarea.selectedCategory == data.icon!.toString()
                          ? [
                              BoxShadow(
                                color: data.color!.withOpacity(0.3),
                                blurRadius: 20,
                                offset: const Offset(2, -6),
                                spreadRadius: 1,
                              ),
                            ]
                          : [],
                    ),
                    child: Icon(data.icon, color: data.color),
                  ),
                );
              },
            ),
          )
        ],
      ),
    );
  }
}
