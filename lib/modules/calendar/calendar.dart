import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

class CalendarPage extends StatefulWidget {
  const CalendarPage({super.key});

  @override
  State<CalendarPage> createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            bottomRight: Radius.circular(20.0),
            bottomLeft: Radius.circular(20.0),
          ),
        ),
        elevation: 0,
        backgroundColor: Colors.cyan.shade700,
        centerTitle: true,
        title: const Text(
          "Agenda",
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            color: Colors.white,
            fontSize: 14,
            fontWeight: FontWeight.w400,
          ),
        ),
        iconTheme: const IconThemeData(
          color: Colors.white, // Change la couleur de l'icône de retour ici
        ),
      ),
      body: SfCalendar(
        view: CalendarView.month, // Vous pouvez choisir le type de vue
        initialSelectedDate: DateTime.now(),
      ),
    );
  }
}
