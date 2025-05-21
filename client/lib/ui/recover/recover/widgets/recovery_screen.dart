import 'package:client/ui/recover/recover/view_mode/recover_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class RecoveryScreen extends StatefulWidget {
  const RecoveryScreen({super.key, required this.viewModel});

  final RecoveryViewmodel viewModel;

  @override
  State<StatefulWidget> createState() {
    return _RecoveryScreen();
  }
}

class _RecoveryScreen extends State<RecoveryScreen> {
  final TextEditingController _email = TextEditingController(text: '');

  @override
  void initState() {
    super.initState();
    widget.viewModel.sendPasswordRecoveryEmail.addListener(_onResult);
  }

  @override
  void didUpdateWidget(covariant RecoveryScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    //oldWidget.viewModel.login.removeListener(_onResult);
    //widget.viewModel.login.addListener(_onResult);
  }

  @override
  void dispose() {
    super.dispose();
    widget.viewModel.sendPasswordRecoveryEmail.removeListener(_onResult);
  }

  void _onResult() {
    if (widget.viewModel.sendPasswordRecoveryEmail.completed) {
      String res =
          widget.viewModel.sendPasswordRecoveryEmail.responseData as String;
      widget.viewModel.sendPasswordRecoveryEmail.clearResult();
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(res)));
    }

    if (widget.viewModel.sendPasswordRecoveryEmail.error) {
      String hasError =
          widget.viewModel.sendPasswordRecoveryEmail.errorMessage != null
              ? widget.viewModel.sendPasswordRecoveryEmail.errorMessage!
              : "";

      widget.viewModel.sendPasswordRecoveryEmail.clearResult();
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
                      AppLocalizations.of(
                        context,
                      )!.passwordRecoverEmailPageHeader,
                    ),
                    Text(
                      AppLocalizations.of(
                        context,
                      )!.passwordRecoverEmailPageDesc,
                    ),

                    TextField(
                      decoration: InputDecoration(
                        counterText: "",
                        hintText:
                            AppLocalizations.of(
                              context,
                            )!.forgotPasswordPlaceholder,
                      ),
                      controller: _email,
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
                    widget.viewModel.sendPasswordRecoveryEmail.execute((
                      _email.value.text,
                    ));
                  },
                  child: Text(AppLocalizations.of(context)!.sendEmail),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
