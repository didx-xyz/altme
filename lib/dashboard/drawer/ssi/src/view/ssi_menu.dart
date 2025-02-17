import 'package:altme/app/app.dart';
import 'package:altme/dashboard/dashboard.dart';
import 'package:altme/dashboard/drawer/ssi/manage_did/view/did_menu.dart';
import 'package:altme/l10n/l10n.dart';
import 'package:altme/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SSIMenu extends StatelessWidget {
  const SSIMenu({super.key});

  static Route<dynamic> route() {
    return MaterialPageRoute<void>(
      settings: const RouteSettings(name: '/ssiMenu'),
      builder: (_) => const SSIMenu(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return const SSIView();
  }
}

class SSIView extends StatelessWidget {
  const SSIView({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    final displayManageDecentralizedId = context
        .read<ProfileCubit>()
        .state
        .model
        .profileSetting
        .selfSovereignIdentityOptions
        .displayManageDecentralizedId;
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
                const SizedBox(
                  height: Sizes.spaceSmall,
                ),
                if (displayManageDecentralizedId)
                  DrawerItem(
                    title: l10n.manageDecentralizedID,
                    onTap: () {
                      Navigator.of(context).push<void>(DidMenu.route());
                    },
                  ),
                DrawerItem(
                  title: l10n.backup,
                  onTap: () async {
                    await Navigator.of(context).push<void>(BackupMenu.route());
                  },
                ),
                DrawerItem(
                  title: l10n.restore,
                  onTap: () async {
                    await Navigator.of(context).push<void>(RestoreMenu.route());
                  },
                ),
                DrawerItem(
                  title: l10n.searchCredentials,
                  onTap: () {
                    Navigator.of(context).push<void>(SearchPage.route());
                  },
                ),
                if (context.read<ProfileCubit>().state.model.profileType ==
                    ProfileType.custom) ...[
                  // DrawerItem(
                  //   title: l10n.oidc4vcProfile,
                  //   onTap: () async {
                  //     await Navigator.of(context)
                  //         .push<void>(OIDC4VCProfilePage.route());
                  //   },
                  // ),
                  DrawerItem(
                    title: l10n.oidc4vc_settings,
                    onTap: () {
                      Navigator.of(context)
                          .push<void>(Oidc4vcSettingMenu.route());
                    },
                  ),
                  DrawerItem(
                    title: l10n.trustFramework,
                    onTap: () async {
                      await Navigator.of(context)
                          .push<void>(TrustFrameworkPage.route());
                    },
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
