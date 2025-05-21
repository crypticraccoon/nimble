import 'package:client/ui/settings/email/view_models/update_email_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class UpdateEmailScreen extends StatefulWidget {
  const UpdateEmailScreen({super.key, required this.viewModel});

  final UpdateEmailViewmodel viewModel;

  @override
  State<StatefulWidget> createState() {
    return _UpdateEmailScreen();
  }
}

class _UpdateEmailScreen extends State<UpdateEmailScreen> {
  final TextEditingController _username = TextEditingController(text: '');

  @override
  void initState() {
    super.initState();
    widget.viewModel.updateEmail.addListener(_onResult);
  }

  @override
  void didUpdateWidget(covariant UpdateEmailScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
  }

  @override
  void dispose() {
    super.dispose();
    widget.viewModel.updateEmail.removeListener(_onResult);
  }

  void _onResult() {
    if (widget.viewModel.updateEmail.completed) {
      String res = widget.viewModel.updateEmail.responseData as String;
      widget.viewModel.updateEmail.clearResult();
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("$res. Email updated.")));
      context.go("/home/settings");
    }

    if (widget.viewModel.updateEmail.error) {
      String hasError =
          widget.viewModel.updateEmail.errorMessage != null
              ? widget.viewModel.updateEmail.errorMessage!
              : "";

      widget.viewModel.updateEmail.clearResult();
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
                    Text("Change email"),

                    TextField(
                      decoration: InputDecoration(
                        counterText: "",
                        hintText: "Email",
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
                        SnackBar(content: Text("Cannot use empty email.")),
                      );
                    } else {
                      widget.viewModel.updateEmail.execute((
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
