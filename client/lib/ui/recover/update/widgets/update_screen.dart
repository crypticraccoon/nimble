import 'package:client/ui/recover/update/view_mode/update_password_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class UpdateScreen extends StatefulWidget {
  const UpdateScreen({
    super.key,
    required this.email,
    required this.code,
    required this.viewModel,
  });

  final String email;
  final String code;
  final UpdatePasswordViewmodel viewModel;

  @override
  State<StatefulWidget> createState() {
    return _UpdateScreen();
  }
}

class _UpdateScreen extends State<UpdateScreen> {
  final TextEditingController _password = TextEditingController(text: '');
  final TextEditingController _confirmPassword = TextEditingController(
    text: '',
  );
  bool _obscurePassword = true;

  @override
  void initState() {
    super.initState();
    widget.viewModel.updateRecoveryPassword.addListener(_onResult);
  }

  @override
  void didUpdateWidget(covariant UpdateScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
  }

  @override
  void dispose() {
    super.dispose();
    widget.viewModel.updateRecoveryPassword.removeListener(_onResult);
  }

  void _onResult() {
    if (widget.viewModel.updateRecoveryPassword.completed) {
      print("completed");
      String res =
          widget.viewModel.updateRecoveryPassword.responseData as String;
      widget.viewModel.updateRecoveryPassword.clearResult();
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("$res. Password updated.")));
      context.go("/");
    }

    if (widget.viewModel.updateRecoveryPassword.error) {
      String hasError =
          widget.viewModel.updateRecoveryPassword.errorMessage != null
              ? widget.viewModel.updateRecoveryPassword.errorMessage!
              : "";

      widget.viewModel.updateRecoveryPassword.clearResult();
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
                    Text(
                      AppLocalizations.of(context)!.recoverUpdatePasswordHeader,
                    ),
                    Text(
                      AppLocalizations.of(context)!.recoverUpdatePasswordDesc,
                    ),

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
                        hintText:
                            AppLocalizations.of(context)!.passwordPlaceholder,
                      ),
                      controller: _password,
                      maxLength: 25,
                      obscureText: _obscurePassword,
                    ),
                    TextField(
                      decoration: InputDecoration(
                        counterText: "",
                        hintText: AppLocalizations.of(context)!.confirmPassword,
                      ),
                      controller: _confirmPassword,
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
                    if (_confirmPassword.value.text != _password.value.text ||
                        _confirmPassword.value.text == "" ||
                        _password.value.text == "") {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            AppLocalizations.of(context)!.mismatchPasswords,
                          ),
                        ),
                      );
                    } else {
                      print("here");
                      print(
                        "${widget.email},${widget.code}, ${_password.value.text}",
                      );
                      widget.viewModel.updateRecoveryPassword.execute((
                        widget.email,
                        widget.code,
                        _password.value.text,
                      ));
                    }
                    print("passed");
                  },
                  child: Text(AppLocalizations.of(context)!.updatePassword),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
