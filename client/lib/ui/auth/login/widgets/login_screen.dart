import 'package:client/router/routes.dart';
import 'package:client/ui/auth/login/view_model/login_viewmodel.dart';
import 'package:client/ui/core/theme/dimens.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:go_router/go_router.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key, required this.viewModel});

  final LoginViewModel viewModel;

  @override
  State<StatefulWidget> createState() {
    return _LoginScreen();
  }
}

class _LoginScreen extends State<LoginScreen> {
  final TextEditingController _email = TextEditingController(text: 'maahase@hotmail.com');
  final TextEditingController _password = TextEditingController(text: 'test');
  bool _obscurePassword = true;

  @override
  void initState() {
    super.initState();
    widget.viewModel.login.addListener(_onResult);
  }

  @override
  void didUpdateWidget(covariant LoginScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    oldWidget.viewModel.login.removeListener(_onResult);
    widget.viewModel.login.addListener(_onResult);
  }

  @override
  void dispose() {
    super.dispose();
    widget.viewModel.login.removeListener(_onResult);
  }

  void _onResult() {
    if (widget.viewModel.login.completed) {
      widget.viewModel.login.clearResult();
      context.go(Routes.home);
    }

    if (widget.viewModel.login.error) {
      String hasError =
          widget.viewModel.login.errorMessage != null
              ? widget.viewModel.login.errorMessage!
              : "";

      widget.viewModel.login.clearResult();
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
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Expanded(
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,

                  children: [
                    Text(AppLocalizations.of(context)!.appTitle),
                    Padding(
                      padding: Dimens.of(context).edgeInsetsScreenSymmetric,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          TextField(
                            decoration: InputDecoration(
                              hintText:
                                  AppLocalizations.of(
                                    context,
                                  )!.emailPlaceholder,
                              counterText: "",
                            ),
                            maxLength: 25,
                            controller: _email,
                          ),
                          const SizedBox(height: Dimens.paddingVertical),
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
                                  AppLocalizations.of(
                                    context,
                                  )!.passwordPlaceholder,
                            ),
                            controller: _password,
                            maxLength: 25,
                            obscureText: _obscurePassword,
                          ),
                          const SizedBox(height: Dimens.paddingVertical),

                          RichText(
                            text: TextSpan(
                              style: TextStyle(color: Colors.red),
                              children: <TextSpan>[
                                TextSpan(
                                  text:
                                      AppLocalizations.of(
                                        context,
                                      )!.forgotPassword,
                                  recognizer:
                                      TapGestureRecognizer()
                                        ..onTap = () {
                                          context.go("/recover");
                                        },
                                ),
                              ],
                            ),
                          ),

                          const SizedBox(height: Dimens.paddingVertical),

                          ListenableBuilder(
                            listenable: widget.viewModel,
                            builder: (context, _) {
                              return FilledButton(
                                onPressed: () {
                                  if (_email.value.text == "" ||
                                      _password.value.text == "") {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text(
                                          AppLocalizations.of(
                                            context,
                                          )!.missingInformation,
                                        ),
                                      ),
                                    );
                                  } else {
                                    widget.viewModel.login.running
                                        ? null
                                        : widget.viewModel.login.execute((
                                          _email.value.text,
                                          _password.value.text,
                                        ));
                                  }
                                },
                                child: Text(
                                  AppLocalizations.of(context)!.login,
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            RichText(
              text: TextSpan(
                style: TextStyle(color: Colors.black),
                children: <TextSpan>[
                  TextSpan(text: AppLocalizations.of(context)!.noAccount),
                  TextSpan(
                    text: AppLocalizations.of(context)!.tapHere,
                    style: TextStyle(color: Colors.blue),

                    recognizer:
                        TapGestureRecognizer()
                          ..onTap = () {
                            context.go("/register");
                          },
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
