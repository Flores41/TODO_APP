import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_list_app/src/providers/tareas_provider.dart';

class Fecha extends StatelessWidget {
  const Fecha({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final fechaProvider = context.watch<TareaProvider>();

    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Fecha'.toUpperCase(),
          style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 14),
        ),
        const SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(width: 10),
            InkWell(
              onTap: () {
                _selectDate(context, fechaProvider);
              },
              child: Container(
                width: MediaQuery.of(context).size.width * 0.45,
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 10,
                ),
                decoration: BoxDecoration(
                  border: Border.all(
                    color:
                        Theme.of(context).colorScheme.primary.withOpacity(0.3),
                  ),
                  borderRadius: BorderRadius.circular(5),
                ),
                child: Row(
                  children: [
                    Text(
                      '${fechaProvider.seleccionarFecha != null ? fechaProvider.seleccionarFecha!.day : ''}/'
                      '${fechaProvider.seleccionarFecha != null ? fechaProvider.seleccionarFecha!.month : ''}/'
                      '${fechaProvider.seleccionarFecha != null ? fechaProvider.seleccionarFecha!.year : ''}',
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 15,
                      ),
                    ),
                    const Spacer(),
                    Icon(
                      Icons.calendar_today_rounded,
                      size: 25,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(width: 15),
            InkWell(
              onTap: () {
                _selectTime(context, fechaProvider);
              },
              child: Container(
                width: MediaQuery.of(context).size.width * 0.35,
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 10,
                ),
                decoration: BoxDecoration(
                  border: Border.all(
                    color:
                        Theme.of(context).colorScheme.primary.withOpacity(0.3),
                  ),
                  borderRadius: BorderRadius.circular(5),
                ),
                child: Row(
                  children: [
                    Text(
                      '${fechaProvider.seleccionarFecha != null ? fechaProvider.seleccionarFecha!.day : ''}/'
                      '${fechaProvider.seleccionarFecha != null ? fechaProvider.seleccionarFecha!.month : ''}/'
                      '${fechaProvider.seleccionarFecha != null ? fechaProvider.seleccionarFecha!.year : ''}',
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 15,
                      ),
                    ),
                    const Spacer(),
                    Icon(
                      Icons.access_time_rounded,
                      size: 25,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Future<void> _selectDate(BuildContext context, TareaProvider provider) async {
    final Timestamp? pickedTimestamp = provider.seleccionarFecha as Timestamp?;
    final DateTime pickedDate = pickedTimestamp?.toDate() ?? DateTime.now();

    final DateTime? newDate = await showDatePicker(
      context: context,
      initialDate: pickedDate,
      firstDate: DateTime(2024),
      lastDate: DateTime(2101),
    );

    /// Si la fecha seleccionada no es nula y es diferente a la fecha actual, actualiza la fecha.
    if (newDate != null && newDate != pickedDate) {
      provider.updateDate(newDate);
    }
  }

  Future<void> _selectTime(BuildContext context, TareaProvider provider) async {
    final Timestamp? pickedTimestamp = provider.seleccionarFecha as Timestamp?;
    final DateTime pickedDateTime = pickedTimestamp?.toDate() ?? DateTime.now();
    final TimeOfDay pickedTime = TimeOfDay.fromDateTime(pickedDateTime);

    final TimeOfDay? newTime = await showTimePicker(
      context: context,
      initialTime: pickedTime,
    );
    if (newTime != null) {
      final DateTime currentTime = pickedDateTime;
      final DateTime updatedTime = DateTime(
        currentTime.year,
        currentTime.month,
        currentTime.day,
        newTime.hour,
        newTime.minute,
      );
      provider.updateTime(updatedTime);
    }
  }
}
