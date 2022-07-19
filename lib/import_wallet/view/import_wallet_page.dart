import 'package:altme/app/app.dart';
import 'package:altme/dashboard/dashboard.dart';
import 'package:altme/did/did.dart';
import 'package:altme/import_wallet/import_wallet.dart';
import 'package:altme/l10n/l10n.dart';
import 'package:altme/theme/theme.dart';
import 'package:altme/wallet/cubit/wallet_cubit.dart';
import 'package:did_kit/did_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:key_generator/key_generator.dart';
import 'package:secure_storage/secure_storage.dart';

class ImportWalletPage extends StatelessWidget {
  const ImportWalletPage({
    Key? key,
    this.accountName,
    required this.isFromOnboarding,
  }) : super(key: key);

  static Route route({String? accountName, required bool isFromOnboarding}) =>
      MaterialPageRoute<void>(
        builder: (context) => ImportWalletPage(
          accountName: accountName,
          isFromOnboarding: isFromOnboarding,
        ),
        settings: const RouteSettings(name: '/onBoardingRecoveryPage'),
      );

  final String? accountName;
  final bool isFromOnboarding;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ImportWalletCubit(
        secureStorageProvider: getSecureStorage,
        didCubit: context.read<DIDCubit>(),
        didKitProvider: DIDKitProvider(),
        keyGenerator: KeyGenerator(),
        homeCubit: context.read<HomeCubit>(),
        walletCubit: context.read<WalletCubit>(),
      ),
      child: ImportWalletView(
        accountName: accountName,
        isFromOnboarding: isFromOnboarding,
      ),
    );
  }
}

class ImportWalletView extends StatefulWidget {
  const ImportWalletView({
    Key? key,
    this.accountName,
    required this.isFromOnboarding,
  }) : super(key: key);

  final String? accountName;
  final bool isFromOnboarding;

  @override
  _ImportWalletViewState createState() => _ImportWalletViewState();
}

class _ImportWalletViewState extends State<ImportWalletView> {
  late TextEditingController mnemonicController;

  @override
  void initState() {
    super.initState();

    mnemonicController = TextEditingController();
    mnemonicController.addListener(() {
      context
          .read<ImportWalletCubit>()
          .isMnemonicsOrKeyValid(mnemonicController.text);
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return WillPopScope(
      onWillPop: () async {
        if (context.read<ImportWalletCubit>().state.status ==
            AppStatus.loading) {
          return false;
        }
        return true;
      },
      child: BlocConsumer<ImportWalletCubit, ImportWalletState>(
        listener: (context, state) {
          if (state.status == AppStatus.loading) {
            LoadingView().show(context: context);
          } else {
            LoadingView().hide();
          }

          if (state.message != null) {
            AlertMessage.showStateMessage(
              context: context,
              stateMessage: state.message!,
            );
          }
          if (state.status == AppStatus.success) {
            /// Removes every stack except first route (splashPage)
            Navigator.pushAndRemoveUntil<void>(
              context,
              DashboardPage.route(),
              (Route<dynamic> route) => route.isFirst,
            );
          }
        },
        builder: (context, state) {
          return BasePage(
            title: l10n.importAccount,
            titleLeading: const BackLeadingButton(),
            scrollView: false,
            useSafeArea: true,
            padding: const EdgeInsets.all(Sizes.spaceSmall),
            body: BackgroundCard(
              padding: const EdgeInsets.all(Sizes.spaceSmall),
              height: double.infinity,
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    const SizedBox(height: Sizes.spaceLarge),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: Sizes.spaceLarge,
                      ),
                      child: Text(
                        l10n.importWalletText,
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              letterSpacing: 1.2,
                            ),
                      ),
                    ),
                    const SizedBox(height: Sizes.space2XLarge),
                    Text(
                      l10n.importEasilyFrom,
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: Sizes.spaceSmall),
                    WalletTypeList(
                      onItemTap: (wallet) {
                        Navigator.of(context).push<void>(
                          ImportFromOtherWalletPage.route(
                            walletTypeModel: wallet,
                            accountName: widget.accountName,
                            isFromOnboard: widget.isFromOnboarding,
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: Sizes.spaceLarge),
                    Text(
                      l10n.recoveryPhraseDescriptions,
                      style: Theme.of(context).textTheme.infoSubtitle.copyWith(
                            fontSize: 12,
                          ),
                    ),
                    const SizedBox(height: Sizes.spaceLarge),
                    Text(
                      l10n.privateKeyDescriptions,
                      style: Theme.of(context).textTheme.infoSubtitle.copyWith(
                            fontSize: 12,
                          ),
                    ),
                    const SizedBox(height: Sizes.spaceNormal),
                  ],
                ),
              ),
            ),
            navigation: SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(Sizes.spaceSmall),
                child: MyGradientButton(
                  text: l10n.import,
                  onPressed: !state.isMnemonicOrKeyValid
                      ? null
                      : () async {
                          await context
                              .read<ImportWalletCubit>()
                              .saveMnemonicOrKey(
                                mnemonicOrKey: mnemonicController.text,
                                accountName: widget.accountName,
                                isFromOnboarding: widget.isFromOnboarding,
                              );
                        },
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
