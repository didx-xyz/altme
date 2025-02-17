import 'package:altme/app/app.dart';
import 'package:altme/dashboard/dashboard.dart';
import 'package:altme/l10n/l10n.dart';
import 'package:altme/query_by_example/model/query.dart';
import 'package:altme/theme/theme.dart';
import 'package:credential_manifest/credential_manifest.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:secure_storage/secure_storage.dart' as secure_storage;

class MissingCredentialsPage extends StatelessWidget {
  const MissingCredentialsPage({
    super.key,
    this.credentialManifest,
    this.query,
  });

  final CredentialManifest? credentialManifest;
  final Query? query;

  static Route<dynamic> route({
    CredentialManifest? credentialManifest,
    Query? query,
  }) =>
      MaterialPageRoute<void>(
        builder: (_) => MissingCredentialsPage(
          credentialManifest: credentialManifest,
          query: query,
        ),
        settings: const RouteSettings(name: '/MissingCredentialsPage'),
      );

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => MissingCredentialsCubit(
        secureStorageProvider: secure_storage.getSecureStorage,
        repository: CredentialsRepository(secure_storage.getSecureStorage),
        credentialManifest: credentialManifest,
        query: query,
        profileCubit: context.read<ProfileCubit>(),
      ),
      child: MissingCredentialsView(
        credentialManifest: credentialManifest,
        query: query,
      ),
    );
  }
}

class MissingCredentialsView extends StatelessWidget {
  const MissingCredentialsView({
    super.key,
    this.credentialManifest,
    this.query,
  });

  final CredentialManifest? credentialManifest;
  final Query? query;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    String issuerName = '';

    if (credentialManifest != null) {
      issuerName = credentialManifest!.issuedBy!.name;
    }

    if (query != null) {
      // TOOD(bibash): Is there issuer name?
      issuerName = '';
    }

    return BlocBuilder<MissingCredentialsCubit, MissingCredentialsState>(
      builder: (context, state) {
        return BasePage(
          title: l10n.getCards,
          titleAlignment: Alignment.topCenter,
          scrollView: false,
          titleLeading: const BackLeadingButton(),
          padding: const EdgeInsets.symmetric(horizontal: 10),
          body: Column(
            children: [
              Text(
                '''${l10n.youAreMissing} ${state.dummyCredentials.length} ${l10n.credentialsRequestedBy} $issuerName.''',
                style: Theme.of(context).textTheme.discoverFieldDescription,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              Expanded(
                child: ListView.builder(
                  itemCount: state.dummyCredentials.length,
                  physics: const ScrollPhysics(),
                  shrinkWrap: true,
                  itemBuilder: (context, i) {
                    final discoverDummyCredential = state.dummyCredentials[i];
                    final credentialType =
                        discoverDummyCredential.credentialSubjectType;
                    return Container(
                      margin: const EdgeInsets.only(
                        bottom: 15,
                        right: 10,
                        left: 10,
                      ),
                      child: credentialType.isBlockchainAccount
                          ? credentialType.blockchainWidget
                          : DummyCredentialImage(
                              credentialSubjectType: credentialType,
                              image: discoverDummyCredential.image,
                            ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 10),
              MyGradientButton(
                onPressed: () async {
                  for (final credentials in state.dummyCredentials) {
                    if (credentials.credentialSubjectType.isBlockchainAccount) {
                      await Navigator.of(context)
                          .push<void>(ChooseAddAccountMethodPage.route());
                    } else {
                      await Navigator.push<void>(
                        context,
                        DiscoverDetailsPage.route(
                          dummyCredential: credentials,
                          buttonText: l10n.getThisCard,
                          onCallBack: () async {
                            await discoverCredential(
                              dummyCredential: credentials,
                              context: context,
                            );
                            Navigator.pop(context);
                          },
                        ),
                      );
                    }
                  }
                  Navigator.pop(context);
                },
                text: l10n.getItNow,
              ),
              const SizedBox(height: 10),
              MyOutlinedButton(
                verticalSpacing: 20,
                onPressed: () {
                  Navigator.pop(context);
                },
                text: l10n.cancel,
              ),
            ],
          ),
        );
      },
    );
  }
}
