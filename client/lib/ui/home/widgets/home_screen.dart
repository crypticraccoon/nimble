import 'package:client/ui/home/view_models/home_viewmodel.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key, required this.viewModel});
  final HomeViewModel viewModel;

  @override
  State<StatefulWidget> createState() {
    return _HomeScreen();
  }
}

class _HomeScreen extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    widget.viewModel.getUsername.addListener(_listener);
  }

  @override
  void didUpdateWidget(covariant HomeScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
  }

  @override
  void dispose() {
    super.dispose();
    widget.viewModel.getUsername.addListener(_listener);
  }

  void _listener() {
    if (widget.viewModel.getUsername.error) {
      widget.viewModel.getUsername.clearResult();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("AppLocalization.of(context).errorWhileSharing"),
        ),
      );
    } else {
      print("passed");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: ListenableBuilder(
          listenable: widget.viewModel,
          builder: (context, child) {
            return Text(widget.viewModel.username ?? "Todo App");
          },
        ),
        actions: <Widget>[
          FilledButton.icon(
            onPressed: () {
              context.go("/home/create");
            },
            icon: const Icon(Icons.add),
            label: const Text('Add Todo'),
          ),

          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              context.go("/home/settings");
            },
          ),
        ],
      ),

      body: SafeArea(
        child: Column(
          children: [
            CalenderView(viewModel: widget.viewModel),

            ListenableBuilder(
              listenable: widget.viewModel,

              builder: (context, _) {
                return Text(widget.viewModel.getUsername.result.toString());
              },
            ),
          ],
        ),
      ),
    );
  }
}

class CalenderView extends StatefulWidget {
  const CalenderView({super.key, required this.viewModel});

  final HomeViewModel viewModel;

  @override
  State<StatefulWidget> createState() {
    return _CalenderView();
  }
}

class _CalenderView extends State<CalenderView> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  CalendarFormat _calendarFormat = CalendarFormat.week;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  @override
  Widget build(BuildContext context) {
    return TableCalendar(
      firstDay: DateTime.utc(2010, 10, 16),
      lastDay: DateTime.utc(2030, 3, 14),
      focusedDay: _focusedDay,
      calendarFormat: _calendarFormat,
      daysOfWeekHeight: 25,
      selectedDayPredicate: (day) {
        return isSameDay(_selectedDay, day);
      },
      onDaySelected: (selectedDay, focusedDay) {
        if (!isSameDay(_selectedDay, selectedDay)) {
          setState(() {
            _selectedDay = selectedDay;
            _focusedDay = focusedDay;
          });
        }
      },
      onFormatChanged: (format) {
        if (_calendarFormat != format) {
          setState(() {
            _calendarFormat = format;
          });
        }
      },
      onPageChanged: (focusedDay) {
        _focusedDay = focusedDay;
      },
    );
  }
}
