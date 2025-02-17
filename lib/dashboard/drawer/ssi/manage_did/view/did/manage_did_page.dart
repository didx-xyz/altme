import 'package:altme/app/app.dart';
import 'package:altme/dashboard/dashboard.dart';
import 'package:altme/l10n/l10n.dart';
import 'package:did_kit/did_kit.dart';
import 'package:flutter/material.dart';
import 'package:oidc4vc/oidc4vc.dart';
import 'package:secure_storage/secure_storage.dart';

class ManageDidPage extends StatefulWidget {
  const ManageDidPage({
    super.key,
    required this.didKeyType,
  });

  final DidKeyType didKeyType;

  static Route<dynamic> route({
    required DidKeyType didKeyType,
  }) {
    return MaterialPageRoute<void>(
      builder: (_) => ManageDidPage(
        didKeyType: didKeyType,
      ),
      settings: const RouteSettings(name: '/ManageDidPage'),
    );
  }

  @override
  State<ManageDidPage> createState() => _ManageDidEbsiPageState();
}

class _ManageDidEbsiPageState extends State<ManageDidPage> {
  Future<String> getDid() async {
    final privateKey = await getPrivateKey(
      secureStorage: getSecureStorage,
      didKeyType: widget.didKeyType,
      oidc4vc: OIDC4VC(),
    );

    final (did, _) = await getDidAndKid(
      didKeyType: widget.didKeyType,
      privateKey: privateKey,
      secureStorage: getSecureStorage,
      didKitProvider: DIDKitProvider(),
    );

    return did;
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return BasePage(
      title: l10n.decentralizedIDKey,
      titleAlignment: Alignment.topCenter,
      scrollView: false,
      titleLeading: const BackLeadingButton(),
      body: BackgroundCard(
        height: double.infinity,
        width: double.infinity,
        padding: const EdgeInsets.all(Sizes.spaceSmall),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            children: [
              FutureBuilder<String>(
                future: getDid(),
                builder: (context, snapshot) {
                  switch (snapshot.connectionState) {
                    case ConnectionState.done:
                      final did = snapshot.data!;
                      return Did(did: did);
                    case ConnectionState.waiting:
                    case ConnectionState.none:
                    case ConnectionState.active:
                      return const SizedBox();
                  }
                },
              ),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: Sizes.spaceNormal),
                child: Divider(),
              ),
              DidPrivateKey(
                route: DidPrivateKeyPage.route(
                  didKeyType: widget.didKeyType,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
