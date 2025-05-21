import 'package:client/ui/settings/password/view_models/update_password_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class UpdatePasswordScreen extends StatefulWidget {
  const UpdatePasswordScreen({super.key, required this.viewModel});

  final UpdatePasswordViewModel viewModel;

  @override
  State<StatefulWidget> createState() {
    return _UpdatePasswordScreen();
  }
}

class _UpdatePasswordScreen extends State<UpdatePasswordScreen> {
  final TextEditingController _password = TextEditingController(text: '');
  final TextEditingController _oldPassword = TextEditingController(text: '');
  bool _obscurePassword = true;

  @override
  void initState() {
    super.initState();
    widget.viewModel.updatePassword.addListener(_onResult);
  }

  @override
  void didUpdateWidget(covariant UpdatePasswordScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
  }

  @override
  void dispose() {
    super.dispose();
    widget.viewModel.updatePassword.removeListener(_onResult);
  }

  void _onResult() {
    if (widget.viewModel.updatePassword.completed) {
      print("completed");
      String res = widget.viewModel.updatePassword.responseData as String;
      widget.viewModel.updatePassword.clearResult();
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("$res. Password updated.")));
      context.go("/home/settings");
    }

    if (widget.viewModel.updatePassword.error) {
      String hasError =
          widget.viewModel.updatePassword.errorMessage != null
              ? widget.viewModel.updatePassword.errorMessage!
              : "";

      widget.viewModel.updatePassword.clearResult();
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
                    Text("Update Password"),

                    TextField(
                      decoration: InputDecoration(
                        suffixIcon: GestureDetector(
                          onTap: () {
                            setState(() {
                              _obscurePassword = !_obscurePassword;
                            });
                          },
                          child: Icon(
                            _obscurePassword
                                ? Icons.remove_red_eye_sharp
                                : Icons.remove_red_eye_outlined,
                          ),
                        ),
                        counterText: "",
                        hintText: "Old Passowrd",
                      ),
                      controller: _oldPassword,
                      maxLength: 25,
                      obscureText: _obscurePassword,
                    ),
                    TextField(
                      decoration: InputDecoration(
                        counterText: "",
                        hintText: "New Password",
                      ),
                      controller: _password,
                      maxLength: 25,
                      obscureText: _obscurePassword,
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
                    if (_oldPassword.value.text == "" ||
                        _password.value.text == "") {
                      ScaffoldMessenger.of(
                        context,
                      ).showSnackBar(SnackBar(content: Text("Missing field")));
                    } else {
                      widget.viewModel.updatePassword.execute((
                        _password.value.text,
                        _oldPassword.value.text,
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
