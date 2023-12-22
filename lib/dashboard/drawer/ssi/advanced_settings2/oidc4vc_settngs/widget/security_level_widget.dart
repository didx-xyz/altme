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
        return OptionContainer(
          title: l10n.securityLevelTitle,
          subtitle: l10n.securityLevelSubTitle,
          body: Switch(
            onChanged: (value) async {
              await context.read<ProfileCubit>().updateProfileSetting(
                    securityLevel: value,
                  );
            },
            value: state.model.profileSetting.selfSovereignIdentityOptions
                .customOidc4vcProfile.securityLevel,
            activeColor: Theme.of(context).colorScheme.primary,
          ),
        );
      },
    );
  }
}
