import 'package:client/ui/settings/username/view_models/update_username_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class UpdateUsernameScreen extends StatefulWidget {
  const UpdateUsernameScreen({super.key, required this.viewModel});

  final UpdateUsernameViewmodel viewModel;

  @override
  State<StatefulWidget> createState() {
    return _UpdateUsernameScreen();
  }
}

class _UpdateUsernameScreen extends State<UpdateUsernameScreen> {
  final TextEditingController _username = TextEditingController(text: '');

  @override
  void initState() {
    super.initState();
    widget.viewModel.updateUsername.addListener(_onResult);
  }

  @override
  void didUpdateWidget(covariant UpdateUsernameScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
  }

  @override
  void dispose() {
    super.dispose();
    widget.viewModel.updateUsername.removeListener(_onResult);
  }

  void _onResult() {
    if (widget.viewModel.updateUsername.completed) {
      String res = widget.viewModel.updateUsername.responseData as String;
      widget.viewModel.updateUsername.clearResult();
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("$res. Username updated.")));
      context.go("/home/settings");
    }

    if (widget.viewModel.updateUsername.error) {
      String hasError =
          widget.viewModel.updateUsername.errorMessage != null
              ? widget.viewModel.updateUsername.errorMessage!
              : "";

      widget.viewModel.updateUsername.clearResult();
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(hasError)));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text("Change username"),

                    TextField(
                      decoration: InputDecoration(
                        counterText: "",
                        hintText: "Username",
                      ),
                      controller: _username,
                      maxLength: 25,
                    ),
                  ],
                ),
              ),
            ),
            ListenableBuilder(
              listenable: widget.viewModel,
              builder: (context, _) {
                return FilledButton(
                  onPressed: () {
                    if (_username.value.text == "") {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text("Cannot use empty name.")),
                      );
                    } else {
                      widget.viewModel.updateUsername.execute((
                        _username.value.text,
                      ));
                    }
                  },
                  child: Text("Update"),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
