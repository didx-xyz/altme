import 'package:altme/app/app.dart';
import 'package:altme/dashboard/profile/profile.dart';
import 'package:altme/l10n/l10n.dart';
import 'package:altme/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class OIDC4VCProfilePage extends StatelessWidget {
  const OIDC4VCProfilePage({super.key});

  static Route<dynamic> route() {
    return MaterialPageRoute<void>(
      builder: (_) => const OIDC4VCProfilePage(),
      settings: const RouteSettings(name: '/OIDC4VCProfilePage'),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return BasePage(
      title: l10n.oidc4vcProfile,
      useSafeArea: true,
      scrollView: false,
      titleAlignment: Alignment.topCenter,
      padding: const EdgeInsets.symmetric(horizontal: Sizes.spaceSmall),
      titleLeading: const BackLeadingButton(),
      body: BlocBuilder<ProfileCubit, ProfileState>(
        builder: (context, state) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              Container(
                padding: const EdgeInsets.all(Sizes.spaceSmall),
                margin: const EdgeInsets.all(Sizes.spaceXSmall),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.cardHighlighted,
                  borderRadius: const BorderRadius.all(
                    Radius.circular(Sizes.largeRadius),
                  ),
                ),
                child: ListView.builder(
                  itemCount: OIDC4VCType.values.length,
                  shrinkWrap: true,
                  physics: const ScrollPhysics(),
                  itemBuilder: (context, index) {
                    final OIDC4VCType currentType = OIDC4VCType.values[index];

                    return Column(
                      children: [
                        ListTile(
                          onTap: () {
                            if (!currentType.isEnabled) {
                              return;
                            }
                          },
                          shape: const RoundedRectangleBorder(
                            side: BorderSide(
                              color: Color(0xFFDDDDEE),
                              width: 0.5,
                            ),
                          ),
                          title: Text(
                            OIDC4VCType.values[index].rename,
                            style: Theme.of(context)
                                .textTheme
                                .bodyLarge
                                ?.copyWith(
                                  color: currentType.isEnabled
                                      ? Theme.of(context).colorScheme.onPrimary
                                      : Theme.of(context).colorScheme.lightGrey,
                                ),
                          ),
                        ),
                        if (index < OIDC4VCType.values.length - 1)
                          Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: Sizes.spaceSmall,
                              vertical: Sizes.spaceXSmall,
                            ),
                            child: Divider(
                              height: 0,
                              color: Theme.of(context).colorScheme.borderColor,
                            ),
                          ),
                      ],
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
