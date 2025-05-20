import 'package:flutter/material.dart';

class LogoutButton extends StatefulWidget {
  const LogoutButton({super.key});

  @override
  State<StatefulWidget> createState() {
    return _LogoutButton();
  }
}

class _LogoutButton extends State<LogoutButton> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void didUpdateWidget(covariant LogoutButton oldWidget) {
    super.didUpdateWidget(oldWidget);
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: Text("Logout Button"));
  }
}
