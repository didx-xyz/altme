import 'package:altme/l10n/l10n.dart';
import 'package:altme/pin_code/view/confirm_pin_code_page.dart';
import 'package:altme/pin_code/widgets/widgets.dart';
import 'package:flutter/material.dart';

class PinCodePage extends StatefulWidget {
  const PinCodePage({
    Key? key,
  }) : super(key: key);

  static MaterialPageRoute Route() {
    return MaterialPageRoute<void>(builder: (_) => const PinCodePage());
  }

  @override
  State<StatefulWidget> createState() => _PinCodePageState();
}

class _PinCodePageState extends State<PinCodePage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: SafeArea(
        child: PinCodeView(
          title: l10n.enterNewPinCode,
          passwordEnteredCallback: _onPasscodeEntered,
          deleteButton: Text(
            l10n.delete,
            style: Theme.of(context).textTheme.button,
          ),
          cancelButton: Text(
            l10n.cancel,
            style: Theme.of(context).textTheme.button,
          ),
          cancelCallback: _onPasscodeCancelled,
        ),
      ),
    );
  }

  void _onPasscodeEntered(String enteredPasscode) {
    ConfirmPinCodePage.storedPassword = enteredPasscode;
    Navigator.pushReplacement<dynamic, dynamic>(
      context,
      ConfirmPinCodePage.Route(),
    );
    // TODO(Taleb): Navigate to confirm password
  }

  void _onPasscodeCancelled() {
    Navigator.maybePop(context);
  }
}
