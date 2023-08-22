import 'package:altme/dashboard/dashboard.dart';
import 'package:flutter/material.dart';

class DefaultCredentialWidget extends StatelessWidget {
  const DefaultCredentialWidget({
    super.key,
    required this.credentialModel,
    this.showBgDecoration = true,
    this.descriptionMaxLine = 2,
  });

  final CredentialModel credentialModel;
  final int descriptionMaxLine;
  final bool showBgDecoration;

  @override
  Widget build(BuildContext context) {
    final outputDescriptors =
        credentialModel.credentialManifest?.outputDescriptors;
    // If outputDescriptor exist, the credential has a credential manifest
    // telling us what to display

    if (outputDescriptors == null) {
      return DefaultDisplayDescriptor(
        credentialModel: credentialModel,
        descriptionMaxLine: descriptionMaxLine,
        showBgDecoration: showBgDecoration,
      );
    } else {
      return CredentialManifestCard(
        credentialModel: credentialModel,
        outputDescriptor: outputDescriptors.first,
        showBgDecoration: showBgDecoration,
      );
    }
  }
}
