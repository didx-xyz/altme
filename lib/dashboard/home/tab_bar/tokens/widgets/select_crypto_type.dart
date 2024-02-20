import 'package:altme/dashboard/home/home.dart';
import 'package:altme/l10n/l10n.dart';
import 'package:altme/wallet/wallet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SelectCryptoWidget extends StatelessWidget {
  const SelectCryptoWidget({
    super.key,
    this.isEnabled = true,
  });

  final bool isEnabled;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return BlocBuilder<WalletCubit, WalletState>(
      builder: (context, walletState) {
        return AccountSelectBoxView(
          title: 'Account to link', // l10n.from,
          isEnabled: isEnabled,
          accounts: walletState.cryptoAccount.data,
          selectedAccountIndex: walletState.currentCryptoIndex,
          onSelectAccount: (accountData, index) {
            context.read<WalletCubit>().setCurrentWalletAccount(index);
          },
        );
      },
    );
  }
}
