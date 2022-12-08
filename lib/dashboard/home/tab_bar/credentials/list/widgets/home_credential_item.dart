import 'package:altme/app/app.dart';
import 'package:altme/dashboard/dashboard.dart';
import 'package:altme/deep_link/cubit/deep_link.dart';
import 'package:altme/l10n/l10n.dart';
import 'package:altme/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:secure_storage/secure_storage.dart';
import 'package:uuid/uuid.dart';

class HomeCredentialItem extends StatelessWidget {
  const HomeCredentialItem({
    Key? key,
    required this.homeCredential,
    required this.fromDiscover,
  }) : super(key: key);

  final HomeCredential homeCredential;
  final bool fromDiscover;

  @override
  Widget build(BuildContext context) {
    return homeCredential.isDummy
        ? DummyCredentialItem(
            homeCredential: homeCredential,
            fromDiscover: fromDiscover,
          )
        : RealCredentialItem(credentialModel: homeCredential.credentialModel!);
  }
}

class RealCredentialItem extends StatelessWidget {
  const RealCredentialItem({Key? key, required this.credentialModel})
      : super(key: key);

  final CredentialModel credentialModel;

  @override
  Widget build(BuildContext context) {
    return BackgroundCard(
      padding: const EdgeInsets.all(4),
      child: GestureDetector(
        onTap: () {
          Navigator.of(context).push<void>(
            CredentialsDetailsPage.route(credentialModel),
          );
        },
        child: CredentialsListPageItem(
          credentialModel: credentialModel,
        ),
      ),
    );
  }
}

class DummyCredentialItem extends StatelessWidget {
  const DummyCredentialItem({
    Key? key,
    required this.homeCredential,
    required this.fromDiscover,
  }) : super(key: key);

  final HomeCredential homeCredential;
  final bool fromDiscover;

  Future<void> goAhead(BuildContext context) async {
    final l10n = context.l10n;

    final List<CredentialSubjectType> credentialSubjectTypeList =
        List.of(DiscoverList.identityCategories);

    /// items to remove to bypass KYC
    credentialSubjectTypeList.remove(CredentialSubjectType.emailPass);
    credentialSubjectTypeList.remove(CredentialSubjectType.phonePass);

    if (credentialSubjectTypeList.contains(
      homeCredential.credentialSubjectType,
    )) {
      //here check for over18 and over13 to take photo for AI KYC
      if (homeCredential.credentialSubjectType ==
              CredentialSubjectType.over18 ||
          homeCredential.credentialSubjectType ==
              CredentialSubjectType.over13 ||
          homeCredential.credentialSubjectType ==
              CredentialSubjectType.ageRange) {
        final passbaseStatus =
            await context.read<HomeCubit>().checkPassbaseStatus();
        if (passbaseStatus != PassBaseStatus.approved) {
          // start verification by Yoti AI
          await Navigator.of(context).push<void>(
            VerifyAgePage.route(
              credentialSubjectType: homeCredential.credentialSubjectType,
            ),
          );
        } else {
          // get credential from launching the url
          await context.read<HomeCubit>().launchUrl(link: homeCredential.link);
        }
      } else {
        await context.read<HomeCubit>().checkForPassBaseStatusThenLaunchUrl(
              link: homeCredential.link!,
            );
      }
    } else {
      /// check if  credential it is
      /// [CredentialSubjectType.tezotopiaMembership]
      if (homeCredential.credentialSubjectType ==
          CredentialSubjectType.tezotopiaMembership) {
        final CredentialsRepository repository =
            CredentialsRepository(getSecureStorage);

        final List<CredentialModel> allCredentials = await repository.findAll();

        bool isPresentable = false;

        for (final type in membershipRequiredList) {
          for (final credential in allCredentials) {
            if (type ==
                credential.credentialPreview.credentialSubjectModel
                    .credentialSubjectType) {
              isPresentable = true;
              break;
            } else {
              isPresentable = false;
            }
          }
          if (!isPresentable) {
            await showDialog<bool>(
              context: context,
              builder: (context) => InfoDialog(
                title:
                    '''${l10n.membershipRequiredListAlerMessage}\n\nOver 13 Proof''',
                button: l10n.ok,
              ),
            );
            return;
          }
        }
        context.read<DeepLinkCubit>().addDeepLink(
              // ignore: lines_longer_than_80_chars
              '${homeCredential.link!}${const Uuid().v4()}?issuer=did:tz:tz1NyjrTUNxDpPaqNZ84ipGELAcTWYg6s5Du',
            );
        await context.read<QRCodeScanCubit>().deepLink();
      } else {
        await LaunchUrl.launch(homeCredential.link!);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return BackgroundCard(
      color: Theme.of(context).colorScheme.credentialBackground,
      padding: const EdgeInsets.all(4),
      child: InkWell(
        onTap: () async {
          if (context.read<HomeCubit>().state.homeStatus ==
              HomeStatus.hasNoWallet) {
            await showDialog<void>(
              context: context,
              builder: (_) => const WalletDialog(),
            );
            return;
          }

          await Navigator.push<void>(
            context,
            DiscoverDetailsPage.route(
              homeCredential: homeCredential,
              onCallBack: () async {
                Navigator.pop(context);
                await goAhead(context);
              },
            ),
          );
        },
        child: Column(
          children: [
            Expanded(
              flex: 8,
              child: CredentialImage(
                image: homeCredential.image!,
                child: homeCredential.dummyDescription == null
                    ? null
                    : CustomMultiChildLayout(
                        delegate: DummyCredentialItemDelegate(
                          position: Offset.zero,
                        ),
                        children: [
                          LayoutId(
                            id: 'dummyDesc',
                            child: FractionallySizedBox(
                              widthFactor: 0.85,
                              heightFactor: 0.42,
                              child: Text(
                                homeCredential.dummyDescription!.getMessage(
                                  context,
                                  homeCredential.dummyDescription!,
                                ),
                                style: Theme.of(context)
                                    .textTheme
                                    .discoverOverlayDescription,
                              ),
                            ),
                          ),
                        ],
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class DummyCredentialItemDelegate extends MultiChildLayoutDelegate {
  DummyCredentialItemDelegate({this.position = Offset.zero});

  final Offset position;

  @override
  void performLayout(Size size) {
    if (hasChild('dummyDesc')) {
      layoutChild('dummyDesc', BoxConstraints.loose(size));
      positionChild(
        'dummyDesc',
        Offset(size.width * 0.06, size.height * 0.35),
      );
    }
  }

  @override
  bool shouldRelayout(DummyCredentialItemDelegate oldDelegate) {
    return oldDelegate.position != position;
  }
}
