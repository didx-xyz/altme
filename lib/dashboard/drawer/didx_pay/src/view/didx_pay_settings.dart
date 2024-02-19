import 'package:altme/dashboard/dashboard.dart';
import 'package:altme/l10n/l10n.dart';
import 'package:altme/app/app.dart';

import 'package:altme/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../set_didx_proxy/view/set_didx_proxy_input.dart';

class DidxPaySettings extends StatelessWidget {
  const DidxPaySettings({super.key});

  static Route<dynamic> route() {
    return MaterialPageRoute<void>(
      builder: (_) => const DidxPaySettings(),
      settings: const RouteSettings(name: '/DidxPaySettings'),
    );
  }

  @override
  Widget build(BuildContext context) {
    return const DidxPaySettingsView();
  }
}

class DidxPaySettingsView extends StatelessWidget {
  const DidxPaySettingsView({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return BlocBuilder<ProfileCubit, ProfileState>(
      builder: (context, state) {
        return Drawer(
          backgroundColor: Theme.of(context).colorScheme.drawerBackground,
          child: SafeArea(
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
                    DrawerItem(
                      title: l10n.readProxy,
                      onTap: () {
                        Navigator.of(context)
                            .push<void>(ManageAccountsPage.route());
                      },
                    ),
                    DrawerItem(
                      title: l10n.updateProxy,
                      onTap: () {
                        Navigator.of(context).push<void>(UpdateProxy.route());
                      },
                    ),
                    DrawerItem(
                      title: l10n.deleteProxy,
                      onTap: () {
                        Navigator.of(context)
                            .push<void>(ManageAccountsPage.route());
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
