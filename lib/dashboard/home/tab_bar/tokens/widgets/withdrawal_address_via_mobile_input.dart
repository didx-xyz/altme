import 'package:altme/app/app.dart';
import 'package:altme/dashboard/dashboard.dart';
import 'package:altme/l10n/l10n.dart';
import 'package:altme/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';

class WithdrawalAddressViaMobileInputView extends StatelessWidget {
  const WithdrawalAddressViaMobileInputView({
    super.key,
    this.caption,
    this.withdrawalMobileNumberController,
    this.withdrawalAddressController,
    this.onValidAddress,
  });

  final String? caption;
  final TextEditingController? withdrawalMobileNumberController;
  final TextEditingController? withdrawalAddressController;
  final dynamic Function(String)? onValidAddress;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => WithdrawalInputCubit(),
      child: _WithdrawalAddressViaMobileInputPage(
        withdrawalMobileNumberController: withdrawalMobileNumberController,
        withdrawalAddressController: withdrawalAddressController,
        caption: caption,
        onValidAddress: onValidAddress,
      ),
    );
  }
}

class _WithdrawalAddressViaMobileInputPage extends StatefulWidget {
  const _WithdrawalAddressViaMobileInputPage({
    this.caption,
    this.withdrawalMobileNumberController,
    this.withdrawalAddressController,
    this.onValidAddress,
  });

  final String? caption;
  final TextEditingController? withdrawalMobileNumberController;
  final TextEditingController? withdrawalAddressController;
  final dynamic Function(String)? onValidAddress;

  @override
  State<_WithdrawalAddressViaMobileInputPage> createState() =>
      _WithdrawalAddressViaMobileInputPageState();
}

class _WithdrawalAddressViaMobileInputPageState
    extends State<_WithdrawalAddressViaMobileInputPage>
    with WalletAddressValidator {
  late final withdrawalMobileNumberController =
      widget.withdrawalMobileNumberController ?? TextEditingController();
  late final withdrawalAddressController =
      widget.withdrawalAddressController ?? TextEditingController();

  final formKey = GlobalKey<FormState>();
  AutovalidateMode autoValidateMode = AutovalidateMode.always;

  String? phoneNumberInput;

  String? phoneNumberValidated;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return BackgroundCard(
      color: Theme.of(context).colorScheme.cardBackground,
      padding: const EdgeInsets.only(
        top: Sizes.spaceSmall,
        right: Sizes.spaceSmall,
        left: Sizes.spaceSmall,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          if (widget.caption != null)
            Text(
              widget.caption!,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
            ),
          const SizedBox(
            height: Sizes.spaceSmall,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: InternationalPhoneNumberInput(
                  onInputChanged: (PhoneNumber number) {
                    print(number.phoneNumber);
                    phoneNumberInput = number.phoneNumber;
                  },
                  onInputValidated: (bool value) {
                    if (value) {
                      phoneNumberValidated = phoneNumberInput;
                      withdrawalAddressController.text =
                          'Address from proxy here';
                    } else {
                      phoneNumberValidated = null;
                    }
                  },
                  inputDecoration: const InputDecoration(
                    // Use InputDecoration to add an icon inside the input field
                    hintText: 'Number',
                    prefixIcon: Icon(Icons
                        .phone), // Adds a phone icon inside the input field
                    border: OutlineInputBorder(),
                  ),
                  selectorConfig: const SelectorConfig(
                    selectorType: PhoneInputSelectorType.DIALOG,
                  ),
                  ignoreBlank: true,
                  autoValidateMode: AutovalidateMode.always,
                  selectorTextStyle: const TextStyle(color: Colors.white),
                  initialValue: PhoneNumber(isoCode: 'ZA'),
                  textFieldController: TextEditingController(),
                  formatInput: false,
                  keyboardType: const TextInputType.numberWithOptions(
                    signed: false,
                    decimal: false,
                  ),
                  inputBorder: const OutlineInputBorder(),
                ),
              ),

              // const SizedBox(
              //   width: Sizes.spaceSmall,
              // ),
            ],
          ),
          const SizedBox(
            height: Sizes.spaceNormal,
          ),
        ],
      ),
    );
  }
}
