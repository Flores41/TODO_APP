//Home Screen
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:provider/provider.dart';
import 'package:todo_list_app/src/pages/pages.dart';


import '../../providers/authentication_provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  DateTime now = DateTime.now();

  @override
  Widget build(BuildContext context) {
    initializeDateFormatting('es');
    String formattedDate = DateFormat('MMMM dd, yyyy', 'es').format(now);
    final authProvider = context.watch<AuthenticacionProvider>();

    return Scaffold(
      body: SingleChildScrollView(
        child: Stack(
          children: [
            Container(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              color: Colors.blue.withOpacity(0.1),
            ),
            Container(
              height: MediaQuery.of(context).size.height * 0.28,
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
            //IconButton para cerrar Sesion
            Positioned(
              right: 10,
              top: 30,
              child: IconButton(
                  onPressed: () {
                    authProvider.signOut().then(
                        (value) => Navigator.pushReplacementNamed(context, '/'));
                  },
                  icon: const Icon(
                    Icons.logout,
                    size: 30,
                    color: Colors.white,
                  )),
            ),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(
                    height: 40,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 10, top: 10),
                    child: Center(
                      child: Text(
                        formattedDate.toUpperCase(),
                        style: const TextStyle(
                            fontWeight: FontWeight.w900,
                            fontSize: 15,
                            color: Colors.white),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 10, top: 10),
                    child: Center(
                      child: Text(
                        'Lista de tareas'.toUpperCase(),
                        style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 22,
                            color: Colors.white),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                const TareasScreen(),
                  const SizedBox(
                    height: 10,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 10, top: 10),
                    child: Text(
                      'Tareas Completadas'.toUpperCase(),
                      style: const TextStyle(
                          fontWeight: FontWeight.w900, fontSize: 18),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
              //  const TareasCompletadas(),
                  const SizedBox(
                    height: 20,
                  ),
                  InkWell(
                    borderRadius: BorderRadius.circular(16),
                    hoverColor:
                        Theme.of(context).colorScheme.primary.withOpacity(0.4),
                    onTap: () {
                      Navigator.pushNamed(context, '/nueva-tarea');
                    },
                    child: Material(
                      color: Theme.of(context)
                          .colorScheme
                          .primary
                          .withOpacity(0.2),
                      borderRadius: BorderRadius.circular(16),
                      child: SizedBox(
                        width: MediaQuery.of(context).size.height,
                        height: MediaQuery.of(context).size.height * 0.07,
                        child: Center(
                            child: Text(
                          'Agregar Nueva Tarea'.toUpperCase(),
                          style: const TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.w900,
                          ),
                        )),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
