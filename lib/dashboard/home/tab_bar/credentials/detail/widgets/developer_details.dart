import 'package:altme/app/app.dart';
import 'package:altme/dashboard/dashboard.dart';
import 'package:altme/l10n/l10n.dart';
import 'package:altme/theme/theme.dart';
import 'package:flutter/material.dart';

class DeveloperDetails extends StatelessWidget {
  const DeveloperDetails({
    super.key,
    required this.credentialModel,
  });

  final CredentialModel credentialModel;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    final String issuerDid = credentialModel.credentialPreview.issuer;
    final String subjectDid =
        credentialModel.credentialPreview.credentialSubjectModel.id ?? '';
    final String type = credentialModel.credentialPreview.type.toString();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 10),
        CredentialField(
          padding: EdgeInsets.zero,
          title: l10n.format,
          value: credentialModel.getFormat,
          titleColor: Theme.of(context).colorScheme.titleColor,
          valueColor: Theme.of(context).colorScheme.valueColor,
        ),
        const SizedBox(height: 10),
        CredentialField(
          padding: EdgeInsets.zero,
          title: l10n.issuerDID,
          value: issuerDid,
          titleColor: Theme.of(context).colorScheme.titleColor,
          valueColor: Theme.of(context).colorScheme.valueColor,
        ),
        if (credentialModel.credentialPreview.credentialSubjectModel
                is! WalletCredentialModel &&
            subjectDid.isNotEmpty) ...[
          const SizedBox(height: 10),
          CredentialField(
            padding: EdgeInsets.zero,
            title: l10n.subjectDID,
            value: subjectDid,
            titleColor: Theme.of(context).colorScheme.titleColor,
            valueColor: Theme.of(context).colorScheme.valueColor,
          ),
        ],
        const SizedBox(height: 10),
        CredentialField(
          padding: EdgeInsets.zero,
          title: l10n.type,
          value: type,
          titleColor: Theme.of(context).colorScheme.titleColor,
          valueColor: Theme.of(context).colorScheme.valueColor,
        ),
      ],
    );
  }
}
