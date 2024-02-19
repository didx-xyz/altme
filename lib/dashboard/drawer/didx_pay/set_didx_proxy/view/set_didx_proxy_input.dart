import 'package:altme/dashboard/dashboard.dart';
import 'package:altme/l10n/l10n.dart';
import 'package:altme/app/app.dart';

import 'package:altme/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';

class UpdateProxy extends StatefulWidget {
  const UpdateProxy({super.key});

  static Route<dynamic> route() {
    return MaterialPageRoute<void>(
      builder: (_) => const UpdateProxy(),
      settings: const RouteSettings(name: '/DidxPaySettings'),
    );
  }

  @override
  State<UpdateProxy> createState() => _UpdateProxyState();
}

class _UpdateProxyState extends State<UpdateProxy> {
  @override
  Widget build(BuildContext context) {
    return const UpdateProxyView();
  }
}

class UpdateProxyView extends StatefulWidget {
  const UpdateProxyView({super.key});

  @override
  State<UpdateProxyView> createState() => _UpdateProxyViewState();
}

class _UpdateProxyViewState extends State<UpdateProxyView> {
  String? phoneNumber;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return BlocBuilder<ProfileCubit, ProfileState>(
      builder: (context, state) {
        return Container(
          color: Theme.of(context).colorScheme.drawerBackground,
          child: SafeArea(
            child: Material(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      BackLeadingButton(
                        padding: EdgeInsets.zero,
                        color: Theme.of(context).colorScheme.onPrimary,
                      ),
                      WalletLogo(
                        profileModel: context.read<ProfileCubit>().state.model,
                        height: 90,
                        width: MediaQuery.of(context).size.shortestSide * 0.5,
                        showPoweredBy: true,
                      ),
                      const SizedBox(height: Sizes.spaceSmall),
                      Text(
                        l10n.updateProxy,
                        style: Theme.of(context).textTheme.titleSmall,
                      ),
                      const SizedBox(height: Sizes.spaceSmall),
                      Center(
                        child: InternationalPhoneNumberInput(
                          onInputChanged: (PhoneNumber number) {
                            print(number.phoneNumber);
                            phoneNumber = number.phoneNumber;
                          },
                          onInputValidated: (bool value) {
                            print(value
                                ? 'Valid phone number'
                                : 'Invalid phone number');
                          },
                          selectorConfig: const SelectorConfig(
                            selectorType: PhoneInputSelectorType.DIALOG,
                          ),
                          ignoreBlank: true,
                          autoValidateMode: AutovalidateMode.always,
                          selectorTextStyle:
                              const TextStyle(color: Colors.white),
                          initialValue: PhoneNumber(isoCode: 'ZA'),
                          textFieldController: TextEditingController(),
                          formatInput: false,
                          keyboardType: const TextInputType.numberWithOptions(
                            signed: false,
                            decimal: false,
                          ),
                          inputBorder: const OutlineInputBorder(),
                          onSaved: (PhoneNumber number) {
                            print('On Saved: $number');
                          },
                        ),
                      ),
                      const SizedBox(height: Sizes.spaceLarge),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset(
                            'assets/icon/link-vertical.png',
                            width: 60,
                            height: 60,
                          ),
                        ],
                      ),
                      const SizedBox(height: Sizes.spaceLarge),
                      TextFormField(
                        decoration: const InputDecoration(
                          labelText: 'Wallet Address',
                          hintText: 'e.g., 1BoatSLRHtKNngkdXEeobR76b53LETtpyT',
                          border: OutlineInputBorder(),
                          prefixIcon: Icon(Icons.account_balance_wallet),
                        ),
                        validator: (value) {
                          // Basic validation example
                          if (value == null || value.isEmpty) {
                            return 'Please enter your wallet address';
                          }
                          // Add more specific validation for wallet address format if needed
                          return null; // Return null if the input is valid
                        },
                        onSaved: (value) {
                          // Save the wallet address
                          print('Wallet Address: $value');
                          // You might want to store this in a variable or state management solution
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
