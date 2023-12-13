import 'package:altme/app/app.dart';
import 'package:altme/dashboard/dashboard.dart';
import 'package:altme/l10n/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SecurityLevelWidget extends StatelessWidget {
  const SecurityLevelWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return BlocBuilder<ProfileCubit, ProfileState>(
      builder: (context, state) {
        return DrawerItem2(
          title: l10n.securityLevelTitle,
          subtitle: l10n.securityLevelSubTitle,
          trailing: SizedBox(
            height: 25,
            child: BlocBuilder<ProfileCubit, ProfileState>(
              builder: (context, state) {
                return Switch(
                  onChanged: (value) async {
                    await context.read<ProfileCubit>().updateProfileSetting(
                          securityLevel:
                              value ? SecurityLevel.high : SecurityLevel.low,
                        );
                  },
                  value: state.model.profileSetting.selfSovereignIdentityOptions
                          .customOidc4vcProfile.securityLevel ==
                      SecurityLevel.high,
                  activeColor: Theme.of(context).colorScheme.primary,
                );
              },
            ),
          ),
        );
      },
    );
  }
}
