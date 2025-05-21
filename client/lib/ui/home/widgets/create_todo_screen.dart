import 'package:client/ui/home/view_models/create_todo_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

//NOTE: Check how change notifier listens to a get request on load?

class CreateTodoScreen extends StatefulWidget {
  const CreateTodoScreen({super.key, required this.viewModel});
  final CreateTodoViewModel viewModel;

  @override
  State<StatefulWidget> createState() {
    return _CreateTodoScreen();
  }
}

class _CreateTodoScreen extends State<CreateTodoScreen> {
  @override
  void initState() {
    super.initState();
    widget.viewModel.createTodo.addListener(_onResult);
  }

  @override
  void didUpdateWidget(covariant CreateTodoScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
  }

  @override
  void dispose() {
    super.dispose();
    widget.viewModel.createTodo.removeListener(_onResult);
  }

  void _onResult() {
    if (widget.viewModel.createTodo.completed) {
      String res = widget.viewModel.createTodo.responseData as String;
      widget.viewModel.createTodo.clearResult();
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("$res. Email updated.")));
      context.go("/home");
    }

    if (widget.viewModel.createTodo.error) {
      String hasError =
          widget.viewModel.createTodo.errorMessage != null
              ? widget.viewModel.createTodo.errorMessage!
              : "";

      widget.viewModel.createTodo.clearResult();
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(hasError)));
    }
  }

  final TextEditingController _title = TextEditingController(text: '');
  final TextEditingController _body = TextEditingController(text: '');
  final TextEditingController _deadline = TextEditingController(text: '');
  DateTime? _selectedDateTime;

  void _updateTextField() {
    if (_selectedDateTime != null) {
      _deadline.text = _selectedDateTime!.toIso8601String();
    } else {
      _deadline.text = '';
    }
  }

  Future<void> _selectDateTime(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: _selectedDateTime ?? DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2050),
      helpText: 'Select Date',

      builder: (_, child) {
        return child!;
      },
    );

    if (pickedDate != null) {
      final TimeOfDay? pickedTime = await showTimePicker(
        context: context,
        initialTime:
            _selectedDateTime != null
                ? TimeOfDay.fromDateTime(_selectedDateTime!)
                : TimeOfDay.now(),
        helpText: 'Select Time',
        builder: (_, child) {
          return child!;
        },
      );

      if (pickedTime != null) {
        setState(() {
          _selectedDateTime = DateTime(
            pickedDate.year,
            pickedDate.month,
            pickedDate.day,
            pickedTime.hour,
            pickedTime.minute,
          );
          _updateTextField();
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,

          children: [
            Text("Create New Tood."),

            TextField(
              decoration: InputDecoration(hintText: "Title", counterText: ""),
              maxLength: 25,
              controller: _title,
            ),

            TextField(
              decoration: InputDecoration(hintText: "Body", counterText: ""),
              maxLength: 25,
              controller: _body,
            ),

            TextField(
              controller: _deadline,
              readOnly: true,
              onTap: () => _selectDateTime(context),
              decoration: const InputDecoration(hintText: 'Select Deadline'),
            ),

            ListenableBuilder(
              listenable: widget.viewModel,
              builder: (context, _) {
                return FilledButton(
                  onPressed: () {
                    widget.viewModel.createTodo.execute((
                      _title.value.text,
                      _body.value.text,

                      //NOTE: Parse to utc().toIso8601String
                      _deadline.value.text,
                    ));
                  },
                  child: Text("Create Todo"),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
