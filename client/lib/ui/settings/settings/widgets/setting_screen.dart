import 'package:client/ui/core/theme/dimens.dart';
import 'package:client/ui/recover/update/view_mode/update_password_viewmodel.dart';
import 'package:client/ui/settings/settings/view_models/settings_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:go_router/go_router.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key, required this.viewModel});

  final SettingsViewModel viewModel;

  @override
  State<StatefulWidget> createState() {
    return _SettingsScreen();
  }
}

class _SettingsScreen extends State<SettingsScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void didUpdateWidget(covariant SettingsScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              AccountCard(viewModel: widget.viewModel),
              LogoutButton(viewModel: widget.viewModel),
            ],
          ),
        ),
      ),
    );
  }
}

class AccountCard extends StatefulWidget {
  const AccountCard({super.key, required this.viewModel});

  final SettingsViewModel viewModel;

  @override
  State<StatefulWidget> createState() {
    return _AccountCard();
  }
}

class _AccountCard extends State<AccountCard> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.maxFinite,
      child: Card(
        elevation: 5,
        margin: Dimens.of(context).edgeInsetsScreenSymmetric,
        child: Padding(
          padding: Dimens.of(context).edgeInsetsScreenSymmetric,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                AppLocalizations.of(context)!.settingsAccountTitle,
                style: TextStyle(fontWeight: FontWeight.w300),
              ),
              Divider(color: Colors.grey),

              UpdateUsernameButton(viewModel: widget.viewModel),
              UpdatePasswordButton(viewModel: widget.viewModel),
              UpdateEmailButton(viewModel: widget.viewModel),
            ],
          ),
        ),
      ),
    );
  }
}

class UpdateUsernameButton extends StatefulWidget {
  const UpdateUsernameButton({super.key, required this.viewModel});

  final SettingsViewModel viewModel;

  @override
  State<StatefulWidget> createState() {
    return _UpdateUsernameButton();
  }
}

class _UpdateUsernameButton extends State<UpdateUsernameButton> {
  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () {
        context.go("/home/settings/username");
      },
      style: ButtonStyle(
        overlayColor: WidgetStateProperty.all(Colors.transparent),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Icon(Icons.perm_identity, size: 16),
              Padding(
                padding: const EdgeInsets.only(left: 5.0),
                child: Text(
                  AppLocalizations.of(context)!.settingsUpdateUsername,
                ),
              ),
            ],
          ),
          Icon(Icons.arrow_forward_ios, size: 12, color: Colors.grey),
        ],
      ),
    );
  }
}

class UpdatePasswordButton extends StatefulWidget {
  const UpdatePasswordButton({super.key, required this.viewModel});

  final SettingsViewModel viewModel;

  @override
  State<StatefulWidget> createState() {
    return _UpdatePasswordButton();
  }
}

class _UpdatePasswordButton extends State<UpdatePasswordButton> {
  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () {
        context.go("/home/settings/password");
      },
      style: ButtonStyle(
        overlayColor: WidgetStateProperty.all(Colors.transparent),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Icon(Icons.password, size: 16),
              Padding(
                padding: const EdgeInsets.only(left: 5.0),
                child: Text("Update Passowrd"),
              ),
            ],
          ),
          Icon(Icons.arrow_forward_ios, size: 12, color: Colors.grey),
        ],
      ),
    );
  }
}

class UpdateEmailButton extends StatefulWidget {
  const UpdateEmailButton({super.key, required this.viewModel});

  final SettingsViewModel viewModel;

  @override
  State<StatefulWidget> createState() {
    return _UpdateEmailButton();
  }
}

class _UpdateEmailButton extends State<UpdateEmailButton> {
  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () {
        context.go("/home/settings/email");
      },
      style: ButtonStyle(
        overlayColor: WidgetStateProperty.all(Colors.transparent),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Icon(Icons.email, size: 16),
              Padding(
                padding: const EdgeInsets.only(left: 5.0),
                child: Text("Update Email"),
              ),
            ],
          ),
          Icon(Icons.arrow_forward_ios, size: 12, color: Colors.grey),
        ],
      ),
    );
  }
}

class LogoutButton extends StatefulWidget {
  const LogoutButton({super.key, required this.viewModel});

  final SettingsViewModel viewModel;

  @override
  State<StatefulWidget> createState() {
    return _LogoutButton();
  }
}

class _LogoutButton extends State<LogoutButton> {
  Future<void> _showConfirmationDialog(BuildContext context) async {
    await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog.adaptive(
          title: Text(AppLocalizations.of(context)!.popUpConfirmationTitle),
          content: Text(
            AppLocalizations.of(context)!.popUpLogOutConfirmationDesc,
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(false);
              },
              child: Text(AppLocalizations.of(context)!.popUpCancel),
            ),
            ListenableBuilder(
              listenable: widget.viewModel,
              builder: (context, _) {
                return FilledButton(
                  onPressed: () {
                    widget.viewModel.logout();
                  },
                  child: Text(AppLocalizations.of(context)!.popUpConfirm),
                );
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: Dimens.of(context).edgeInsetsScreenSymmetric,
      child: SizedBox(
        width: double.maxFinite,
        child: FilledButton(
          onPressed: () {
            _showConfirmationDialog(context);
          },
          child: Text(AppLocalizations.of(context)!.logOut),
        ),
      ),
    );
  }
}
